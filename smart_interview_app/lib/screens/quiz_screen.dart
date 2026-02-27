import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'result_screen.dart';
import '../config/api.dart';

class QuizScreen extends StatefulWidget {
  final String topic;
  const QuizScreen({super.key, required this.topic});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List questions = [];
  List<int?> userAnswers = [];
  int currentQuestion = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuiz();
  }

  Future<void> fetchQuiz() async {
    try {
      final res = await http.post(
        Uri.parse("${API.baseUrl}/api/quiz/generate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"topic": widget.topic, "questions": 5}),
      );

      final data = jsonDecode(res.body);

      setState(() {
        questions = data["questions"];
        userAnswers = List.filled(questions.length, null);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching quiz: $e");
    }
  }

  void selectOption(int index) {
    setState(() {
      userAnswers[currentQuestion] = index;
    });
  }

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
    } else {
      finishQuiz();
    }
  }

  void finishQuiz() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i]["correctIndex"]) {
        score++;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: score,
          total: questions.length,
          topic: widget.topic,
          analysis: const {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final q = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(title: Text(widget.topic), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestion + 1}/${questions.length}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              q["question"],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ...List.generate(q["options"].length, (index) {
              final selected = userAnswers[currentQuestion] == index;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected
                        ? Colors.indigo
                        : Colors.grey[200],
                    foregroundColor: selected ? Colors.white : Colors.black,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () => selectOption(index),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(q["options"][index]),
                  ),
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: userAnswers[currentQuestion] == null
                    ? null
                    : nextQuestion,
                child: Text(
                  currentQuestion == questions.length - 1
                      ? "Finish Quiz"
                      : "Next Question",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
