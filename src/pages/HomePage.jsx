import React from "react";
import Navbar from "../components/home/Navbar";
import HeroSection from "../components/home/HeroSection";
//import ArticleCard  from "../components/articles/ArticleCard.jsx";
import ArticleList from "../components/articles/ArticleList";

export default function HomePage() {
  return (
    <>
      <Navbar />
      <HeroSection />
      <ArticleList />
    </>
  );
}
