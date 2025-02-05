import React from "react";
import "./articleCard.css";

export default function ArticleCard({ topic, description }) {
  return (
    <div className="card">
      <a className="card1" href="#">
        <p className="topic">{topic}</p>
        <p className="small">{description}</p>
        <div className="go-corner">
          <div className="go-arrow">→</div>
        </div>
      </a>
    </div>
  );
}
