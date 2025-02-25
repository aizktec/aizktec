"use client";
import ComplianceCard from "./ComplianceCard";
import { Input } from "../ui/input";
import { Button } from "../ui/button";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "../ui/dropdown-menu";
import { useState } from "react";
import { ChevronDown } from "lucide-react";


const ComplianceContent = () => {
    const [selectedOption, setSelectedOption] = useState("Select a template");

  const handleSelect = (option: string) => {
    setSelectedOption(option);
  };
  return (
    <section className="flex flex-col gap-4 max-w-xl mx-auto">
      <h1 className="text-3xl font-bold text-center">Compliance Verification</h1>

      <ComplianceCard cardContentClassName="p-0">
        <p className="text-center">
          Upload templates and generate proof of compliance using our AI-powered
          Zero-Knowledge system.
        </p>
      </ComplianceCard>
      <ComplianceCard
        title="Upload Compliance Template"
        cardContentClassName="space-y-2"
      >
        <p className="text-left w-3/4 mx-auto">Upload template</p>
       <Input type="file" className="w-3/4 mx-auto file:text-white cursor-pointer"/>
       <Button variant={"secondary"}>
        Upload Template
       </Button>
      </ComplianceCard>

      <ComplianceCard title="generate compliance proof" cardContentClassName="space-y-2">
        <DropdownMenu>
            <DropdownMenuTrigger className="w-3/4 mx-auto bg-transparent h-9 rounded-md border px-3 py-1 text-base shadow-sm transition-colors font-medium flex justify-between items-center">
                {selectedOption}
                <ChevronDown className="scale-90" />
            </DropdownMenuTrigger>
            <DropdownMenuContent>
                <DropdownMenuItem onSelect={() => handleSelect("Template 1")}>
                Template 1
                </DropdownMenuItem>
                <DropdownMenuItem onSelect={() => handleSelect("Template 2")}>
                Template 2
                </DropdownMenuItem>
                <DropdownMenuItem onSelect={() => handleSelect("Template 3")}>
                Template 3
                </DropdownMenuItem>
            </DropdownMenuContent>
            </DropdownMenu>
        <Button variant={"secondary"}>
        Generate Proof
       </Button>
      </ComplianceCard>
    </section>
  );
};

export default ComplianceContent;
