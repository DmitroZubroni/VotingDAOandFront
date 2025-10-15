import ServiceVoting from "../../service/ServiceVoting.jsx";
import {Button, Form, FormControl, FormGroup, FormLabel} from "react-bootstrap";
import {useContext} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";

const BuyToken = () => {

    const {wallet} = useContext(AtlantContext);

    const buyToken = async(e) => {
        e.preventDefault();
        try {
            const amount = e.target[0].value;
            const valueAmount = amount * 10 ** 12;
            await ServiceVoting.buyToken(amount, wallet, valueAmount);
            alert("токен успешно куплен")
        } catch (e) {
            alert("не получилось купить токен")
            console.log(e);
        }
    }
    return (
        <div className="container">
            <h2>покупка токена</h2>
            <Form onSubmit={buyToken}>

                <FormGroup>
                    <FormLabel column={1}> укажите количество токена которое хотите купить </FormLabel>
                    <FormControl type="number" placeholder="100" min="1"/>
                </FormGroup>

                <Button variant="primary" type="submit"> купить </Button>
            </Form>
        </div>
    )
}
export default BuyToken;