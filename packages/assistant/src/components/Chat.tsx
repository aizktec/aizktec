"use client";

import { useRef, useEffect } from "react";
import { SendHorizontal, AlertCircle, Bot } from "lucide-react";
import Message from "./Message";
import AIThinking from "./AIThinking";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Card,
  CardHeader,
  CardTitle,
  CardContent,
  CardFooter,
} from "@/components/ui/card";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { useChat } from "ai/react";

export default function Chat() {
  // Use the useChat hook with the API endpoint and analytics callbacks
  const { messages, input, handleInputChange, handleSubmit, isLoading, error } =
    useChat({
      api: "/api/chat",
      onFinish: (message, { usage, finishReason }) => {
        console.log("Finished streaming message:", message);
        console.log("Token usage:", usage);
        console.log("Finish reason:", finishReason);
      },
      onError: (error) => {
        console.error("An error occurred:", error);
      },
      onResponse: (response) => {
        console.log("Received HTTP response from server:", response);
      },
    });

  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Scroll to bottom when messages change
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  return (
    <div className="w-full max-w-3xl mx-auto">
      <Card
        className="flex flex-col transition-all duration-300 ease-in-out"
        style={{
          minHeight: "100px",
          maxHeight: "90vh",
          height: messages.length > 0 ? "600px" : "180px",
        }}
      >
        <CardHeader className="flex-shrink-0">
          <div className="flex items-center space-x-2">
            <Bot className="h-8 w-8" />
            <CardTitle className="text-xl">AI Development Assistant</CardTitle>
          </div>
        </CardHeader>
        <CardContent
          className="flex-grow overflow-hidden p-4 transition-all duration-300 ease-in-out"
          style={{
            maxHeight: messages.length > 0 ? "calc(100% - 140px)" : "0",
          }}
        >
          <ScrollArea
            className="h-full pr-4"
            style={{ opacity: messages.length > 0 ? 1 : 0 }}
          >
            {messages.map((message, index) => (
              <Message key={index} message={message} />
            ))}
            {isLoading && <AIThinking />}
            {error && (
              <Alert variant="destructive" className="mb-4">
                <div className="flex items-center space-x-2">
                  <AlertCircle className="h-4 w-4 flex-shrink-0" />
                  <AlertDescription>{error.message}</AlertDescription>
                </div>
              </Alert>
            )}
            <div ref={messagesEndRef} />
          </ScrollArea>
        </CardContent>
        <CardFooter className="flex-shrink-0">
          <form
            onSubmit={handleSubmit}
            className="flex w-full items-center space-x-2"
          >
            <Input
              className="flex-grow"
              value={input}
              onChange={handleInputChange}
              placeholder="Ask about aizktec development..."
              disabled={isLoading}
            />
            <Button type="submit" disabled={isLoading || !input.trim()}>
              <SendHorizontal className="h-4 w-4 mr-2" />
              Send
            </Button>
          </form>
        </CardFooter>
      </Card>
    </div>
  );
}
