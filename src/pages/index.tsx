import type { ReactNode } from "react";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";

export default function Home(): ReactNode {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout title={`${siteConfig.title}`} description={`${siteConfig.tagline}`}>
      <main>
        <div className="container">
          <h1>{siteConfig.title}</h1>
          <p>{siteConfig.tagline}</p>
        </div>
      </main>
    </Layout>
  );
}
