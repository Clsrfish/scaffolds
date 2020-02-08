import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import SWRegister from "./utils/swregister";

ReactDOM.render(
    <App content="Hello world!!!" />,
    document.getElementById("root"),
    () => SWRegister.register(),
);
