const express = require("express");
const router = express.Router();
const Groq = require("groq-sdk");

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

router.post("/generate", async (req, res) => {
  try {
    const { topic, questions } = req.body;
    const count = questions || 5;

    const prompt = `
Generate ${count} realistic technical multiple choice interview questions on ${topic}.

Rules:
- Each question must test understanding.
- Provide 4 meaningful options.
- Only one correct answer.
- Provide correctIndex (0-3).
- Return ONLY JSON.

Format:

{
  "questions": [
    {
      "question": "string",
      "options": ["A","B","C","D"],
      "correctIndex": 0
    }
  ]
}
`;

    const response = await groq.chat.completions.create({
      model: "llama-3.3-70b-versatile",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.5,
    });

    let text = response.choices[0].message.content;

    const jsonStart = text.indexOf("{");
    const jsonEnd = text.lastIndexOf("}") + 1;
    const cleanJson = text.substring(jsonStart, jsonEnd);

    const parsed = JSON.parse(cleanJson);

    res.json(parsed);

  } catch (err) {
    console.error("AI ERROR:", err.response?.data || err.message);
    res.status(500).json({ error: "AI generation failed" });
  }
});

module.exports = router;