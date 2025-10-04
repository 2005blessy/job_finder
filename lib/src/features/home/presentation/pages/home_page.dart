import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_finder/src/shared/user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _configureStatusBar();
  }

  void _configureStatusBar() {
    // Configure status bar appearance
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFF2563EB), // Match header color
        statusBarIconBrightness: Brightness.light, // Light icons for dark header
        statusBarBrightness: Brightness.dark, // For iOS
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false, // We'll handle top safe area manually for the header
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Get the actual safe area padding
            final safePadding = MediaQuery.of(context).padding;
            
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

                // 🔹 Top horizontal header with improved styling
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    // Add top padding for status bar
                    padding: EdgeInsets.only(top: safePadding.top),
                    decoration: BoxDecoration(
                      // Use consistent blue color
                      color: const Color(0xFF2563EB),
                      // Subtle gradient for better appearance
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF2563EB),
                          const Color(0xFF2563EB).withOpacity(0.95),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black.withOpacity(0.15),
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Container(
                      height: constraints.maxWidth < 600 ? 56 : 64, // Slightly reduced height
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth < 600 ? 16 : 32,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.white,
                            size: constraints.maxWidth < 600 ? 26 : 32, // Slightly smaller icon
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Job Finder",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600, // Slightly less bold
                              fontSize: constraints.maxWidth < 600 ? 18 : 24, // Reduced font size
                              color: Colors.white,
                              letterSpacing: 0.8, // Reduced letter spacing
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 🔹 Job Card - Top Left Corner (adjusted for reduced header)
                Positioned(
                  top: (constraints.maxWidth < 600 ? 72 : 84) + safePadding.top, // Adjusted for smaller header
                  left: constraints.maxWidth < 600 ? 16 : 32,
                  child: _buildJobCard(context, constraints),
                ),

                // 🔹 Profile Card - Bottom Right Corner (adjusted for safe area)
                Positioned(
                  bottom: (constraints.maxWidth < 600 ? 40 : 60) + safePadding.bottom,
                  right: constraints.maxWidth < 600 ? 16 : 32,
                  child: _buildProfileCard(context, constraints),
                ),
              ],
            );
          },
        ),
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
