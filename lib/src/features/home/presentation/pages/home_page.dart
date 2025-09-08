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
      body: Stack(
        children: [
          // Modern blue gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFe3f0fd), Color(0xFFb6d0ff), Color(0xFF90caf9)],
                  stops: [0.0, 0.6, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CustomPaint(
                painter: _DotPatternPainter(),
              ),
            ),
          ),
          // Top horizontal header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
                boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black12)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.work, color: Colors.white, size: 36),
                  const SizedBox(width: 12),
                  Text(
                    "Job Finder",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 88, left: 32, right: 32, bottom: 32),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dream Job box
                  Card(
                    elevation: 8,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    shadowColor: Colors.black.withOpacity(0.10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Find Your Dream Job",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Browse top jobs, apply instantly, and build your career with us.",
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xFF4B5563),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 180,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  elevation: 8,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ).copyWith(
                                  overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                    if (states.contains(MaterialState.hovered)) {
                                      return Color(0xFF1E40AF);
                                    }
                                    return null;
                                  }),
                                ),
                                onPressed: () => _navigate(context, '/jobs'),
                                child: const Text(
                                  "Explore Jobs",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  // Profile Summary box
                  Container(
                    width: 320,
                    child: Card(
                      elevation: 8,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      shadowColor: Colors.black.withOpacity(0.10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Profile Summary",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Name: "+UserProfile.name,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Skills: Flutter, Dart",
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    elevation: 8,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ).copyWith(
                                    overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                      if (states.contains(MaterialState.hovered)) {
                                        return Color(0xFF1E40AF);
                                      }
                                      return null;
                                    }),
                                  ),
                                  onPressed: () => _navigate(context, '/profile'),
                                  child: const Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    elevation: 8,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ).copyWith(
                                    overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                      if (states.contains(MaterialState.hovered)) {
                                        return Color(0xFF1E40AF);
                                      }
                                      return null;
                                    }),
                                  ),
                                  onPressed: () => _navigate(context, '/resume'),
                                  child: const Text(
                                    "Resume",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    elevation: 8,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ).copyWith(
                                    overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                      if (states.contains(MaterialState.hovered)) {
                                        return Color(0xFF1E40AF);
                                      }
                                      return null;
                                    }),
                                  ),
                                  onPressed: () => _navigate(context, '/courses'),
                                  child: const Text(
                                    "Courses",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB6C2D1).withOpacity(0.13)
      ..style = PaintingStyle.fill;
    const double spacing = 32;
    const double radius = 2.5;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
