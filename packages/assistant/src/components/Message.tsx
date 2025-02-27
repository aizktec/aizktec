import type { Message } from "ai";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { cn } from "@/lib/utils";
import { User } from "lucide-react";

interface MessageProps {
  message: Message;
}

export default function Message({ message }: MessageProps) {
  const isUser = message.role === "user";

  return (
    <div
      className={cn(
        "flex items-end space-x-2 mb-4",
        isUser ? "justify-end" : "justify-start"
      )}
    >
      {!isUser && (
        <Avatar className="w-8 h-8">
          <AvatarImage src="/ai-avatar.png" alt="AI" />
          <AvatarFallback>AI</AvatarFallback>
        </Avatar>
      )}
      <div
        className={cn(
          "max-w-[80%] rounded-lg px-4 py-2 text-sm",
          isUser
            ? "bg-primary text-primary-foreground"
            : "bg-secondary text-secondary-foreground"
        )}
      >
        {message.content.split("\n").map((line, index) => (
          <p key={index} className="mb-2 last:mb-0">
            {line}
          </p>
        ))}
      </div>
      {isUser && (
        <Avatar className="w-8 h-8">
          <AvatarImage src="/user-avatar.png" alt="User" />
          <AvatarFallback className="p-2">
            <User />
          </AvatarFallback>
        </Avatar>
      )}
    </div>
  );
}
