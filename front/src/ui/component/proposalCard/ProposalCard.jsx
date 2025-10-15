import GetVotes from "./GetVotes.jsx";
import GetProposal from "./GetProposal.jsx";

const ProposalCard = ({proposalID}) => {
    return (
        <div className="container">
            <GetProposal proposalID={proposalID} />
            <GetVotes proposalID={proposalID} />
        </div>
    )
}
export default ProposalCard;