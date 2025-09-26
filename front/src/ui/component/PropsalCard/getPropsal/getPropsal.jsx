import { Form,  FormGroup, FormLabel} from "react-bootstrap";
import { useEffect, useState} from "react";
import ServiceVoting from "../../../../service/ServiceVoting.jsx";

const Propsals = ({proposalID}) => {


    const [propsal, setPropsal] = useState({proposalId: 0, proposer: "", targets: [], values: [], description: "", voteStart: 0, voteEnd: 0, proposeType : 0, quorumType: 0, voteStatus: 0});

    useEffect(() => {
        (async () => {
            const info = await ServiceVoting.getProposal(proposalID);

            // Приводим к удобному объекту
            const mapped = {
                proposalId: info._proposalId?.toString() || "0",
                proposer: info._proposer || "",
                targets: info._targets || [],
                values: info._values?.map(v => v.toString()) || [],
                description: info._description || "",
                voteStart: info._voteStart?.toString() || "0",
                voteEnd: info._voteEnd?.toString() || "0",
                quorumType: info._quorumType?.toString() || "0",
                proposeType: info._proposalType?.toString() || "0",
                voteStatus: info._voteStatus?.toString() || "0"
            };

            setPropsal(mapped);
            console.log("mapped proposal:", mapped);
        })();
    }, [proposalID]);

    return (

        <Form>
            <h2> информация о голосование  </h2>

            <FormGroup>
                <FormLabel column={1}>
                    ID голосования {propsal.proposalId?.toString() || 0}
                </FormLabel>
            </FormGroup>

            <FormGroup>
                <FormLabel column={1}>
                    создатель голосования {propsal.proposer?.toString() || ""}
                </FormLabel>
            </FormGroup>

            <FormGroup>
                <FormLabel column={1}>
                    указаный адрес  {propsal.targets?.toString() || ""}
                </FormLabel>
            </FormGroup>

            <FormGroup>
                <FormLabel column={1}>
                    количество {(Number(propsal.values) / 10 ** 18 || 0 )?.toFixed(0)}
                </FormLabel>
            </FormGroup>

            <FormGroup>
                <FormLabel column={1}>
                    количество {propsal.description?.toString() || "" }
                </FormLabel>
            </FormGroup>

            <FormGroup>
                <FormLabel column={1}>
                    время начала {new Date(Number(propsal.voteEnd) * 1000)?.toLocaleString() || 0}
                </FormLabel>
            </FormGroup>


            <FormGroup>
                <FormLabel column={1}>
                    время окончание {new Date(Number(propsal.voteEnd) * 1000)?.toLocaleString() || 0}
                </FormLabel>
            </FormGroup>

            <FormGroup>
                <FormLabel column={1}>
                    тип голосования {propsal.proposeType?.toString() || 0}
                </FormLabel>
            </FormGroup>

            <FormGroup>
                <FormLabel column={1}>
                    тип достижения кворума  {propsal.quorumType?.toString() || 0}
                </FormLabel>
            </FormGroup>

            <FormGroup>
                <FormLabel column={1}>
                    статус {propsal.voteStatus?.toString()  || 0}
                </FormLabel>
            </FormGroup>


        </Form>
    )
}
export default Propsals;