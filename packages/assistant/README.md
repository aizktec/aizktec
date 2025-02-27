# AI Chatbot for Aizktec Project (Next.js)

Welcome to the **AI Chatbot** built for the **Aizktec Project**, This chatbot is designed to assist developers by answering questions and providing guidance while working on the Aizktec project. It leverages **Vercel's SDK** and **OpenAI's powerful language models** to deliver intelligent, context-aware responses.

Built with **Next.js**, this chatbot is lightweight, fast, and easy to deploy. Whether you're stuck on a technical issue, need clarification on project architecture, or want to explore best practices, this chatbot is here to help.

---

## Features

- **AI-Powered Assistance**: Built on OpenAI's advanced language models, the chatbot provides accurate and context-aware responses to technical and project-related questions.
- **Seamless Integration**: Utilizes Vercel's SDK for easy deployment and scalability.
- **Developer-Friendly**: Designed specifically for developers working on the Aizktec project, offering tailored support.
- **Real-Time Responses**: Delivers instant answers to queries, saving time and improving productivity.
- **Next.js Optimized**: Built with Next.js for server-side rendering (SSR), static site generation (SSG), and API routes.
- **No Node.js Backend Required**: Uses Next.js API routes for backend functionality.

---

## How It Works

The AI Chatbot is built using the following technologies:

1. **Next.js**: Handles frontend rendering, API routes, and serverless functions.
2. **OpenAI API**: Powers the chatbot's natural language processing and response generation.
3. **Vercel SDK**: Simplifies deployment and scaling.

### Workflow:

1. A developer asks a question through the chat interface.
2. The question is sent to a Next.js API route (`/api/chat`).
3. The API route forwards the question to OpenAI's API for processing.
4. OpenAI generates a response, which is sent back to the frontend and displayed to the user.

---

## Getting Started

Follow these steps to set up and use the AI Chatbot for the Aizktec project:

### Prerequisites

- Node.js (v16 or higher)
- **Bun** (as the package manager)
- OpenAI API key (sign up at [OpenAI](https://platform.openai.com/))
- Vercel account (sign up at [Vercel](https://vercel.com/))

### Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/your-repo/ai-chatbot-aizktec.git
   cd ai-chatbot-aizktec
   ```

2. **Install Dependencies Using Bun**:

   ```bash
   bun install
   ```

3. **Set Up Environment Variables**:
   Create a `.env.local` file in the root directory and add your OpenAI API key:

   ```
   OPENAI_API_KEY=your_openai_api_key_here
   ```

4. **Run the Development Server**:

   ```bash
   bun run dev
   ```

5. **Deploy to Vercel**:
   - Push your code to a GitHub repository.
   - Connect the repository to Vercel and deploy.

---

## Project Structure

Here’s an overview of the key files and folders in the project:

```
ai-chatbot-aizktec/
├── pages/
│   ├── api/
│   │   └── chat.js          # API route for handling chatbot requests
│   └── index.js             # Frontend chat interface
├── components/
│   └── Chat.js              # Chat UI component
├── styles/
│   └── globals.css          # Global styles
├── .env.local               # Environment variables
├── next.config.js           # Next.js configuration
└── package.json             # Project dependencies
```

---

## Usage

Once the chatbot is set up, you can interact with it by typing questions related to the Aizktec project. For example:

- **Technical Questions**:

  - _"How do I set up the database for the Aizktec project?"_
  - _"What are the best practices for API authentication in this project?"_

- **Project-Specific Questions**:

  - _"Can you explain the architecture of the Aizktec project?"_
  - _"How do I integrate the payment gateway?"_

- **General Development Questions**:
  - _"How do I optimize React performance?"_
  - _"What’s the best way to handle errors in Next.js?"_

```javascript
import { openai } from "@ai-sdk/openai";
import { streamText } from "ai";

// Allow streaming responses up to 30 seconds
export const maxDuration = 30;

export async function POST(req: Request) {
  try {
    const { messages } = await req.json();

    const result = streamText({
      model: openai("gpt-4-turbo"),
      system:
        "You are an AI development assistant focused on aizktec. Provide helpful and concise answers about AI development, with code examples when appropriate.",
      messages,
    });

    return result.toDataStreamResponse();
  } catch (error) {
    console.error("Error in chat API:", error);
    return new Response(
      JSON.stringify({
        error: "An error occurred while processing your request.",
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      }
    );
  }
}
```
