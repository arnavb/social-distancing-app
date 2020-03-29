import React from "react";
import "./ExploreContainer.css";

interface ContainerProps {
  name: string;
}

const ExploreContainer: React.FC<ContainerProps> = ({ name }) => {
  return (
    <div className="container">
      <strong>Error</strong>
      <p>
        Page "{name}" not implemented
      </p>
    </div>
  );
};

export default ExploreContainer;
