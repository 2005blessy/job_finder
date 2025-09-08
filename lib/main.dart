// lib/main.dart
import 'package:flutter/material.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/auth/presentation/pages/login_signup_page.dart';
import 'src/features/home/presentation/pages/home_page.dart';
import 'src/features/jobs/presentation/pages/jobs_page.dart';
import 'src/features/profile/presentation/pages/profile_page.dart';
import 'src/features/resume/presentation/pages/resume_page.dart';
import 'src/features/courses/presentation/pages/courses_page.dart';

void main() {
  runApp(const JobFinderApp());
}

class JobFinderApp extends StatelessWidget {
  const JobFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Job Finder",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginSignUpPage(),
        '/home': (context) => const HomePage(),
        '/jobs': (context) => const JobsPage(),
        '/profile': (context) => const ProfilePage(),
        '/resume': (context) => const ResumePage(),
        '/courses': (context) => const CoursesPage(),
      },
    );
  }
}
