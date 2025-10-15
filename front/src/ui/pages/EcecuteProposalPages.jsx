import React, {useContext, useEffect, useState} from "react";
import Header from "../component/Header.jsx";
import ServiceVoting from "../../service/ServiceVoting.jsx";
import {AtlantContext} from "../../core/context/Context.jsx";
import {FormLabel} from "react-bootstrap";

const ExecutedProposals = () => {

    const {proposals} = useContext(AtlantContext);
    const [proposalsExecute, setProposalsExecute] = useState([]);

    useEffect(() => {
        (async () => {
            const allProposals = await ServiceVoting.getProposal(proposals);
            const executed = allProposals.filter(p => p.status === "Executed");
            setProposalsExecute(executed);
        })();
    }, []);

    return (
        <div>
            <Header />
            <h2 className="container">Исполненные предложения</h2>

            {proposalsExecute.length === 0 ? (
                <h2 className="container">Пока нет исполненных предложений.</h2>
            ) : (


                proposalsExecute.map((p, i) => (
                    <div key={i} className="card mb-3 p-3">
                        <FormLabel column={1}> айди голосования {p._proposalId?.toString()}</FormLabel>
                    </div>
                ))
            )}
        </div>
    );
};

export default ExecutedProposals;