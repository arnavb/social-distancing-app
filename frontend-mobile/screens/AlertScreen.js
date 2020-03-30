import * as React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { Ionicons, MaterialIcons } from '@expo/vector-icons';
import { RectButton, ScrollView, Switch } from 'react-native-gesture-handler';

import * as Location from 'expo-location';
import * as Permissions from 'expo-permissions';
import * as TaskManager from 'expo-task-manager';
import { Notifications } from 'expo';

export default function AlertScreen() {
  const [alertEnabled, setAlertEnabled] = React.useState(false);
  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.contentContainer}>
      <EnableSwitch getEnabled={() => alertEnabled} setEnabled={ns => setAlertEnabled(ns)} />

      <LocationDisplay getAlertEnabled={() => alertEnabled} />
    </ScrollView>
  );
}

const api_url = "sometheint.com/"

function LocationDisplay({ getAlertEnabled }) {
  const [location, setLocation] = React.useState({ lat: "Enable Alert to see location", lng: "" });

  window.setLocation = newLoc => setLocation(newLoc);

  Location.hasStartedLocationUpdatesAsync("location").then(async (prev) => {
    if (prev && !getAlertEnabled()) {
      setLocation({ lat: "Enable Alert to see location", lng: "" })
      return Location.stopLocationUpdatesAsync("location");
    }
    if (!prev && getAlertEnabled()) {
      let { status } = await Permissions.askAsync(Permissions.LOCATION);
      if (status === 'granted') {
        return Location.startLocationUpdatesAsync("location", {
          accuracy: Location.Accuracy.Balanced,
          timeInterval: 5000,
          distanceInterval: 200,
          foregroundService: {
            notificationTitle: "Crowd Alert",
            notificationBody: "Crowd alert is currently enabled"
          },
          pausesUpdatesAutomatically: true,
        });
      }
    }
  });
  return (
    <RectButton style={styles.option}>
      <View style={{ flexDirection: 'row' }}>
        <View style={styles.optionIconContainer}>
          <MaterialIcons name={"my-location"} size={22} color="rgba(0,0,0,0.35)" />
        </View>
        <View style={styles.optionTextContainer}>
          <Text style={styles.optionText}>Current Location: {location?.lat}{location ? " " : ""}{location?.lng}</Text>
        </View>
      </View>
    </RectButton>
  );
}

function EnableSwitch({ getEnabled, setEnabled }) {
  return (
    <View style={styles.option}>
      <View style={{ flexDirection: 'row' }}>
        <View style={styles.optionIconContainer}>
          <Switch value={getEnabled()} onValueChange={e => setEnabled(e)}></Switch>
        </View>
        <View style={styles.optionTextContainer}>
          <Text style={styles.optionText}>Enable Alert</Text>
        </View>
      </View>
    </View>
  );
}

function OptionButton({ icon, label, onPress, isLastOption }) {
  return (
    <RectButton style={[styles.option, isLastOption && styles.lastOption]} onPress={onPress}>
      <View style={{ flexDirection: 'row' }}>
        <View style={styles.optionIconContainer}>
          <Ionicons name={icon} size={22} color="rgba(0,0,0,0.35)" />
        </View>
        <View style={styles.optionTextContainer}>
          <Text style={styles.optionText}>{label}</Text>
        </View>
      </View>
    </RectButton>
  );
}

var prevCrowd = 500000;
var currCrowd = 500000;

TaskManager.defineTask("location", ({ data: { locations }, error }) => {
  if (error) {
    return;
  }
  try {
    window.setLocation({
      lat: locations.reverse()[0]?.coords.latitude,
      lng: locations.reverse()[0]?.coords.longitude,
    });
    fetch(api_url + "area-popularity/?lat=" + locations.reverse()[0]?.coords.latitude + "&lng=" + locations.reverse()[0]?.coords.longitude).then(res => res.json()).then(res => {
      let crowd = res.map(a => a.current_popularity ? Number(a.current_popularity) : (a.expected_popularity ? Number(a.expected_popularity) : 0)).reduce((a, b) => a + b);
      prevCrowd = currCrowd;
      currCrowd = prevCrowd;
      return currCrowd / prevCrowd;
    }).then(ratio => {
      if (ratio >= 1.2) {
        Notifications.presentLocalNotificationAsync({
          title: "Crowd Alert!",
          body: "There has been a significant increase in the crowd in your area",
        });
      }
    });
  }
  catch (e) {
    console.error(e);
  }
});

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fafafa',
  },
  contentContainer: {
    paddingTop: 15,
  },
  optionIconContainer: {
    marginRight: 12,
  },
  option: {
    backgroundColor: '#fdfdfd',
    paddingHorizontal: 15,
    paddingVertical: 15,
    borderWidth: StyleSheet.hairlineWidth,
    borderBottomWidth: 0,
    borderColor: '#ededed',
  },
  lastOption: {
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  optionText: {
    fontSize: 15,
    alignSelf: 'flex-start',
    marginTop: 1,
  }
});
