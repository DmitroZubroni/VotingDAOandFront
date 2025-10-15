import {useContext} from "react";
import {AtlantContext} from "../../core/context/Context.jsx";
import {Link} from "react-router-dom";

const Header = () => {

    const {wallet, logout} = useContext(AtlantContext);

    return (
        <div className="navbar" style={{background: "#8743cd"}}>
            <h2 style={{color: "white"}}>Профессионалы 2025</h2>
            {
                wallet === "" ?
                    <>
                        <Link to="/" className="btn" style={{color: "white"}}> авторизоваться </Link>
                        <Link to="/proposal" className="btn" style={{color: "white"}}> списки голосованийй </Link>
                    </> :
                    <>
                        <Link to="/" className="btn" style={{color: "white"}}> личный кабинет </Link>
                        <Link to="/proposal" className="btn" style={{color: "white"}}> списки голосований </Link>
                        <Link to="/func" className="btn" style={{color: "white"}}> голосование </Link>
                        <Link to="/execute" className="btn" style={{color: "white"}}> уже проголосовали </Link>
                        <Link to="/" className="btn" style={{color: "white"}} onClick={logout}> выйти </Link>
                    </>
            }
        </div>
    )

}
export default Header