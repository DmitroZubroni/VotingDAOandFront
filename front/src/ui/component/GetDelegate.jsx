import {useContext, useEffect, useState} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";
import ServiceVoting from "../../service/ServiceVoting.jsx";
import {FormLabel} from "react-bootstrap";

const GetDelegate = () => {

    const {wallet} = useContext(AtlantContext);
    const [delegates, setDelegates] = useState([]);

    useEffect(() => {
        (async () => {
            const info = await ServiceVoting.getDelegate(wallet);
            setDelegates(info);
            console.log(info);
        })()
    },[wallet])

    return (
        <div className="container">
            <h2> ваши делегации </h2>
            <FormLabel column={1}> {delegates._getDelegete?.toString()}</FormLabel>
        </div>
    )
}
export default GetDelegate