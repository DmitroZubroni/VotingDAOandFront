import {useContext, useEffect, useState} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";
import ServiceVoting from "../../service/ServiceVoting.jsx";
import {FormLabel} from "react-bootstrap";

const GetPersonIfo = () => {

    const {person} = useContext(AtlantContext);


    return (
        <div className="container">
            <h2> информация о пользователе</h2>
            <FormLabel column={1}>вы участник дао ? - {person.isDAO?.toString() || 0} </FormLabel>
            <hr/>
            <FormLabel column={1}>баланс профи - { (Number(person.profiBalance) / 10 ** 12)?.toString() || 0 }</FormLabel>
            <hr/>
            <FormLabel column={1}> баланс ртк - {(Number(person.rtkBalance) / 10 ** 12)?.toString() || 0} </FormLabel>
        </div>
    )
}
export default GetPersonIfo