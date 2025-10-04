import {Button, Form, FormControl, FormGroup, FormLabel} from "react-bootstrap";
import ServiceVoting from "../../../service/ServiceVoting.jsx";
import {useContext} from "react";
import {AppContext} from "../../../core/context/Context.jsx";

const ExecuteProposal = () => {

    const {wallet } = useContext(AppContext);

    const handleSubmit = async e => {
        e.preventDefault();
        const proposalID = Number(e.target[0].value);
        const valueAmount = Number(e.target[1].value);
        await ServiceVoting.executeProposal(proposalID, valueAmount ,wallet);
    };

    return (
        <Form className='container' onSubmit={handleSubmit}>
            <h2> исполнение предложения </h2>
            <FormGroup>
                <FormLabel column={1}>
                    ID предложения
                </FormLabel>

                <FormControl type="number" placeholder="1, 2, 3 ..." min={1}/>

            </FormGroup>

            <FormGroup>
                <FormLabel column={1}>
                    количество ether
                </FormLabel>

                <FormControl type="number" placeholder="1, 2, 3 ..." min={1}/>

            </FormGroup>

            <Button type="submit" color="primary"> исполнить  </Button>
        </Form>
    )
}
export default ExecuteProposal;