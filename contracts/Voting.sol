// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ProfiCoin, RTKCoin} from "./Tokens.sol";
import {
    Governor,
    GovernorVotes,
    GovernorCountingSimple,
    GovernorVotesQuorumFraction,
    IVotes
} from "./GovernanceBundle.sol";

contract Voting is
    Governor,
    GovernorCountingSimple,
    GovernorVotesQuorumFraction
{
    enum QuorumType {
        SimpleMajority,
        SuperMajority,
        Weighted
    }

    enum ProposalType {
        A,
        B,
        C,
        D,
        E,
        F
    }

    enum VoteStatus {
        Accepted,
        notAccepted,
        Cancelled
    }

    struct ProposalLib {
        uint256 proposalId;
        address proposer;
        address[] targets;
        uint256[] values;
        bytes[] calldatas;
        string description;
        uint256 voteStart;
        uint256 voteEnd;
        QuorumType quorumType;
        ProposalType proposalType;
        VoteStatus voteStatus;
    }

    // общие переменные
    uint public delay = 0; // задержка перед голосованием
    uint period = 120; // длительность голосования

    uint profiPower = 3; // сила профи
    uint rtkPower = profiPower / 2; // сила ртк

    ProfiCoin profiCoin;
    RTKCoin rtkCoin;

    uint[] proposalIds; // массив из всех адресов

    // участник дао или нет
    mapping(address => bool) isMember;

    // проголосовал или нет
    mapping(uint => mapping(address => bool)) cutomHasVoted;

    // получение информации об голосовании
    mapping(uint => ProposalLib) proposalMapping;

    // получение всех проголосовавших
    mapping(uint => address[]) proposalForVotes;

    // сколько пользователь вложил токенов
    mapping(uint => mapping(address => uint)) lockedTockens;

    // получение всеx голосов
    mapping(uint => ProposalVote) proposalVote;

    // модификатор на членство в дао
    modifier onlyMember(address account) {
        require(isMember[msg.sender] = true, unicode"не участник дао");
        _;
    }

    // конструктор
    constructor(
        address Tom,
        address Ben,
        address Rick,
        address Jack,
        address _profiCoin,
        address _rtkCoin
    )
        payable
        Governor("DAO")
        GovernorVotesQuorumFraction(1)
        GovernorVotes(IVotes(_profiCoin))
    {
        profiCoin = ProfiCoin(_profiCoin);
        rtkCoin = RTKCoin(_rtkCoin);

        isMember[Tom] = true;
        isMember[Ben] = true;
        isMember[Rick] = true;

        profiCoin.delegate(Tom);
        profiCoin.delegate(Ben);
        profiCoin.delegate(Rick);
        profiCoin.delegate(Jack);

        rtkCoin.mint(address(this), 20_000_000 * 10 ** 12);
    }

    // возвращаем задержку перед голосованием
    function votingDelay() public view virtual override returns (uint) {
        return delay;
    }

    // возвращаем длительность голосования
    function votingPeriod() public view virtual override returns (uint) {
        return period;
    }

    // функци добавления участника в дао
    function addMember(address account) internal onlyGovernance {
        isMember[account] = true;
    }

    // функция удаления участника из дао
    function removeMember(address account) internal onlyGovernance {
        isMember[account] = false;
    }

    // функция измениния силы профи коина
    function setProfiPower(uint amount) internal onlyGovernance {
        profiPower = amount;
    }

    // функция измениния силы ртк коина
    function setRTKPower(uint amount) internal onlyGovernance {
        rtkPower = amount;
    }

    //функция покупки ртк коина
    function buyToken(uint amount) public payable {
        require(msg.value >= amount * rtkCoin.price(), unicode"");
        rtkCoin.transfer(address(this), msg.sender, amount);
    }

    // достигнут ли кворум по определённому голосованию
    function _quorumReached(
        uint256 proposalId
    ) internal view override(Governor, GovernorCountingSimple) returns (bool) {
        ProposalVote storage vote = proposalVote[proposalId];
        QuorumType quorumType = proposalMapping[proposalId].quorumType;

        uint256 totalVotes = vote.againstVotes + vote.forVotes;

        if (quorumType == QuorumType.Weighted) {
            // Голоса по весу: зависит от количества токенов
            return vote.forVotes > vote.againstVotes;
        } else if (quorumType == QuorumType.SuperMajority) {
            //Супер большинство: 2/3 голосов
            return vote.forVotes >= (totalVotes / 3) * 2;
        } else if (quorumType == QuorumType.SimpleMajority) {
            //Простое большинство: 50% +1 голос
            return vote.forVotes > totalVotes / 2 + 1;
        }
        revert(
            unicode"Ошибка в 'DAO._quorumReached' QuorumTypes doesn't exist"
        );
    }

    // функция создания голосования голосование
    function createProposal(
        uint _delay,
        uint _period,
        address targets,
        uint amount,
        QuorumType quorumType,
        ProposalType proposalType,
        string memory description
    ) public onlyMember(msg.sender) returns (uint) {
        address[] memory target = new address[](1);
        uint256[] memory value = new uint256[](1);
        bytes[] memory calldatas = new bytes[](1);

        delay = _delay;
        period = _period;

        if (proposalType == ProposalType.A || proposalType == ProposalType.B) {
            // переводим средства на стартап
            require(
                quorumType == QuorumType.Weighted,
                unicode"данный способ голосования не доступен для подобного типа кворума"
            );
            target[0] = targets;
            value[0] = amount * 1 ether;
            calldatas[0] = abi.encodeWithSignature(
                "transfer(uint256)",
                amount * 1 ether
            );
        } else if (proposalType == ProposalType.C) {
            // добавление участника в дао
            require(
                quorumType == QuorumType.SimpleMajority ||
                    quorumType == QuorumType.SuperMajority,
                unicode"данный способ голосования не доступен для подобного типа кворума"
            );
            target[0] = targets;
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "addMember(address), target"
            );
        } else if (proposalType == ProposalType.D) {
            // удаление участника из дао
            require(
                quorumType == QuorumType.SimpleMajority ||
                    quorumType == QuorumType.SuperMajority,
                unicode"данный способ голосования не доступен для подобного типа кворума"
            );
            target[0] = targets;
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "removeMember(address), target"
            );
        } else if (proposalType == ProposalType.E) {
            //изменения силы профи
            require(
                quorumType == QuorumType.SimpleMajority ||
                    quorumType == QuorumType.SuperMajority,
                unicode"данный способ голосования не доступен для подобного типа кворума"
            );
            target[0] = targets;
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "setProfiPower(uint256), amount"
            );
        } else if (proposalType == ProposalType.F) {
            //изменения силы ртк
            require(
                quorumType == QuorumType.SimpleMajority ||
                    quorumType == QuorumType.SuperMajority,
                unicode"данный способ голосования не доступен для подобного типа голосования"
            );
            target[0] = targets;
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "setRTKPower(uint256), amount"
            );
        }

        uint ID = super.propose(target, value, calldatas, description);
        proposalIds.push(ID);
        proposalMapping[ID] = ProposalLib({
            proposalId: ID,
            proposer: msg.sender,
            targets: target,
            values: value,
            calldatas: calldatas,
            description: description,
            voteStart: block.timestamp + _delay,
            voteEnd: block.timestamp + _delay + _period,
            quorumType: quorumType,
            proposalType: proposalType,
            voteStatus: VoteStatus.notAccepted
        });
        return ID;
    }

    // функция голосования
    function castVote(
        uint256 proposalId,
        bool support,
        uint256 amount
    ) external {
        // запрет повторного голосования для любого адреса
        require(!cutomHasVoted[proposalId][msg.sender], unicode"Уже голосовал");

        ProposalVote storage vote = proposalVote[proposalId];
        // голосование для участника дао
        if (isMember[msg.sender]) {
            // обновляем подсчёт голосов
            if (support == true) {
                vote.forVotes += amount * profiPower;
            } else {
                vote.againstVotes += amount * profiPower;
            }
            profiCoin.transfer(msg.sender, address(this), amount);
        } else {
            // проверка: по соответствующей стороне уже есть голос
            if (support == true) {
                require(vote.forVotes > 0, "No one voted FOR yet");
                vote.againstVotes += amount * rtkPower;
            } else {
                require(vote.againstVotes > 0, "No one voted AGAINST yet");
                vote.forVotes += amount * rtkPower;
            }
            rtkCoin.transfer(msg.sender, address(this), amount);
        }

        cutomHasVoted[proposalId][msg.sender] = true;
        lockedTockens[proposalId][msg.sender] = amount;
        proposalForVotes[proposalId].push(msg.sender);
    }

    // отменить голосование
    function cancelProposal(
        uint256 proposalId
    ) external onlyMember(msg.sender) {
        ProposalLib storage prop = proposalMapping[proposalId];

        require(msg.sender == prop.proposer,unicode"Только инициатор может отменить");

        // Возвращаем токены всем проголосовавшим пользователям
        address[] storage voters = proposalForVotes[proposalId];

        for (uint256 i = 0; i < voters.length; i++) {
            address voter = voters[i];
            uint256 amount = lockedTockens[proposalId][voter];
            if (isMember[msg.sender]) {
                profiCoin.transfer(address(this), voter, amount);
            } else {
                rtkCoin.transfer(address(this), voter, amount);
            }
            lockedTockens[proposalId][voter] = 0; // Обнуляем заблокированные токены
        }
        bytes32 hashDescription = keccak256(bytes(prop.description));
        super.cancel(
            prop.targets,
            prop.values,
            prop.calldatas,
            hashDescription
        );
    }

    //функция выполнения голосования
    function executeProposal(
        uint256 proposalId
    ) public payable onlyMember(msg.sender) returns (uint256) {
        proposalMapping[proposalId].voteStatus = VoteStatus.Accepted;
        bytes32 hashDescription = keccak256(bytes(proposalMapping[proposalId].description));
        return
            super.execute(
                proposalMapping[proposalId].targets,
                proposalMapping[proposalId].values,
                proposalMapping[proposalId].calldatas,
                hashDescription
            );
    }

    // получить информацию о пользователе
    function getInfoUser()
        public
        view
        returns (uint profiBalance, uint rtkBalace, bool isDao)
    {
        profiBalance = profiCoin.balanceOf(msg.sender);
        rtkBalace = rtkCoin.balanceOf(msg.sender);
        isDao = isMember[msg.sender];
    }

    // получить все айди голосований
    function getProposalIds() public view returns (uint[] memory idPropsals) {
        idPropsals = proposalIds;
    }

    // получить информацию о голосовании
    function getProposal(
        uint proposalId
    )
        public
        view
        returns (
            uint _proposalId,
            address _proposer,
            address[] memory _targets,
            uint[] memory _values,
            string memory _description,
            uint _voteStart,
            uint _voteEnd,
            QuorumType _quorumType,
            ProposalType _proposalType,
            VoteStatus _voteStatus
        )
    {
        ProposalLib storage prop = proposalMapping[proposalId];
        _proposalId = proposalId;
        _proposer = prop.proposer;
        _targets = prop.targets;
        _values = prop.values;
        _description = prop.description;
        _voteStart = prop.voteStart;
        _voteEnd = prop.voteEnd;
        _quorumType = prop.quorumType;
        _proposalType = prop.proposalType;
        _voteStatus = prop.voteStatus;
    }

    // получит количество голосов
    function getProposalVotes(
        uint256 proposalID
    ) external view returns (uint256 forVotes, uint256 againstVotes) {
        ProposalVote storage vote = proposalVote[proposalID];
        return (vote.forVotes, vote.againstVotes);
    }
}
