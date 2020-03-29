import React from "react";
import { View, Text, StyleSheet } from "react-native";

const styles = StyleSheet.create({
  header: {
    height: 80,
    paddingTop: 38,
    backgroundColor: "green"
  },
  title: {
    textAlign: "center",
    color: "#fff",
    fontSize: 20,
    fontWeight: "bold"
  }
});

interface HeaderProps {
  title: string;
}

export default function Header(props: HeaderProps) {
  return (
    <View style={styles.header}>
      <Text style={styles.title}>{props.title}</Text>
    </View>
  );
}
