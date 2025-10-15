import {useEffect, useState} from "react";
import {FormLabel} from "react-bootstrap";
import ServiceVoting from "../../../service/ServiceVoting.jsx";

const GetVotes = ( { proposalID } ) => {

    const [vote, setVote] = useState({_forVotes: 0, _againstVotes: 0});

    useEffect(() => {
        (async () => {
            const info = await ServiceVoting.getVotes(proposalID);
            setVote(info)
            console.log(info);
        })()
    },[proposalID])

    return (
        <div >
            <h3> проголосовали</h3>
            <FormLabel column={1}> голоса за - {(Number(vote._forVotes) / 10 ** 12)?.toString() || 0}</FormLabel>
            <hr/>
            <FormLabel column={1}> голоса против - {(Number(vote._againstVotes) / 10 ** 12)?.toString() || 0} </FormLabel>
        </div>
    )
}

export default GetVotes