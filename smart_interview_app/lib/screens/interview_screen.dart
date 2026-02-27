import 'package:flutter/material.dart';

class InterviewScreen extends StatefulWidget {
  final String role;

  const InterviewScreen({super.key, required this.role});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  String question = "Press Start to generate question";
  final answerController = TextEditingController();

  void generateQuestion() {
    setState(() {
      question = "Explain REST API and its principles.";
    });
  }

  void submitAnswer() {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Submitted"),
        content: Text("Backend evaluation coming next step"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.role)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(question, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: generateQuestion,
              child: const Text("Generate Question"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: answerController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Type your answer here...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: submitAnswer,
              child: const Text("Submit Answer"),
            ),
          ],
        ),
      ),
    );
  }
}
