import {Web3} from "web3";
import abi from "./abi.json";

class ServiceVoting {

    web3 = new Web3(window.ethereum);
    contractAddess = "0x988842ec93B8EFb991D99449F2B223e554F2dec7";
    contract = new this.web3.eth.Contract(abi, this.contractAddess);

    async buyToken(amount, valueAmount, wallet){
        await this.contract.methods.buyToken(amount).send({from: wallet, value: valueAmount});
    }

    async delegateRTK(account, wallet){
        await this.contract.methods.delegateRTK(account).send({from: wallet});
    }
    async createProposal( delay, period, targets, amount, proposeType, quorumType,  wallet, description) {
        await this.contract.methods.createProposal( delay, period, targets, amount, proposeType, quorumType,  wallet, description).send({from: wallet});
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

    async getProposalIds(wallet){
       return await this.contract.methods.getProposalIds().call({from: wallet});
    }


    async getInfoUser(wallet) {
        return await this.contract.methods.getInfoUser().call({ from: wallet });
    }

    async getProposal(proposalId) {
        return await this.contract.methods.getProposal(proposalId).call();
    }

    async getProposalVotes(proposalId) {
        return await this.contract.methods.getProposalVotes(proposalId).call();
    }

}
export default new ServiceVoting();