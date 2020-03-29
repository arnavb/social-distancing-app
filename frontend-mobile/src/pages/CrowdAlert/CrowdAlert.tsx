import React, { useState, useEffect } from "react";
import styles from "./CrowdAlert.module.css"
import { IonList, IonText, IonContent, IonToggle, IonLabel, IonItem } from "@ionic/react";
import { Plugins, GeolocationPosition } from '@capacitor/core';
const { Geolocation } = Plugins;



const LocationDisplay: React.FC<{ location: GeolocationPosition | null }> = ({ location }) => {
  return (<IonLabel>{location?.coords.latitude}{location ? ", " : ""}{location?.coords.longitude}</IonLabel>);
}

const CrowdAlert: React.FC = () => {
  const [location, setLocation] = useState<GeolocationPosition | null>(null);

  const updateLoc = (newLoc: GeolocationPosition) => setLocation(newLoc);
  Geolocation.watchPosition({ enableHighAccuracy: false, maximumAge: 10000, timeout: 1000 }, updateLoc);

  return (
    <IonContent>
      <IonItem className={styles.listItem}>
        <IonLabel slot="start">Current Location</IonLabel>
        <LocationDisplay location={location} />
      </IonItem>
      <IonItem className={styles.listItem}>
        <IonToggle slot="start"></IonToggle>
        <IonLabel>Enable Alert</IonLabel>
      </IonItem>
    </IonContent>
  );
};

export default CrowdAlert;