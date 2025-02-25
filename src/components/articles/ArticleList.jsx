import React, { useEffect, useState } from "react";
import ArticleCard from "./ArticleCard";

const ArticleList = () => {
  const [articles, setArticle] = useState([]);

  const dummyArticles = [
    {
      id: 1,
      title: "React Basics",
      description: "Learn the fundamentals of React.",
    },
    {
      id: 2,
      title: "Advanced React",
      description: "Understand hooks and performance optimizations.",
    },
    {
      id: 3,
      title: "State Management",
      description: "Explore Redux, Context API, and more.",
    },
  ];

  useEffect(() => {
    fetch("");
  });
  return (
    <div>
      {dummyArticles.map((article) => (
        <ArticleCard
          key={article.id}
          topic={article.title}
          description={article.description}
        />
      ))}
    </div>
  );
};

export default ArticleList;
