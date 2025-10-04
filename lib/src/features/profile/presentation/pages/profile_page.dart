import 'package:flutter/material.dart';
import 'package:job_finder/src/shared/user_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF2563EB),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                children: [
                  // Profile Header Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 20 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFF2563EB), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2563EB).withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Profile Avatar
                        Container(
                          width: isMobile ? 70 : 80,
                          height: isMobile ? 70 : 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF1e40af)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF2563EB).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: isMobile ? 35 : 40,
                          ),
                        ),
                        SizedBox(width: 16),
                        
                        // Profile Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                UserProfile.name.isNotEmpty ? UserProfile.name : 'Your Name',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: isMobile ? 20 : 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                UserProfile.email.isNotEmpty ? UserProfile.email : 'your.email@gmail.com',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: isMobile ? 14 : 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Personal Details Card - Read Only
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 20 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFF2563EB), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2563EB).withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: Color(0xFF2563EB),
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Personal Information',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        
                        // Name Field
                        _buildReadOnlyField(
                          icon: Icons.account_circle_outlined,
                          label: 'Full Name',
                          value: UserProfile.name.isNotEmpty ? UserProfile.name : 'Not provided',
                          isMobile: isMobile,
                        ),
                        SizedBox(height: 16),
                        
                        // Email Field
                        _buildReadOnlyField(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: UserProfile.email.isNotEmpty ? UserProfile.email : 'Not provided',
                          isMobile: isMobile,
                        ),
                        SizedBox(height: 16),
                        
                        // Phone Field
                        _buildReadOnlyField(
                          icon: Icons.phone_outlined,
                          label: 'Phone Number',
                          value: UserProfile.phone.isNotEmpty ? UserProfile.phone : 'Not provided',
                          isMobile: isMobile,
                        ),
                        SizedBox(height: 16),
                        
                        // Date of Birth Field
                        _buildReadOnlyField(
                          icon: Icons.cake_outlined,
                          label: 'Date of Birth',
                          value: UserProfile.dateOfBirth.isNotEmpty ? UserProfile.dateOfBirth : 'Not provided',
                          isMobile: isMobile,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Profile Completion Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 20 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFF2563EB), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2563EB).withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              color: Color(0xFF2563EB),
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Profile Completion',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        // Progress indicator
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: _getProfileCompletionPercentage(),
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                                minHeight: 8,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              '${(_getProfileCompletionPercentage() * 100).round()}%',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        
                        Text(
                          _getProfileCompletionMessage(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Quick Actions
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 20 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFF2563EB), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2563EB).withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.bolt_outlined,
                              color: Color(0xFF2563EB),
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Quick Actions',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        
                        // Action buttons
                        _buildActionButton(
                          context: context,
                          icon: Icons.work_outline,
                          title: 'Explore Jobs',
                          subtitle: 'Find your dream job',
                          onTap: () => Navigator.pushNamed(context, '/jobs'),
                          isMobile: isMobile,
                        ),
                        SizedBox(height: 12),
                        
                        _buildActionButton(
                          context: context,
                          icon: Icons.school_outlined,
                          title: 'View Courses',
                          subtitle: 'Enhance your skills',
                          onTap: () => Navigator.pushNamed(context, '/courses'),
                          isMobile: isMobile,
                        ),
                        SizedBox(height: 12),
                        
                        _buildActionButton(
                          context: context,
                          icon: Icons.assignment_outlined,
                          title: 'Applied Jobs',
                          subtitle: 'Track your applications',
                          onTap: () => Navigator.pushNamed(context, '/applied-jobs'),
                          isMobile: isMobile,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isMobile ? 80 : 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReadOnlyField({
    required IconData icon,
    required String label,
    required String value,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF2563EB),
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  double _getProfileCompletionPercentage() {
    int filledFields = 0;
    int totalFields = 4; // name, email, phone, dateOfBirth
    
    if (UserProfile.name.isNotEmpty) filledFields++;
    if (UserProfile.email.isNotEmpty) filledFields++;
    if (UserProfile.phone.isNotEmpty) filledFields++;
    if (UserProfile.dateOfBirth.isNotEmpty) filledFields++;
    
    return filledFields / totalFields;
  }

  String _getProfileCompletionMessage() {
    double percentage = _getProfileCompletionPercentage();
    if (percentage == 1.0) {
      return 'Your profile is complete! You\'re ready to explore all features.';
    } else if (percentage >= 0.75) {
      return 'Almost there! Just a few more details to complete your profile.';
    } else if (percentage >= 0.5) {
      return 'You\'re halfway done. Keep going to unlock all features.';
    } else {
      return 'Complete your profile to get personalized job recommendations.';
    }
  }
}
