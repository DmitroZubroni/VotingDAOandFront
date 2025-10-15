import {AppProvider} from "./core/context/Context.jsx";
import {RouterProvider} from "react-router-dom";
import router from "./core/routing/Routing.jsx";
import Header from "./ui/component/Header.jsx";

const App = () => {
    return (
        <AppProvider>
            <RouterProvider router={router}/>
        </AppProvider>
    )
}

export default App;