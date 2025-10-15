import ServiceVoting from "../../service/ServiceVoting.jsx";
import {Button, Form, FormCheck, FormControl, FormGroup, FormLabel} from "react-bootstrap";
import {useContext} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";

const Delegate = () => {

    const {wallet} = useContext(AtlantContext);

    const delegate = async(e) => {
        e.preventDefault();
        try {
            const proposalId = e.target[0].value;
            const support = e.target[1].checked;
            const amount = e.target[2].value * 10 ** 12;

            await ServiceVoting.delegate(proposalId, support, amount, wallet);
            console.log(support);
            alert("вы делигировали свой голос")
        } catch (e) {
            alert("не получилось делегировать")
            console.log(e);
        }
    }
    return (
        <div className="container">
            <h2> делегация ртк </h2>
            <Form onSubmit={delegate}>

                <FormGroup>
                    <FormLabel column={1}> айди голосования</FormLabel>
                    <FormControl type="text" placeholder="80989525426983789786532723646894131520352734914175411181708226143236193487175" />
                </FormGroup>

                <FormGroup>
                    <FormLabel column={1}> за или против </FormLabel>
                    <FormCheck />
                </FormGroup>

                <FormGroup>
                    <FormLabel column={1}> количество токенов которым голосуете </FormLabel>
                    <FormControl type="number" placeholder="100" min="1"/>
                </FormGroup>

                <Button variant="primary" type="submit"> делегировать </Button>
            </Form>
        </div>
    )
}
export default Delegate;