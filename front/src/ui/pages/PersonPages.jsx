import Header from "../component/Header.jsx";
import {useContext} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";
import {Button} from "react-bootstrap";
import GetPersonIfo from "../component/GetPersonIfo.jsx";
import GetDelegate from "../component/GetDelegate.jsx";
import BuyToken from "../component/BuyToken.jsx";
import Delegate from "../component/Delegate.jsx";

const PersonPages = () => {

    const {wallet, login} = useContext(AtlantContext);

    return (
        <div>
            <Header/>
            {
                wallet === "" ?
                    <Button onClick={login} className="container"> авторизоваться </Button>  :
                    <>
                    <h2 className="container"> Личный кабинет </h2>
                        <GetPersonIfo/>
                        <GetDelegate/>
                        <BuyToken/>
                    </>
            }
        </div>
    )
}
export default PersonPages