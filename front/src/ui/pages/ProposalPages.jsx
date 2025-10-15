import Header from "../component/Header.jsx";
import ProposalCard from "../component/proposalCard/ProposalCard.jsx";
import {useContext} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";

const ProposalPages = () => {

    const {proposals} = useContext(AtlantContext);

    return (
        <div>
            <Header />
            {
                proposals.length > 0 ?
                    (
                        proposals.map((proposal, index) => {
                            return (
                                <div key={index}>
                                    <ProposalCard proposalID={proposal} />
                                </div>
                            )
                            })
                    ) :
                    <h2 className="container"> пока не было создано голосований </h2>
            }

        </div>
    )
}
export default ProposalPages