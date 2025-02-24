'use client';

import Link from 'next/link';
import { Moon, X, Menu } from "lucide-react";
import React, { useState } from 'react';




const Navbar = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  return (
    <nav className="bg-black text-white p-4 flex justify-center">
      {/* Border Wrapper */}
      <div className="flex flex-col bg-customGray w-full max-w-4xl p-4 rounded-lg border border-white/30 mx-auto">
        <div className="flex items-center justify-between w-full">
          <h1 className="text-xl font-bold">AI-ZK-TEC</h1>

          {/* Navigation Links - Desktop */}
          <div className="hidden md:flex space-x-6">
            <Link href="/">Home</Link>
            <Link href="/data-rights">Data Rights</Link>
            <Link href="/compliance">Compliance</Link>
            <Link href="/audit">Audit</Link>
          </div>

          {/* Buttons - Desktop */}
          <div className="hidden md:flex items-center space-x-4">
            <button className="p-2 rounded-md border border-white/30 bg-black hover:bg-gray-800">
              <Moon className="w-6 h-6 text-white" />
            </button>
            <button className="bg-black px-4 py-2 rounded border border-white/30 hover:bg-gray-800">
              Connect
            </button>
          </div>

          {/* Mobile Menu Button */}
          <button className="md:hidden p-2" onClick={toggleMenu}>
            {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>

        {/* Mobile Menu */}
        {isMenuOpen && (
          <div className="md:hidden flex flex-col mt-4 space-y-4">
            <div className="flex flex-col space-y-2">
              <Link href="/" className="py-2 px-3 hover:bg-gray-800 rounded">Home</Link>
              <Link href="/data-rights" className="py-2 px-3 hover:bg-gray-800 rounded">Data Rights</Link>
              <Link href="/compliance" className="py-2 px-3 hover:bg-gray-800 rounded">Compliance</Link>
              <Link href="/audit" className="py-2 px-3 hover:bg-gray-800 rounded">Audit</Link>
            </div>
            <div className="flex items-center space-x-4 pt-2 border-t border-white/10">
              <button className="p-2 rounded-md border border-white/30 bg-black hover:bg-gray-800">
                <Moon className="w-6 h-6 text-white" />
              </button>
              <button className="bg-black px-4 py-2 rounded border border-white/30 hover:bg-gray-800">
                Connect
              </button>
            </div>
          </div>
        )}
      </div>
    </nav>
  );
};



const HomePage = () => {
  return (
    <div className="bg-black">
      <div className="bg-black text-white min-h-screen flex flex-col justify-between mx-auto max-w-4xl px-4">
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
    <footer className="bg-black text-gray-500 flex justify-center p-4 mt-10 max-w-4xl">
      <div className="p-4 bg-customGray rounded-lg border border-white/30 text-center w-full">
        AI-ZK-TEC: Empowering users with confidence in AI through advanced privacy and compliance.
      </div>
    </footer>
  );
};



export default HomePage;
