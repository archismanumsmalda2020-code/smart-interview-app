const Groq = require("groq-sdk");

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

const generateQuiz = async (topic) => {
  const chatCompletion = await groq.chat.completions.create({
    messages: [
      {
        role: "user",
        content: `Generate 5 MCQ questions about ${topic}.
Return ONLY JSON array format:
[
 { "question": "", "options": ["","","",""], "answer": "" }
]`
      }
    ],
    model: "llama-3.3-70b-versatile",
  });

  const text = chatCompletion.choices[0].message.content;

  const jsonMatch = text.match(/\[.*\]/s);
  if (!jsonMatch) throw new Error("Invalid AI response");

  return JSON.parse(jsonMatch[0]);
};

module.exports = generateQuiz;