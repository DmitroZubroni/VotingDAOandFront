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
    event CreatedProposal(
        uint256 proposalId,
        address proposer,
        address[] targets,
        uint256[] values,
        string description,
        uint256 voteStart,
        uint256 voteEnd,
        ProposalType proposalType
    );

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
    uint period = 12; // длительность голосования

    uint profiPower = 3; // сила профи
    uint rtkPower = 6; // сила ртк

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

    // добавить участника в дао
    function addMember(address account) internal onlyGovernance {
        isMember[account] = true;
    }

    // удалить участника из дао
    function removeMember(address account) internal onlyGovernance {
        isMember[account] = false;
    }

    // изменить силу профи коина
    function setProfiPower(uint amount) internal onlyGovernance {
        profiPower = amount;
    }

    // изменить силу ртк коина
    function setRTKPower(uint amount) internal onlyGovernance {
        rtkPower = amount;
    }

    //
    function buyToken(uint amount) public payable {
        require(msg.value >= amount * rtkCoin.price(), "Not enough money");
        rtkCoin.transfer(address(this), msg.sender, amount);
    }

    // делегировать токены
    function delegateRTK(address account, uint amount) external {
        require(isMember[account], "Not a member");
        rtkCoin.delegate(account);
        rtkCoin.transfer(msg.sender, account, amount);
    }

    // вычислить силу голоса
    function calculatePower(
        address account,
        uint amount
    ) public view returns (uint) {
        uint profiP = amount / profiPower;
        uint rtkP = rtkCoin.balanceOf(account) / rtkPower;
        return profiP + rtkP;
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
            return vote.forVotes * 3 > totalVotes * 2;
        } else if (quorumType == QuorumType.SimpleMajority) {
            //Простое большинство: 50% +1 голос
            return vote.forVotes > totalVotes / 2 + 1;
        }
        revert(
            unicode"Ошибка в 'DAO._quorumReached' QuorumTypes doesn't exist"
        );
    }

    // создать голосование
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
                unicode"данный способ голосования не доступен для подобного типа голосования"
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
                quorumType == QuorumType.SimpleMajority &&
                    quorumType == QuorumType.SuperMajority,
                unicode"данный способ голосования не доступен для подобного типа голосования"
            );
            target[0] = targets;
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "addMember(address), target"
            );
        } else if (proposalType == ProposalType.D) {
            // удаления участника из дао
            require(
                quorumType == QuorumType.SimpleMajority &&
                    quorumType == QuorumType.SuperMajority,
                unicode"данный способ голосования не доступен для подобного типа голосования"
            );
            target[0] = targets;
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "removeMember(address), target"
            );
        } else if (proposalType == ProposalType.E) {
            //изменения силы профи
            require(
                quorumType == QuorumType.SimpleMajority &&
                    quorumType == QuorumType.SuperMajority,
                unicode"данный способ голосования не доступен для подобного типа голосования"
            );
            target[0] = targets;
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "setProfiPower(uint), amount"
            );
        } else if (proposalType == ProposalType.F) {
            //изменения силы ртк
            require(
                quorumType == QuorumType.SimpleMajority &&
                    quorumType == QuorumType.SuperMajority,
                unicode"данный способ голосования не доступен для подобного типа голосования"
            );
            target[0] = targets;
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature("setRTKPower(uint), amount");
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
            voteStart: block.timestamp + delay,
            voteEnd: block.timestamp + delay + period,
            quorumType: quorumType,
            proposalType: proposalType,
            voteStatus: VoteStatus.notAccepted
        });
        emit CreatedProposal(
            ID,
            msg.sender,
            target,
            value,
            description,
            block.timestamp + delay,
            block.timestamp + delay + period,
            proposalType
        );
        return ID;
    }

    // проголосовать
    function castVote(
        uint256 proposalId,
        bool support,
        uint256 amount
    ) public onlyMember(msg.sender) returns (uint256) {
        require(!cutomHasVoted[proposalId][msg.sender], unicode"Уже голосовал");

        ProposalVote storage vote = proposalVote[proposalId];

        uint256 weight = calculatePower(msg.sender, amount);

        if (support == false) {
            vote.againstVotes += weight;
        } else if (support == true) {
            vote.forVotes += weight;
        }
        profiCoin.transfer(msg.sender, address(this), amount);
        cutomHasVoted[proposalId][msg.sender] = true;
        // Сохраняем только количество заблокированных токенов
        lockedTockens[proposalId][msg.sender] = amount;
        // Добавляем пользователя в список проголосовавших
        proposalForVotes[proposalId].push(msg.sender);
        return amount;
    }

    // отменить голосование
    function cancelProposal(
        uint256 proposalId
    ) external onlyMember(msg.sender) {
        ProposalLib storage prop = proposalMapping[proposalId];

        require(
            msg.sender == prop.proposer,
            unicode"Только инициатор может отменить"
        );

        // Возвращаем токены всем проголосовавшим пользователям
        address[] storage voters = proposalForVotes[proposalId];

        for (uint256 i = 0; i < voters.length; i++) {
            address voter = voters[i];
            uint256 amount = lockedTockens[proposalId][voter];
            if (amount > 0) {
                profiCoin.transfer(address(this), voter, amount);
                lockedTockens[proposalId][voter] = 0; // Обнуляем заблокированные токены
            }
        }
        proposalMapping[proposalId].voteStatus = VoteStatus.Cancelled;
        super.cancel(
            prop.targets,
            prop.values,
            prop.calldatas,
            keccak256(abi.encodePacked(""))
        );
        emit ProposalCanceled(proposalId);
    }

    //выполненить  голосования
    function executeProposal(
        uint256 proposalId
    ) public payable onlyMember(msg.sender) returns (uint256) {
        proposalMapping[proposalId].voteStatus = VoteStatus.Accepted;
        return
            super.execute(
                proposalMapping[proposalId].targets,
                proposalMapping[proposalId].values,
                proposalMapping[proposalId].calldatas,
                ""
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
    function getProposalIds()
        public
        view
        returns (uint[] memory idPropsals)
    {
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
