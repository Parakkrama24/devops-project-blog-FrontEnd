import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import "./Navbar.css";
import PopupCard from "../login/PopupCard";

export default function Navbar() {
  const [popupType, setPopupType] = useState(null);

  const handleNavClick = (event, type) => {
    event.preventDefault(); // Prevent navigation
    setPopupType(type); // Set the popup type (Login or SignUp)
  };

  const handleClosePopup = () => {
    setPopupType(null); // Close the popup
  };

  return (
    <nav className="navbar">
      <div className="logo">Zarrin</div>

      <ul className="nav-link">
        <li>
          <NavLink
            to="/"
            className={({ isActive }) =>
              isActive ? "nav-item-active" : "nav-item"
            }
          >
            Home
          </NavLink>
        </li>
        <li>
          <NavLink
            to="#"
            className="nav-item"
            onClick={(e) => handleNavClick(e, "SignUp")}
          >
            SignUp
          </NavLink>
        </li>
        <li>
          <NavLink
            to="#"
            className="nav-item"
            onClick={(e) => handleNavClick(e, "Login")}
          >
            Login
          </NavLink>
        </li>
      </ul>

      {/* Popup Card */}
      {popupType && <PopupCard type={popupType} onClose={handleClosePopup} />}
    </nav>
  );
}
