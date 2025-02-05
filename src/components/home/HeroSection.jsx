import React from "react";
import "./HeroSection.css";

export default function HeroSection() {
  return (
    <section className="hero-section">
      <div className="hero-text">
        <p className="featured">Featured Post</p>
        <h1>How Technology will Change the Future</h1>
        <p className="description">
          The future of technology is shaping a smarter, more connected world,
          where AI transforms everyday life. Imagine devices that anticipate
          your needs, immersive virtual experiences, and breakthroughs that
          redefine innovation—all at your fingertips.
        </p>
        
        <button className="read-more">Read more</button>
      </div>
      <div className="hero-image">
        <img src="/CyberSecurityImage.jpg" alt="AI Future" />
      </div>
    </section>
  );
}
