import {Web3} from "web3";
import abi from "./abi.json";

class ServiceVoting {

    web3 = new Web3(window.ethereum);
    contractAddess = "0xBCf0831a5B19D825cBbD83e93DB4dBd55289ddB4";
    contract = new this.web3.eth.Contract(abi, this.contractAddess);

    async buyToken(amount, valueAmount, wallet){
        await this.contract.methods.buyToken(amount).send({from: wallet, value: valueAmount});
    }

    async createProposal( delay, period, targets, amount, quorumType, proposeType,   wallet, description) {
        await this.contract.methods.createProposal( delay, period, targets, amount, quorumType, proposeType, wallet, description).send({from: wallet});
    }

    async castVote(proposalId, support, amount, wallet){
        await this.contract.methods.castVote(proposalId, support, amount).send({from: wallet});
    }

    async cancelProposal(proposalId, wallet) {
        await this.contract.methods.cancelProposal(proposalId).send({from: wallet});
    }

    async executeProposal(proposalId, valueAmount, wallet) {
        await this.contract.methods.executeProposal(proposalId).send({from: wallet, value: valueAmount});
    }

    async getAllProposalIDs(wallet){
       return await this.contract.methods.getAllProposalIDs().call({from: wallet});
    }


    async getPerson(wallet) {
        return await this.contract.methods.getBalance().call({ from: wallet });
    }

    async getProposalFull(proposalId) {
        return await this.contract.methods.getProposalFull(proposalId).call();
    }

    async getProposalVotes(proposalId) {
        return await this.contract.methods.getProposalVotes(proposalId).call();
    }

}
export default new ServiceVoting();
