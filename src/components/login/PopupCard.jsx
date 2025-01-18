import React from "react";
import "./PopupCard.css";

export default function PopupCard({ type, onClose }) {
  return (
    <div className="popup-overlay">
      <div className="popup-card">
        <button className="close-button" onClick={onClose}>
          &times;
        </button>
        <h2>{type === "Login" ? "Login" : "Sign Up"}</h2>
        <form>
          {type === "SignUp" && (
            <div className="form-group">
              <label htmlFor="name">Name</label>
              <input type="text" id="name" placeholder="Enter your name" />
            </div>
          )}
          <div className="form-group">
            <label htmlFor="email">Email</label>
            <input type="email" id="email" placeholder="Enter your email" />
          </div>
          <div className="form-group">
            <label htmlFor="password">Password</label>
            <input
              type="password"
              id="password"
              placeholder="Enter your password"
            />
          </div>
          <button type="submit" className="submit-button">
            {type === "Login" ? "Login" : "Sign Up"}
          </button>
        </form>
      </div>
    </div>
  );
}
