import {Web3} from "web3";
import abi from "./abi.json"

class ServiceVoting {

    web3 = new Web3(window.ethereum)
    contractAddress = "0xc253E0839b8c21F109Cb12e0b1b158472A452569"
    contract = new this.web3.eth.Contract(abi, this.contractAddress)

    async buyToken(amount, wallet, valueAmount) {
        await this.contract.methods.buyToken(amount).send({from: wallet, value: valueAmount})
    }

    async createProposal(_delay, _period, targets, amount, description, proposalType, quorumType, wallet) {
        await this.contract.methods.createProposal(_delay, _period, targets, amount, description, proposalType, quorumType).send({from: wallet})
    }

    async castVote(proposalId,  support,  amount, wallet) {
        await this.contract.methods.castVote(proposalId,  support,  amount).send({from: wallet})
    }

    async delegate(proposalId,  support,  amount, wallet) {
        await this.contract.methods.delegate(proposalId,  support,  amount).send({from: wallet})
    }

    async cancelProposal(proposalId, wallet) {
        await this.contract.methods.cancelProposal(proposalId).send({from: wallet})
    }

    async executeProposal(proposalId, wallet, valueAmount) {
        await this.contract.methods.executeProposal(proposalId).send({from: wallet, value: valueAmount})
    }

    async getPersonIfo( wallet) {
       return await this.contract.methods.getPersonIfo().call({from: wallet})
    }

    async getProposalIds( ) {
        return await this.contract.methods.getProposalIds().call()
    }

    async getProposal(proposalId) {
        return await this.contract.methods.getProposal(proposalId).call()
    }

    async getVotes(proposalId) {
        return await this.contract.methods.getVotes(proposalId).call()
    }

    async getDelegate( wallet) {
        return await this.contract.methods.getDelegate().call({from: wallet})
    }

}
export default new ServiceVoting()