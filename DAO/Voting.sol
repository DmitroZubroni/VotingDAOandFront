// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ProfiCoin, RTKCoin} from "./Tokens.sol";
import {
    Governor,
    GovernorVotes,
    IVotes,
    GovernorCountingSimple,
    GovernorVotesQuorumFraction
} from "./GovernanceBundle.sol";

contract Voting is
    Governor,
    GovernorCountingSimple,
    GovernorVotesQuorumFraction
{
    enum QuorumType {
        SuperMajority,
        SimpleMajority,
        Weigth
    }

    enum ProposalType {
        A,
        B,
        C,
        D,
        E,
        F
    }

    enum ProposalStatus {
        Acceped,
        NotAcceped,
        Canceled
    }
    //структура голосования
    struct ProposalLib {
        uint256 proposalId;
        address proposer;
        address[] targets;
        uint256[] values;
        bytes[] calldatas;
        uint256 voteStart;
        uint256 voteEnd;
        string description;
        ProposalType proposalType;
        QuorumType quorumType;
        ProposalStatus status;
    }

    uint delay = 0; // задержка перед голосованием
    uint period = 12; // длительность голосования

    uint profiPower = 3; // сила профи токена
    uint del = 2; // делитель ртк
    uint rtkPower = profiPower / del; // сила ртк токена

    ProfiCoin profiCoin;
    RTKCoin rtkCoin;

    uint[] proposalIds; // все айди предложения

    // участник дао или нет
    mapping(address => bool) isMember;

    // проголосовал или нет
    mapping(uint => mapping(address => bool)) customHasVoted;

    // количество токенов которым проголосовал
    mapping(uint => mapping(address => uint)) lockedTokens;

    // все делегации пользователя
    mapping(address => uint[]) lockedDelegate;

    // получение всех проголосовавшиз по определённому предложению
    mapping(uint => address[]) proposalForVotes;

    // получение структуры голосования
    mapping(uint => ProposalLib) proposalMapping;

    // получение голосов в голосовании
    mapping(uint => ProposalVote) proposalVote;

    constructor(
        address tom,
        address ben,
        address rick,
        address _profiCoin,
        address _rtkCoin
    )
        Governor("DAO")
        GovernorVotesQuorumFraction(1)
        GovernorVotes(IVotes(_profiCoin))
    {
        profiCoin = ProfiCoin(_profiCoin);
        rtkCoin = RTKCoin(_rtkCoin);

        isMember[tom] = true;
        isMember[ben] = true;
        isMember[rick] = true;

        rtkCoin.mint(address(this), 20_000_000 * 10 ** 12);
    }

    //возвращение задержки перед голосованием
    function votingDelay() public view override returns (uint256) {
        return delay;
    }

    // возвращение длительности голосования
    function votingPeriod() public view override returns (uint256) {
        return period;
    }

    // добавление участника в дао
    function addMember(address account) public onlyGovernance {
        isMember[account] = true;
    }

    // удаление участника из дао
    function removeMember(address account) public onlyGovernance {
        isMember[account] = false;
    }

    // изменение силы профи токена
    function setProfiPower(uint amount) public onlyGovernance {
        profiPower = amount;
    }

    // изменение силы ртк токена
    function setRTKPower(uint amount) public onlyGovernance {
        del = amount;
    }

    //функция покупки токена
    function buyToken(uint amount) external payable {
        require(msg.value >= amount * rtkCoin.price());
        rtkCoin.transferCustom(address(this), msg.sender, amount * 10 ** 12);
    }

    /*
    проверка достижения кворума
    функция снача определяет какой ти кворума у определённого предложения 
    после чего проверяет достижение кворума 
    */

    function _quorumReached(
        uint proposalId
    )
        internal
        view
        virtual
        override(Governor, GovernorCountingSimple)
        returns (bool)
    {
        ProposalVote storage vote = proposalVote[proposalId];
        QuorumType quorumType = proposalMapping[proposalId].quorumType;
        uint totalVotes = vote.forVotes + vote.againstVotes;

        if (quorumType == QuorumType.SuperMajority) {
            return vote.forVotes >= ((totalVotes * 2) / 3);
        } else if (quorumType == QuorumType.SimpleMajority) {
            return vote.forVotes > totalVotes / 2 + 1;
        } else if (quorumType == QuorumType.Weigth) {
            return vote.forVotes > vote.againstVotes;
        }
        return false;
    }

    /*
    функция создания предложения 
    сначала она определяет какой тип голосования мы указали, после проверяет подходит ли выбранный нами тип кворума 
    для данного типа голосования если всё сходится то создаётся предложение
    */
    function createProposal(
        uint _delay,
        uint _period,
        address targets,
        uint amount,
        string memory description,
        ProposalType proposalType,
        QuorumType quorumType
    ) external {
        require(isMember[msg.sender] == true, "no no no you not dao");

        address[] memory target = new address[](1);
        uint[] memory value = new uint[](1);
        bytes[] memory calldatas = new bytes[](1);

        if (proposalType == ProposalType.A) {
            require(quorumType == QuorumType.Weigth, "no type");
            target[0] = ;
            value[0] = amount;
           calldatas[0] = abi.encodeWithSignature();
        } else if (proposalType == ProposalType.B) {
            require(quorumType == QuorumType.Weigth, "no type");
            target[0] = ;
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature();
        } else if (proposalType == ProposalType.C) {
            require(
                quorumType == QuorumType.SuperMajority ||
                    quorumType == QuorumType.SimpleMajority,
                "no type"
            );
            target[0] = address(this);
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "addMember(address)",
                targets
            );
        } else if (proposalType == ProposalType.D) {
            require(
                quorumType == QuorumType.SuperMajority ||
                    quorumType == QuorumType.SimpleMajority,
                "no type"
            );
            target[0] = address(this);
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "removeMember(address)",
                targets
            );
        } else if (proposalType == ProposalType.E) {
            require(
                quorumType == QuorumType.SuperMajority ||
                    quorumType == QuorumType.SimpleMajority,
                "no type"
            );
            target[0] = address(this);
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "setProfiPower(uint256)",
                amount
            );
        } else if (proposalType == ProposalType.F) {
            require(
                quorumType == QuorumType.SuperMajority ||
                    quorumType == QuorumType.SimpleMajority,
                "no type"
            );
            target[0] = address(this);
            value[0] = amount;
            calldatas[0] = abi.encodeWithSignature(
                "setRTKPower(uint256)",
                amount
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
            voteStart: block.timestamp + _delay,
            voteEnd: block.timestamp + _delay + _period,
            description: description,
            proposalType: proposalType,
            quorumType: quorumType,
            status: ProposalStatus.NotAcceped
        });
    }

    /*
    функция голосования 
    сначал проверяет участник ли ты дао или нет
    голосовал ты или ещё нет
    потом определяет голосуешь ли ты за или против и записывает в структуру 
    */
    function castVote(uint proposalId, bool support, uint amount) external {
        require(isMember[msg.sender] == true, "no no no you not dao");
        require(!customHasVoted[proposalId][msg.sender], "you voted");
        ProposalVote storage vote = proposalVote[proposalId];

        if (support == true) {
            vote.forVotes += amount * profiPower;
        } else {
            vote.againstVotes += amount * profiPower;
        }
        profiCoin.transferCustom(msg.sender, address(this), amount);
        customHasVoted[proposalId][msg.sender] = true;
        lockedTokens[proposalId][msg.sender] = amount;
        proposalForVotes[proposalId].push(msg.sender);
    }

    /*
    функция делегации 
    сначала проверка на то голосовал ты или ещё нет
    потом определяет голосуешь ли ты за или против и записывает в структуру 
    */
    function delegate(uint proposalId, bool support, uint amount) external {
        require(!customHasVoted[proposalId][msg.sender], "you voted");
        require(isMember[msg.sender] == false, "no no no you dao");
        ProposalVote storage vote = proposalVote[proposalId];

        if (support == true) {
            require(vote.forVotes > 0, "no no no mister fish you 6");
            vote.forVotes += amount * rtkPower;
        } else {
            require(vote.againstVotes > 0, "no no no mister fish you 6");
            vote.againstVotes += amount * rtkPower;
        }
        rtkCoin.transferCustom(msg.sender, address(this), amount);
        customHasVoted[proposalId][msg.sender] = true;
        lockedTokens[proposalId][msg.sender] = amount;
        proposalForVotes[proposalId].push(msg.sender);
        lockedDelegate[msg.sender].push(proposalId);
    }

    /*
    функция отмены предложения 
    проверяет что вы участник дао проходится по всем проголосовавшим
    смотрит кто сколько вложил и в зависимости от тогог кем пользователь
    является переводит ему токены
    */
    function cancelProposal(uint proposalId) external {
        require(
            proposalMapping[proposalId].proposer == msg.sender,
            "not proposer"
        );

        address[] memory voters = proposalForVotes[proposalId];

        for (uint i = 0; i < voters.length; i++) {
            uint amount = lockedTokens[proposalId][voters[i]];
            address voter = voters[i];
            if (isMember[voter] == true) {
                profiCoin.transferCustom(address(this), voter, amount);
            } else {
                rtkCoin.transferCustom(address(this), voter, amount);
            }
            lockedTokens[proposalId][voter] = 0;
        }
        proposalMapping[proposalId].status = ProposalStatus.Canceled;
    }

    /*
    функция выполнения предложения 
    вызывает функцияю governance execute с параметрами из предложения
    */
    function executeProposal(uint proposalId) external payable {
        require(
            proposalMapping[proposalId].status != ProposalStatus.Canceled,
            "proposal canceled"
        );
        bytes32 hashDescription = keccak256(
            bytes(proposalMapping[proposalId].description)
        );
        super.execute(
            proposalMapping[proposalId].targets,
            proposalMapping[proposalId].values,
            proposalMapping[proposalId].calldatas,
            hashDescription
        );
        proposalMapping[proposalId].status = ProposalStatus.Acceped;
    }

    // возвращаем информацию о пользователе
    function getPersonIfo()
        external
        view
        returns (bool isDAO, uint profiBalance, uint rtkBalance)
    {
        return (
            isMember[msg.sender],
            profiCoin.balanceOf(msg.sender),
            rtkCoin.balanceOf(msg.sender)
        );
    }

    // возвращаем все айди голосований
    function getProposalIds()
        external
        view
        returns (uint[] memory _proposalIds)
    {
        return proposalIds;
    }

    // получаем информацию о голосовании
    function getProposal(
        uint proposalId
    )
        external
        view
        returns (
            uint256 _proposalId,
            address _proposer,
            address[] memory _targets,
            uint256[] memory _values,
            uint256 _voteStart,
            uint256 _voteEnd,
            string memory _description,
            ProposalType _proposalType,
            QuorumType _quorumType,
            ProposalStatus _status
        )
    {
        ProposalLib memory prop = proposalMapping[proposalId];
        _proposalId = prop.proposalId;
        _proposer = prop.proposer;
        _targets = prop.targets;
        _values = prop.values;
        _voteStart = prop.voteStart;
        _voteEnd = prop.voteEnd;
        _description = prop.description;
        _proposalType = prop.proposalType;
        _quorumType = prop.quorumType;
        _status = prop.status;
    }

    // получаем количесвто голосов
    function getVotes(
        uint proposalId
    ) external view returns (uint _forVotes, uint _againstVotes) {
        ProposalVote storage vote = proposalVote[proposalId];

        _forVotes = vote.forVotes;
        _againstVotes = vote.againstVotes;
    }

    // просмотр делегаций
    function getDelegate() external view returns (uint[] memory _getDelegete) {
        return lockedDelegate[msg.sender];
    }
}
