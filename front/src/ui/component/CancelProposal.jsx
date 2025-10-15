import ServiceVoting from "../../service/ServiceVoting.jsx";
import {Button, Form, FormControl, FormGroup, FormLabel} from "react-bootstrap";
import {useContext} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";

const CancelProposal = () => {

    const {wallet} = useContext(AtlantContext);

    const handleSubmit = async(e) => {
        e.preventDefault();
        try {
            const proposalId = e.target[0].value;
            await ServiceVoting.cancelProposal(proposalId, wallet);
            alert("предложение отменено")
        } catch (e) {
            alert("не получилось отменить предложение")
            console.log(e);
        }
    }

    return (
        <div className="container">
            <h2> отмена предложения </h2>
            <Form onSubmit={handleSubmit}>

                <FormGroup>
                    <FormLabel column={1}> айди голосования </FormLabel>
                    <FormControl type="text" placeholder="80989525426983789786532723646894131520352734914175411181708226143236193487175"/>
                </FormGroup>

                <Button variant="primary" type="submit"> отменить </Button>
            </Form>
        </div>
    )
}
export default CancelProposal;