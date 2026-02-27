import 'package:flutter/material.dart';
import 'interview_screen.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  void startInterview(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InterviewScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roles = [
      "Frontend Developer",
      "Backend Developer",
      "HR Interview",
      "DSA Round",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Select Interview Role")),
      body: ListView.builder(
        itemCount: roles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(roles[index]),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => startInterview(context, roles[index]),
            ),
          );
        },
      ),
    );
  }
}
