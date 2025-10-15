import {useEffect, useState} from "react";
import ServiceVoting from "../../../service/ServiceVoting.jsx";
import {FormLabel} from "react-bootstrap";

const GetProposal = ({proposalID}) => {

    const [propInfo, setPropInfo] = useState({_proposalId: "",  _proposer: "",  _targets: [],  _values: [],  _voteStart: 0,  _voteEnd: 0,  _description: "",  _proposalType: 0,  _quorumType: 0,  _status: 0 });

    useEffect(() => {
        (async () => {
            const info = await ServiceVoting.getProposal(proposalID);
            setPropInfo(info);
            console.log(info);
        }) ()
    }, [proposalID]);

    return (
        <div >
            <h2> информация о предложении </h2>
            <FormLabel column={1}> айди голосования - {propInfo._proposalId?.toString() || ""} </FormLabel>
            <hr/>

            <FormLabel column={1}> создатель голосования - {propInfo._proposer?.toString() || ""}</FormLabel>
            <hr/>

            <FormLabel column={1}> адрес - {propInfo._targets[0]?.toString() || ""} </FormLabel>
            <hr/>

            <FormLabel column={1}> количество - {propInfo._values[0]?.toString() || ""} </FormLabel>
            <hr/>

            <FormLabel column={1}> начало голосования - {(new Date(Number(propInfo._voteStart) * 1000))?.toLocaleString() || 0}</FormLabel>
            <hr/>

            <FormLabel column={1}> конец голосования - {(new Date(Number(propInfo._voteEnd) * 1000))?.toLocaleString() || 0} </FormLabel>
            <hr/>

            <FormLabel column={1}> описание - {propInfo._description?.toString() || ""}</FormLabel>
            <hr/>

            <FormLabel column={1}> тип голосования - {propInfo._proposalType?.toString() || 0}  </FormLabel>
            <hr/>

            <FormLabel column={1}> тип кворума - {propInfo._quorumType?.toString() || 0} </FormLabel>
            <hr/>

            <FormLabel column={1}> статус {propInfo._status?.toString() || 0} </FormLabel>
            <hr/>

        </div>
    )
}
export default GetProposal