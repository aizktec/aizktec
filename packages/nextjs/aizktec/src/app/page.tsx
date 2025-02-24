'use client';

import Link from 'next/link';
import { Moon } from "lucide-react";




const Navbar = () => {
  return (
    <nav className="bg-black text-white p-4 flex justify-center ">
    {/* Border Wrapper */}
    <div className="flex bg-customGray items-center justify-between w-full max-w-4xl p-4 rounded-lg border border-white/30">
      <h1 className="text-xl font-bold">AI-ZK-TEC</h1>

      {/* Navigation Links */}
      <div className="flex space-x-6">
        <Link href="/">Home</Link>
        <Link href="/data-rights">Data Rights</Link>
        <Link href="/compliance">Compliance</Link>
        <Link href="/audit">Audit</Link>
      </div>

      {/* Buttons */}
      <div className="flex items-center space-x-4">
        <button className="p-2 rounded-md border border-white/30 bg-black hover:bg-gray-800">
          <Moon className="w-6 h-6 text-white" />
        </button>
        <button className="bg-black px-4 py-2 rounded border border-white/30 hover:bg-gray-800">
          Connect
        </button>
      </div>
    </div>
  </nav>
);
};



const HomePage = () => {
  return (
    
    <div className="bg-black text-white min-h-screen flex flex-col justify-between">
      <Navbar />

      <main className="text-center p-10">
        <h2 className="text-3xl font-bold">Welcome to AI-ZK-TEC</h2>
        <div className="flex items-center justify-center ">
      <div className="mt-8 text-gray-300  bg-customGray font-semibold p-6 rounded-lg  border border-white/30 w-fit">  
         <p> Revolutionizing data privacy and compliance with Artificial Intelligence,</p>
          <p>Zero-Knowledge proofs, and the Aztec ecosystem on Ethereum's L2.</p>
          </div>
          </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-10">
          <FeatureCard
            title="Data Rights Management"
            description="Upload your data, set permissions, and monitor usage."
            link="/data-rights"
          />
          <FeatureCard
            title="Compliance Verification"
            description="Upload templates and generate proof of compliance."
            link="/compliance"
          />
          <FeatureCard
            title="Audit Panel"
            description="Access encrypted reports to verify compliance."
            link="/audit"
          />
        </div>

        <button className="mt-6 bg-white text-black px-6 py-2 rounded">Get Started</button>
      </main>

      <Footer />
    </div>
  );
};

const FeatureCard = ({ title, description, link }: { title: string; description: string; link: string }) => {
  return (
    <div className="bg-customGray p-6 rounded-lg text-left border border-white/30 flex flex-col justify-between h-full">
  <h3 className="text-xl font-bold">{title}</h3>
  <p className="text-gray-400 mt-2">{description}</p>
  <Link href={link} className="mt-9 inline-block bg-black w-full px-4 py-2 text-center rounded border border-white/30">
    Learn more
  </Link>
</div>

  );
};

const Footer = () => {
  return (
    <footer className="bg-black text-gray-500 flex justify-center p-4 mt-10">
      <div className="p-4 bg-customGray rounded-lg border border-white/30 text-center max-w-4xl w-full">
        AI-ZK-TEC: Empowering users with confidence in AI through advanced privacy and compliance.
      </div>
    </footer>
  );
};



export default HomePage;
