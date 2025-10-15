import CreateProposal from "../component/CreateProposal.jsx";
import CastVote from "../component/CastVote.jsx";
import CancelProposal from "../component/CancelProposal.jsx";
import ExecuteProposal from "../component/ExecuteProposal.jsx";
import Header from "../component/Header.jsx";
import Delegate from "../component/Delegate.jsx";

const FunctionPages = () => {
    return (
        <div>
            <Header/>
            <CreateProposal/>
            <CastVote/>
            <Delegate/>
            <CancelProposal/>
            <ExecuteProposal/>
        </div>
    )
}
export default FunctionPages
