import 'dart:convert';
import 'package:http/http.dart' as http;

class AnalysisService {
  static Future<Map<String, dynamic>> analyze(
    String topic,
    List questions,
    List<int?> answers,
  ) async {
    final res = await http.post(
      Uri.parse("http://localhost:5000/api/quiz/analyze"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "topic": topic,
        "questions": questions,
        "answers": answers,
      }),
    );

    final data = jsonDecode(res.body);

    return data; // ⭐ THIS LINE FIXES EVERYTHING
  }
}
