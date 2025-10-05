import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 60 : 70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 32, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.work_rounded,
                    color: Colors.white,
                    size: isMobile ? 24 : 32,
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text(
                    'CareerLink',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 20 : 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: isMobile ? 1 : 1.5,
                      fontFamily: 'Poppins',
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!isMobile) ...[
                    _buildNavButton(context, 'Home', () {}),
                    const SizedBox(width: 16),
                    _buildNavButton(context, 'About', () {}),
                    const SizedBox(width: 16),
                    _buildNavButton(context, 'Contact', () {}),
                    const SizedBox(width: 24),
                  ],
                  _buildGradientButton(
                    context,
                    isMobile ? 'Login' : 'Login',
                    () => Navigator.pushNamed(context, '/login'),
                    isPrimary: false,
                    isMobile: isMobile,
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  _buildGradientButton(
                    context,
                    isMobile ? 'Sign Up' : 'Sign Up',
                    () => Navigator.pushNamed(context, '/signup'),
                    isPrimary: true,
                    isMobile: isMobile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/dreamjob.jpg',
              fit: BoxFit.cover,
            ),
          ),
          
          // Darker Gradient Overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 80,
                  vertical: isMobile ? 20 : 40,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: isMobile ? 40 : 20),
                        
                        // Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 16 : 20,
                            vertical: isMobile ? 8 : 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF2563EB).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Color(0xFF2563EB),
                              width: isMobile ? 1.5 : 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, color: Colors.white, size: isMobile ? 16 : 18),
                              SizedBox(width: isMobile ? 6 : 8),
                              Flexible(
                                child: Text(
                                  'AI-Powered Career Platform',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 12 : 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: isMobile ? 24 : 32),
                        
                        // Main Heading
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 0),
                          child: Text(
                            'Find Your Dream Career',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 36 : 72,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1,
                              fontFamily: 'Poppins',
                              height: 1.1,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.8),
                                  blurRadius: 30,
                                  offset: Offset(0, 4),
                                ),
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: isMobile ? 16 : 24),
                        
                        // Subheading
                        Container(
                          constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 700),
                          padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 0),
                          child: Text(
                            'Connect with top employers, build your professional profile, and unlock endless career opportunities with AI-powered job matching.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 16 : 22,
                              height: 1.6,
                              fontFamily: 'Inter',
                              letterSpacing: 0.3,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: isMobile ? 32 : 48),
                        
                        // CTA Buttons
                        Wrap(
                          spacing: isMobile ? 12 : 16,
                          runSpacing: isMobile ? 12 : 16,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildPrimaryButton(
                              context,
                              'Get Started Free',
                              Icons.arrow_forward_rounded,
                              () => Navigator.pushNamed(context, '/login'),
                              isMobile: isMobile,
                            ),
                            if (!isMobile)
                              _buildSecondaryButton(
                                context,
                                'Learn More',
                                Icons.play_circle_outline,
                                () {},
                                isMobile: isMobile,
                              ),
                          ],
                        ),
                        
                        SizedBox(height: isMobile ? 40 : 60),
                        
                        // Feature Cards - Show on mobile too but in column
                        if (isMobile) ...[
                          _buildFeatureCard(
                            Icons.psychology,
                            'AI Matching',
                            'Smart job recommendations',
                            isMobile: true,
                          ),
                          SizedBox(height: 16),
                          _buildFeatureCard(
                            Icons.trending_up,
                            'Career Growth',
                            'Track your progress',
                            isMobile: true,
                          ),
                          SizedBox(height: 16),
                          _buildFeatureCard(
                            Icons.school_rounded,
                            'Learn & Grow',
                            'Skill development courses',
                            isMobile: true,
                          ),
                        ] else ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildFeatureCard(
                                Icons.psychology,
                                'AI Matching',
                                'Smart job recommendations',
                                isMobile: false,
                              ),
                              SizedBox(width: 24),
                              _buildFeatureCard(
                                Icons.trending_up,
                                'Career Growth',
                                'Track your progress',
                                isMobile: false,
                              ),
                              SizedBox(width: 24),
                              _buildFeatureCard(
                                Icons.school_rounded,
                                'Learn & Grow',
                                'Skill development courses',
                                isMobile: false,
                              ),
                            ],
                          ),
                        ],
                        
                        SizedBox(height: isMobile ? 60 : 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Bottom Social Icons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.email, isMobile),
                  SizedBox(width: isMobile ? 16 : 24),
                  _buildSocialIcon(Icons.phone, isMobile),
                  SizedBox(width: isMobile ? 16 : 24),
                  _buildSocialIcon(Icons.language, isMobile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(
    BuildContext context,
    String text,
    VoidCallback onPressed, {
    required bool isPrimary,
    required bool isMobile,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary
            ? LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
              )
            : null,
        borderRadius: BorderRadius.circular(25),
        border: isPrimary ? null : Border.all(color: Colors.white, width: isMobile ? 1.5 : 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 10 : 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isMobile ? 13 : 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed, {
    required bool isMobile,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2563EB).withOpacity(0.5),
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: isMobile ? 20 : 24),
        label: Text(
          text,
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 40,
            vertical: isMobile ? 16 : 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed, {
    required bool isMobile,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white, width: 2.5),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle, {required bool isMobile}) {
    return Container(
      width: isMobile ? double.infinity : 200,
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF2563EB).withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: isMobile ? 28 : 32),
          ),
          if (isMobile) SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                if (!isMobile) SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 4 : 8),
                Text(
                  subtitle,
                  textAlign: isMobile ? TextAlign.left : TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 10 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: isMobile ? 18 : 20,
      ),
    );
  }
}