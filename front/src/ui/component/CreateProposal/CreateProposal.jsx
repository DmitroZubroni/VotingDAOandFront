import React, { useContext } from 'react';
import { Form, FormGroup, FormLabel, FormControl, Button } from 'react-bootstrap';
import ServiceVoting from '../../../service/ServiceVoting.jsx';
import { AppContext } from '../../../core/context/Context.jsx';

const CreateProposal = () => {
    const { wallet } = useContext(AppContext);

    const handleSubmit = async e => {
        e.preventDefault();
        try {
            const delay = (e.target[0].value);
            const period = (e.target[1].value);
            const targets = e.target[2].value;
            const amount = e.target[3].value;
            const quorumType = e.target[4].value;
            const proposeType = e.target[5].value;
            const description = e.target[6].value;
            console.log({
                delay, period, targets, amount, proposeType, quorumType,  wallet, description
            });
            await ServiceVoting.createProposal(
                delay, period, targets, amount, proposeType, quorumType,  wallet, description, wallet
            );
            alert('Предложение создано');
        } catch (err) {
            console.error(err);
            alert('Ошибка при создании предложения');
        }
    };

    return (
        <Form onSubmit={handleSubmit} className="container">
            <h2> создать предложение </h2>

            <FormGroup>
                <FormLabel column={0}>Задержка до старта (delay, в блоках)</FormLabel>
                <FormControl type="number" placeholder="0" min={0}/>
            </FormGroup>

            <FormGroup>
                <FormLabel column={1}>Длительность голосования (period, в блоках)</FormLabel>
                <FormControl type="number" placeholder="12" min={0}/>
            </FormGroup>

            <FormGroup>
                <FormLabel column={4}>адрес стартапа или участника </FormLabel>
                <FormControl type="text" placeholder="0x...,0x..." />
            </FormGroup>

            <FormGroup>
                <FormLabel column={5}> сума </FormLabel>
                <FormControl type="number" placeholder="12" min={0}/>
            </FormGroup>

            <FormGroup className="mb-3">
                <FormLabel column={3}>Механизм кворума</FormLabel>
                <FormControl as="select">
        <option value="0">Простое большинство</option>
        <option value="1">Супербольшинство (2/3)</option>
        <option value="2">Взвешенное голосование</option>
                </FormControl>
            </FormGroup>

            <FormGroup>
                <FormLabel column={2}>Тип предложения</FormLabel>
                <FormControl as="select">
        <option value="0">A — инвестиции</option>
        <option value="1">B — инвестиции (альтернативный)</option>
        <option value="2">C — добавить участника</option>
        <option value="3">D — удалить участника</option>
        <option value="4">E — изменить силу ProfiCoin</option>
        <option value="5">F — изменить силу RTKCoin</option>
                </FormControl>
            </FormGroup>

            <FormGroup>
                <FormLabel column={4}> описание голосовнания </FormLabel>
                <FormControl type="text" placeholder="я верю в данный стартап и он точно окупится" />
            </FormGroup>

            <Button type="submit" variant="primary">создать </Button>
        </Form>
    );
};

export default CreateProposal;
