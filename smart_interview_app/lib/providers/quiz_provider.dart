import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';

class QuizProvider extends ChangeNotifier {
  List<Question> questions = [];
  bool isLoading = false;

  Future<void> generateQuiz(String topic) async {
    isLoading = true;
    notifyListeners();

    final data = await ApiService.generateQuestions(topic);
    questions = data.map<Question>((q) => Question.fromJson(q)).toList();

    isLoading = false;
    notifyListeners();
  }
}
