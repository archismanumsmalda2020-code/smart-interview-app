import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static String baseUrl = dotenv.env['BASE_URL']!;

  // Generate Interview Questions
  static Future<List<dynamic>> generateQuestions(String topic) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/quiz/generate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"topic": topic}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to generate questions");
    }
  }
}
