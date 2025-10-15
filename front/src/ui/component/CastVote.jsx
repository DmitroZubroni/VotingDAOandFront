import ServiceVoting from "../../service/ServiceVoting.jsx";
import {Button, Form, FormCheck, FormControl, FormGroup, FormLabel} from "react-bootstrap";
import {useContext} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";

const CastVote  = () => {

    const {wallet} = useContext(AtlantContext);

    const castVote = async(e) => {
        e.preventDefault();
        try {
            const proposalId = e.target[0].value;
            const support = e.target[1].checked;
            const amount = e.target[2].value * 10 ** 12;

            await ServiceVoting.castVote(proposalId, support, amount, wallet); ;
            alert("вы проголосовали")
        } catch (e) {
            alert("не получилось проголосовать")
            console.log(e);
        }
    }
    return (
        <div className="container">
            <h2> голосование </h2>
            <Form onSubmit={castVote}>

                <FormGroup>
                    <FormLabel column={1}> айди голосования</FormLabel>
                    <FormControl type="text" placeholder="80989525426983789786532723646894131520352734914175411181708226143236193487175" />
                </FormGroup>

                <FormGroup>
                    <FormLabel column={1}> за или против </FormLabel>
                    <FormCheck/>
                </FormGroup>

                <FormGroup>
                    <FormLabel column={1}> количество токенов которым голосуете </FormLabel>
                    <FormControl type="number" placeholder="" min="1"/>
                </FormGroup>

                <Button variant="primary" type="submit"> проголосовать </Button>
            </Form>
        </div>
    )
}
export default CastVote;