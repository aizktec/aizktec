import { Bot } from "lucide-react";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";

export default function AIThinking() {
  return (
    <div className="flex items-center space-x-4 mb-4">
      <Avatar className="h-10 w-10 bg-gradient-to-br from-blue-500 to-teal-400">
        <AvatarFallback>AI</AvatarFallback>
      </Avatar>
      <div className="flex items-center space-x-2 bg-secondary p-3 rounded-lg">
        <Bot className="h-5 w-5 text-secondary-foreground" />
        <div className="flex space-x-1">
          {[0, 1, 2].map((i) => (
            <div
              key={i}
              className="w-2 h-2 bg-primary rounded-full animate-pulse"
              style={{ animationDelay: `${i * 0.2}s` }}
            />
          ))}
        </div>
      </div>
    </div>
  );
}
