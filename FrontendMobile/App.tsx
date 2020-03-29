import React, { Component } from "react";
import { StyleSheet, Text, View, Switch } from "react-native";
import Header from "./components/header";

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff"
  },
  content: {
    padding: "7.5%"
  }
});

interface AppProps {}

interface AppState {
  alertEnabled: boolean;
}

export default class App extends Component<AppProps, AppState> {
  readonly state = {
    alertEnabled: false
  };

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <View style={styles.container}>
        <Header title="Test" />
        <View style={styles.content}>
          <Text>Enable Distancing Alert</Text>
          <Switch
            value={this.state.alertEnabled}
            onValueChange={() => {
              this.setState(prevState => ({
                alertEnabled: !prevState.alertEnabled
              }));
            }}
          ></Switch>
        </View>
      </View>
    );
  }
}
