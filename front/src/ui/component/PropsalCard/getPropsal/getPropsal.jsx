import { Form, FormGroup, FormLabel } from "react-bootstrap";
import { useEffect, useState } from "react";
import ServiceVoting from "../../../../service/ServiceVoting.jsx";

const quorumTypeMap = {
  0: "Простое большинство",
  1: "Супербольшинство (2/3)",
  2: "Взвешенные голоса",
};

const proposalTypeMap = {
  0: "Тип A",
  1: "Тип B",
  2: "Добавление участника DAO",
  3: "Удаление участника DAO",
  4: "Изменение силы ProfiCoin",
  5: "Изменение силы RTKCoin",
};

const voteStatusMap = {
  0: "Принято",
  1: "Не принято",
  2: "Отменено",
};

const Propsals = ({ proposalID }) => {
  const [proposal, setProposal] = useState({
    proposalId: 0,
    proposer: "",
    targets: [],
    values: [],
    description: "",
    voteStart: 0,
    voteEnd: 0,
    quorumType: 0,
    proposalType: 0,
    voteStatus: 0,
  });

  useEffect(() => {
    (async () => {
      try {
        const info = await ServiceVoting.getProposalFull(proposalID);
        setProposal({
          proposalId: info._proposalId || 0,
          proposer: info._proposer || 0,
          targets: info._targets || [],
          values: info._values || [],
          description: info._description || "",
          voteStart: Number(info._voteStart || 0),
          voteEnd: Number(info._voteEnd || 0),
          quorumType: info._quorumType || 0,
          proposalType: info._proposalType || 0,
          voteStatus: info._voteStatus || 0,
        });
      } catch (err) {
        console.error("Ошибка получения proposal", err);
      }
    })();
  }, [proposalID]);

  return (
    <Form>
      <h2>Информация о голосовании</h2>

      <FormGroup>
        <FormLabel>ID голосования: {proposal.proposalId.toString()}</FormLabel>
      </FormGroup>

      <FormGroup>
        <FormLabel>Создатель голосования: {proposal.proposer}</FormLabel>
      </FormGroup>

      <FormGroup>
        <FormLabel>
          Указанные адреса:{" "}
          {proposal.targets.length > 0
            ? proposal.targets.join(", ")
            : "нет адресов"}
        </FormLabel>
      </FormGroup>

      <FormGroup>
        <FormLabel>
          Количество:{" "}
          {proposal.values.length > 0
            ? (Number(proposal.values[0]) / 10 ** 18).toFixed(0)
            : 0}
        </FormLabel>
      </FormGroup>

      <FormGroup>
        <FormLabel>Описание: {proposal.description || "нет описания"}</FormLabel>
      </FormGroup>

      <FormGroup>
        <FormLabel>
          Время окончания:{" "}
          {proposal.voteEnd
            ? new Date(proposal.voteEnd * 1000).toLocaleString()
            : "не задано"}
        </FormLabel>
      </FormGroup>

      <FormGroup>
        <FormLabel>
          Тип голосования:{" "}
          {proposalTypeMap[proposal.proposalType] || proposal.proposalType}
        </FormLabel>
      </FormGroup>

      <FormGroup>
        <FormLabel>
          Тип достижения кворума:{" "}
          {quorumTypeMap[proposal.quorumType] || proposal.quorumType}
        </FormLabel>
      </FormGroup>

      <FormGroup>
        <FormLabel>
          Статус: {voteStatusMap[proposal.voteStatus] || proposal.voteStatus}
        </FormLabel>
      </FormGroup>
    </Form>
  );
};

export default Propsals;
