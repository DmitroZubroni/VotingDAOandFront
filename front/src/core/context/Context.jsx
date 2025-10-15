import {createContext, useEffect, useState} from 'react'
import ServiceVoting from "../../service/ServiceVoting.jsx";
const AtlantContext = createContext({})

const AppProvider = ({children}) => {

    const [wallet, setWallet] = useState(localStorage.getItem("wallet"))
    const [proposals, setProposals] = useState([]);
    const [person, setPerson] = useState({isDAO: false, profiBalance: 0, rtkBalance: 0});

    const login = async() => {
        const info = await window.ethereum.request({method: "eth_requestAccounts"})
        const walletAddress = info[0]
        setWallet(walletAddress)
        localStorage.setItem("wallet", walletAddress)
        console.log(walletAddress)
    }

    const logout = async() => {
        setWallet("")
    }

    useEffect(() => {
        (async () => {
            const info = await ServiceVoting.getProposalIds()
            setProposals(info);
            console.log(info);
        })()
    }, [])



    useEffect(() => {
        (
            async () => {
                const info = await ServiceVoting.getPersonIfo(wallet);
                setPerson(info);
                console.log(info);
            }
        )()
    },[wallet])

    const values = {
        wallet,
        proposals,
        person,
        login,
        logout,
    }

    return <AtlantContext.Provider value={values}>{children}</AtlantContext.Provider>
}
export {AppProvider, AtlantContext}