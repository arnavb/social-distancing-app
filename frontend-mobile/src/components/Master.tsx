import {
  IonButtons,
  IonContent,
  IonHeader,
  IonMenuButton,
  IonPage,
  IonTitle,
  IonToolbar
} from "@ionic/react";
import React from "react";
import { RouteComponentProps } from "react-router";
import ExploreContainer from "../components/ExploreContainer";
import "./Master.css";
import { appPages } from "./Menu";
import CrowdAlert from "../pages/CrowdAlert/CrowdAlert";

const Master: React.FC<RouteComponentProps<{ name: string }>> = ({ match }) => {
  let displayTitle: string | undefined = appPages.find(obj => obj.title === match.params.name)?.displayTitle;
  if (displayTitle === undefined) displayTitle = match.params.name;

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonButtons slot="start">
            <IonMenuButton />
          </IonButtons>
          <IonTitle>{displayTitle}</IonTitle>
        </IonToolbar>
      </IonHeader>

      <IonContent>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">{displayTitle}</IonTitle>
          </IonToolbar>
        </IonHeader>
        {
          (() => {
            switch (match.params.name) {
              case "Alert":
                return <CrowdAlert />;
              case "Check":
                return <ExploreContainer name={"Check"} />;
              case "Settings":
                return <ExploreContainer name={"Settings"} />;
              default:
                return <ExploreContainer name={"Page not available"} />;
            }
          })()
        }
      </IonContent>
    </IonPage>
  );
};

export default Master;
