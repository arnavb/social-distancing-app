import {
  IonContent,
  IonIcon,
  IonItem,
  IonLabel,
  IonList,
  IonListHeader,
  IonMenu,
  IonMenuToggle,
  IonNote
} from "@ionic/react";
import React from "react";
import { RouteComponentProps, withRouter } from "react-router-dom";
import {
  alertCircleOutline,
  alertCircleSharp,
  checkmarkCircleSharp,
  checkmarkCircleOutline,
  settingsOutline,
  settingsSharp
} from "ionicons/icons";
import "./Menu.css";

interface MenuProps extends RouteComponentProps {
  selectedPage: string;
}

interface AppPage {
  url: string;
  iosIcon: string;
  mdIcon: string;
  title: string;
  displayTitle: string;
}

export const appPages: AppPage[] = [
  {
    title: "Alert",
    url: "/Alert",
    displayTitle: "Crowd Alert",
    iosIcon: alertCircleOutline,
    mdIcon: alertCircleSharp
  },
  {
    title: "Check",
    url: "/Check",
    displayTitle: "Crowd Check",
    iosIcon: checkmarkCircleOutline,
    mdIcon: checkmarkCircleSharp
  },
];

const Menu: React.FunctionComponent<MenuProps> = ({ selectedPage }) => {
  return (
    <IonMenu contentId="main" type="overlay">
      <IonContent>
        <IonList id="inbox-list">
          <IonListHeader>Social Distancing</IonListHeader>
          <IonNote></IonNote>
          {appPages.map((appPage, index) => {
            return (
              <IonMenuToggle key={index} autoHide={false}>
                <IonItem
                  className={selectedPage === appPage.title ? "selected" : ""}
                  routerLink={appPage.url}
                  routerDirection="none"
                  lines="none"
                  detail={false}
                >
                  <IonIcon slot="start" ios={appPage.iosIcon} md={appPage.mdIcon} />
                  <IonLabel>{appPage.displayTitle}</IonLabel>
                </IonItem>
              </IonMenuToggle>
            );
          })}
        </IonList>
        <IonList>
          <IonMenuToggle>
            <IonItem
              className={selectedPage === "Settings" ? "selected" : ""}
              routerLink="/Settings"
              routerDirection="none"
              lines="none"
              detail={false}
            >
              <IonIcon slot="start" ios={settingsOutline} md={settingsSharp}></IonIcon>
              <IonLabel>{"Settings"}</IonLabel>
            </IonItem>
          </IonMenuToggle>
        </IonList>
      </IonContent>
    </IonMenu>
  );
};

export default withRouter(Menu);
