import React, { useState } from "react";
import { useNavigate } from "react-router-dom"; // Import useNavigate
import axios from "axios";
import "./PopupCard.css";

export default function PopupCard({ type, onClose }) {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
  });

  const navigate = useNavigate(); // Initialize useNavigate

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.id]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      console.log("Submitting data:", formData);
      const endpoint =
        type === "SignUp"
          ? "http://localhost:7070/auth/signup"
          : "http://localhost:7070/auth/sign-in";

      const response = await axios.post(endpoint, formData);

      alert(response.data.message);

      if (type === "Login") {
        // Store token (if received from backend)
        if (response.data.token) {
          localStorage.setItem("authToken", response.data.token);
        }
        // Navigate to Dashboard after login
        navigate("/dashboard");
      } else {
        // Stay on signup page after signup
        navigate("/signup");
      }

      onClose();
    } catch (error) {
      alert(error.response?.data?.message || "Failed to submit");
    }
  };

  return (
    <div className="popup-overlay">
      <div className="popup-card">
        <button className="close-button" onClick={onClose}>
          &times;
        </button>
        <h2>{type === "Login" ? "Login" : "Sign Up"}</h2>
        <form onSubmit={handleSubmit}>
          {type === "SignUp" && (
            <div className="form-group">
              <label htmlFor="name">Name</label>
              <input
                type="text"
                id="name"
                placeholder="Enter your name"
                value={formData.name}
                onChange={handleChange}
                required
              />
            </div>
          )}
          <div className="form-group">
            <label htmlFor="email">Email</label>
            <input
              type="email"
              id="email"
              placeholder="Enter your email"
              value={formData.email}
              onChange={handleChange}
              required
            />
          </div>
          <div className="form-group">
            <label htmlFor="password">Password</label>
            <input
              type="password"
              id="password"
              placeholder="Enter your password"
              value={formData.password}
              onChange={handleChange}
              required
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
