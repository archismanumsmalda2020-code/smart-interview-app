const express = require("express");
const router = express.Router();
const Groq = require("groq-sdk");

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

router.post("/", async (req, res) => {
  try {
    const { topic, questions, userAnswers } = req.body;

    const prompt = `
You are an interview coach AI.

Topic: ${topic}

Questions:
${JSON.stringify(questions)}

User Answers Index:
${JSON.stringify(userAnswers)}

Analyze and return JSON:

{
  weakAreas: [],
  strengths: [],
  advice: ""
}
`;

    const completion = await groq.chat.completions.create({
      messages: [{ role: "user", content: prompt }],
      model: "llama-3.1-8b-instant",
      temperature: 0.3,
    });

    const text = completion.choices[0].message.content;

    res.json(JSON.parse(text));

  } catch (err) {
    res.status(500).json({ error: "AI analysis failed" });
  }
});

module.exports = router;