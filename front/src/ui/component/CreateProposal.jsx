import ServiceVoting from "../../service/ServiceVoting.jsx";
import {Button, Form, FormControl, FormGroup, FormLabel} from "react-bootstrap";
import {useContext} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";

const CreateProposal = () => {

    const {wallet} = useContext(AtlantContext);

    const createProposal = async(e) => {
        e.preventDefault();
        try {
            const _delay = e.target[0].value;
            const _period = e.target[1].value;
            const targets = e.target[2].value;
            const amount = e.target[3].value;
            const description = e.target[4].value;
            const proposalType = e.target[5].value;
            const quorumType = e.target[6].value;
            await ServiceVoting.createProposal(_delay, _period, targets, amount, description, proposalType, quorumType, wallet);
            alert("предложение успешно создано")
        } catch (e) {
            alert("не получилось создать предложение")
            console.log(e);
        }
    }
    return (
        <div className="container">
            <h2> создание предложения </h2>
            <Form onSubmit={createProposal}>

                <FormGroup>
                    <FormLabel column={1}> задержка перед голосованием </FormLabel>
                    <FormControl type="number" placeholder="время в секундах" min="0"/>
                </FormGroup>

                <FormGroup>
                    <FormLabel column={1}> длительность голосования  </FormLabel>
                    <FormControl type="number" placeholder="время в секундах" min="0" />
                </FormGroup>

                <FormGroup>
                    <FormLabel column={1}> адрес куда инвестьириуете или участника которорго хотите добавить/удалить из дао</FormLabel>
                    <FormControl type="text" placeholder="0x7Ee440B1FAf1d6955faFBBB1a1ADD97a9330d57b"/>
                </FormGroup>

                <FormGroup>
                    <FormLabel column={1}> количество которое хотите инвестировать или на которое хотите изменить силу токена</FormLabel>
                    <FormControl type="number" placeholder="1000" min="0"/>
                </FormGroup>


                <FormGroup>
                    <FormLabel column={1}> описание </FormLabel>
                    <FormControl type="text" placeholder="ехало ехало"/>
                </FormGroup>


                <FormGroup>
                    <FormLabel column={1}> тип голосования</FormLabel>
                    <FormControl as="select">
                        <option value="0">A</option>
                        <option value="1">B</option>
                        <option value="2">C</option>
                        <option value="3">D</option>
                        <option value="4">E</option>
                        <option value="5">F</option>
                    </FormControl>
                </FormGroup>


                <FormGroup>
                    <FormLabel column={1}> </FormLabel>
                    <FormControl as="select">
                        <option value="0"> SuperMajority</option>
                        <option value="1"> SimpleMajority</option>
                        <option value="2"> Weigth </option>
                    </FormControl>
                </FormGroup>


                <Button variant="primary" type="submit"> создать </Button>
            </Form>
        </div>
    )
}
export default CreateProposal;