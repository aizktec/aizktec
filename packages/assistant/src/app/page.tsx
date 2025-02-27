import { ModeToggle } from "@/components/theme/mode-toggle";
import Chat from "../components/Chat";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-4 bg-background">
      <div className="w-full max-w-2xl mb-4 flex justify-end">
        <ModeToggle />
      </div>
      <Chat />
    </main>
  );
}
