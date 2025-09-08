import 'package:flutter/material.dart';
import 'package:job_finder/src/shared/user_profile.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  void _saveResume() {
    // Only show message if backend confirms extraction
    // TODO: Integrate with backend to extract skills and show message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Resume Upload",
          style: TextStyle(
            fontFamily: 'DMSerifDisplay',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Colors.black, width: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            tooltip: 'Home',
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Colors.black12, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 56, color: Colors.black87),
                  const SizedBox(height: 18),
                  Text(
                    "Upload Your Resume",
                    style: const TextStyle(
                      fontFamily: 'DMSerifDisplay',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "PDF format only. Your resume helps us recommend the best jobs for you.",
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black12, width: 1),
                      ),
                      shadowColor: Colors.black12,
                    ),
                    icon: const Icon(Icons.upload, size: 20),
                    label: const Text(
                      "Choose PDF Resume",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: _saveResume,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Your resume will be securely processed. Skills will be extracted after backend integration.",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
