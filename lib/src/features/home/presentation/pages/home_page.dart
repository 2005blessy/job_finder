import 'package:flutter/material.dart';
import 'package:job_finder/src/shared/user_profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigate(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 🔹 Background Image - full screen with 0.7 opacity
              Positioned.fill(
                child: Opacity(
                  opacity: 0.7,
                  child: Image.asset(
                    "assets/images/dreamjob.jpg",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Text(
                            'Background Image\nNot Found',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 🔹 Top horizontal header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: constraints.maxWidth < 600 ? 60 : 72, // Responsive header height
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 21, 55, 149),
                    boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black12)],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth < 600 ? 16 : 32,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.work,
                        color: Colors.white,
                        size: constraints.maxWidth < 600 ? 28 : 36,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Job Finder",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: constraints.maxWidth < 600 ? 20 : 28,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔹 Job Card - Top Left Corner
              Positioned(
                top: constraints.maxWidth < 600 ? 80 : 100,
                left: constraints.maxWidth < 600 ? 16 : 32,
                child: _buildJobCard(context, constraints),
              ),

              // 🔹 Profile Card - Bottom Right Corner
              Positioned(
                bottom: constraints.maxWidth < 600 ? 40 : 60,
                right: constraints.maxWidth < 600 ? 16 : 32,
                child: _buildProfileCard(context, constraints),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context, BoxConstraints constraints) {
    bool isNarrow = constraints.maxWidth < 800;
    bool isVeryNarrow = constraints.maxWidth < 600;
    
    if (isNarrow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildJobCard(context, constraints),
          SizedBox(height: isVeryNarrow ? 20 : 30),
          _buildProfileCard(context, constraints),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(child: _buildJobCard(context, constraints)),
          const SizedBox(width: 40),
          Flexible(child: _buildProfileCard(context, constraints)),
        ],
      );
    }
  }

  Widget _buildJobCard(BuildContext context, BoxConstraints constraints) {
    bool isVeryNarrow = constraints.maxWidth < 600;
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isVeryNarrow ? constraints.maxWidth * 0.95 : 450,
      ),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        shadowColor: Colors.black.withOpacity(0.3),
        color: Colors.white.withOpacity(0.90),
        child: Padding(
          padding: EdgeInsets.all(isVeryNarrow ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Find Your Dream Job",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: isVeryNarrow ? 22 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: isVeryNarrow ? 8 : 10),
              Text(
                "Browse top jobs, apply instantly, and build your career with us.",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isVeryNarrow ? 13 : 15,
                  color: Color.fromARGB(255, 69, 79, 95),
                ),
              ),
              SizedBox(height: isVeryNarrow ? 20 : 30),
              SizedBox(
                width: isVeryNarrow ? 140 : 160,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 8,
                    padding: EdgeInsets.symmetric(
                      vertical: isVeryNarrow ? 12 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _navigate(context, '/jobs'),
                  child: Text(
                    "Explore Jobs",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: isVeryNarrow ? 14 : 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, BoxConstraints constraints) {
    bool isVeryNarrow = constraints.maxWidth < 600;
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isVeryNarrow ? constraints.maxWidth * 0.95 : 400,
      ),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        shadowColor: Colors.black.withOpacity(0.3),
        color: Colors.white.withOpacity(0.90),
        child: Padding(
          padding: EdgeInsets.all(isVeryNarrow ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Profile Summary",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: isVeryNarrow ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: isVeryNarrow ? 8 : 10),
              Text(
                "Name: ${UserProfile.name}",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isVeryNarrow ? 13 : 15,
                ),
              ),
              SizedBox(height: isVeryNarrow ? 4 : 6),
              Text(
                "Skills: Flutter, Dart",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isVeryNarrow ? 13 : 15,
                ),
              ),
              SizedBox(height: isVeryNarrow ? 16 : 20),
              _buildProfileButton(context, "Profile", '/profile', isVeryNarrow),
              SizedBox(height: isVeryNarrow ? 8 : 10),
              _buildProfileButton(context, "Resume", '/resume', isVeryNarrow),
              SizedBox(height: isVeryNarrow ? 8 : 10),
              _buildProfileButton(context, "Courses", '/courses', isVeryNarrow),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String text, String route, bool isVeryNarrow) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 8,
          padding: EdgeInsets.symmetric(
            vertical: isVeryNarrow ? 8 : 10,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () => _navigate(context, route),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: isVeryNarrow ? 14 : 16,
          ),
        ),
      ),
    );
  }
}
