import {createBrowserRouter} from "react-router-dom";
import FunctionPages from "../../ui/pages/FunctionPages.jsx";
import PersonPages from "../../ui/pages/PersonPages.jsx";
import ProposalPages from "../../ui/pages/ProposalPages.jsx";
import EcecuteProposalPages from "../../ui/pages/EcecuteProposalPages.jsx";

const routes = [
    {
        path: "/",
        element: <PersonPages />,
    },
    {
        path: "/proposal",
        element: <ProposalPages />,
    },
    {
        path: "/func",
        element: <FunctionPages />,
    },
    {
        path: "/execute",
        element: <EcecuteProposalPages />,
    }

]

const router = createBrowserRouter(routes)
export default router;