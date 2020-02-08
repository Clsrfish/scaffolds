import React from "react";

interface IProps {
  content: string;
}

export default class App extends React.Component<IProps, {}> {
  public render() {
    return <div>{this.props.content}</div>;
  }
}
