import React from "react";
import styles from "./ExploreContainer.module.css";

interface ContainerProps {
  name: string;
}

const ExploreContainer: React.FC<ContainerProps> = ({ name }) => {
  return (
    <div className={styles.container}>
      <strong>Error</strong>
      <p>
        Page "{name}" not implemented
      </p>
    </div>
  );
};

export default ExploreContainer;
