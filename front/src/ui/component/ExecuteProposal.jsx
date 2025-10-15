import ServiceVoting from "../../service/ServiceVoting.jsx";
import {Button, Form, FormControl, FormGroup, FormLabel} from "react-bootstrap";
import {useContext} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";

const ExecuteProposal = () => {

    const {wallet} = useContext(AtlantContext);

    const executeProposal = async(e) => {
        e.preventDefault();
        try {
            const proposalId = e.target[0].value;
            const valueAmount = e.target[1].value * 10 ** 12;
            await ServiceVoting.executeProposal(proposalId, wallet, valueAmount);
            alert("предложение выполнено")
        } catch (e) {
            alert("не получилось выполнить предложение")
            console.log(e);
        }
    }
    return (
        <div className="container">
            <h2> выполнение предложения</h2>
            <Form onSubmit={executeProposal}>

                <FormGroup>
                    <FormLabel column={1}> айди голосования </FormLabel>
                    <FormControl type="text" placeholder="80989525426983789786532723646894131520352734914175411181708226143236193487175"/>
                </FormGroup>

                <FormGroup>
                    <FormLabel column={1}> количество эфира </FormLabel>
                    <FormControl type="number" placeholder="количество необходимое для выполнения" min="1"/>
                </FormGroup>

                <Button variant="primary" type="submit"> выполнить</Button>
            </Form>
        </div>
    )
}
export default ExecuteProposal;