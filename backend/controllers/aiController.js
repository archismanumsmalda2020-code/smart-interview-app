const { GoogleGenerativeAI } = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

exports.generateQuiz = async (req, res) => {
  try {
    const { topic, difficulty } = req.body;

    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

    const prompt = `
    Generate 5 MCQ quiz questions about ${topic}.
    Difficulty: ${difficulty}

    Format strictly JSON:
    [
      {
        "question": "",
        "options": ["", "", "", ""],
        "answer": ""
      }
    ]
    `;

    const result = await model.generateContent(prompt);
    const response = result.response.text();

    res.json({ quiz: response });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};