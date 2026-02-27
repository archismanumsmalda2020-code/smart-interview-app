const generateQuiz = require("../utils/aiQuizGenerator");

exports.createQuiz = async (req, res) => {
  try {
    const { topic, difficulty, numQuestions } = req.body;

    const quiz = await generateQuiz(topic, difficulty, numQuestions);

    res.json(quiz);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};