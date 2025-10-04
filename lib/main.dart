// lib/main.dart
import 'package:flutter/material.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/auth/presentation/pages/login_signup_page.dart';
import 'src/features/home/presentation/pages/home_page.dart';
import 'src/features/jobs/presentation/pages/jobs_page.dart';
import 'src/features/profile/presentation/pages/profile_page.dart';
import 'src/features/resume/presentation/pages/resume_page.dart';
import 'src/features/courses/presentation/pages/courses_page.dart';
import 'src/features/recommendations/presentation/pages/job_recommendations_page.dart';
import 'src/features/recommendations/presentation/pages/course_recommendations_page.dart';
import 'src/features/applied_jobs/presentation/pages/applied_jobs_page.dart';
import 'src/core/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check backend connectivity
  final apiService = ApiService();
  final isBackendAvailable = await apiService.checkHealth();
  
  if (!isBackendAvailable) {
    print('Warning: Backend is not available. Some features may not work.');
  }
  
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginSignUpPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/jobs':
            return MaterialPageRoute(builder: (context) => const JobsPage());
          case '/profile':
            return MaterialPageRoute(builder: (context) => const ProfilePage());
          case '/resume':
            return MaterialPageRoute(builder: (context) => const ResumePage());
          case '/courses':
            return MaterialPageRoute(builder: (context) => const CoursesPage());
          case '/job-recommendations':
            return MaterialPageRoute(builder: (context) => const JobRecommendationsPage());
          case '/course-recommendations':
            final args = settings.arguments as List<String>?;
            return MaterialPageRoute(
              builder: (context) => CourseRecommendationsPage(missingSkills: args ?? []),
            );
          case '/course-details':
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('Course Details'),
                  backgroundColor: Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school, size: 64, color: Color(0xFF2563EB)),
                      SizedBox(height: 16),
                      Text(
                        'Course Details Page',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Backend will handle course enrollment here'),
                    ],
                  ),
                ),
              ),
            );
          case '/job-application':
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('Job Application'),
                  backgroundColor: Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work, size: 64, color: Color(0xFF2563EB)),
                      SizedBox(height: 16),
                      Text(
                        'Job Application Page',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Backend will handle job application here'),
                    ],
                  ),
                ),
              ),
            );
          case '/applied-jobs':
            return MaterialPageRoute(builder: (context) => const AppliedJobsPage());
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('Page Not Found'),
                  backgroundColor: Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Page Not Found',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Route ${settings.name} not found'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                        child: Text('Go Home'),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
