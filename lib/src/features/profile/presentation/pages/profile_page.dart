import 'package:flutter/material.dart';
import 'package:job_finder/src/shared/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _ageController = TextEditingController();
  final _occupationController = TextEditingController();
  
  bool _isEditing = true; // Start with editing enabled

  @override
  void initState() {
    super.initState();
    // Auto-fill name and email from UserProfile
    _nameController.text = UserProfile.name;
    _emailController.text = UserProfile.email;
    _phoneController.text = UserProfile.phone ?? '';
    _locationController.text = UserProfile.location ?? '';
    _ageController.text = '';
    _occupationController.text = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    // Check mandatory fields
    if (_nameController.text.trim().isEmpty || 
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty || 
        _locationController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all mandatory fields!'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    
    // Validate phone number - exactly 10 digits
    String phoneNumber = _phoneController.text.trim();
    if (phoneNumber.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number should contain exactly 10 numbers!'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    
    setState(() {
      UserProfile.name = _nameController.text.trim();
      UserProfile.email = _emailController.text.trim();
      UserProfile.phone = _phoneController.text.trim();
      UserProfile.location = _locationController.text.trim();
      _isEditing = false; // Auto-disable editing after saving
    });
    
    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text(
                'Success!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Text(
            'Profile details are saved successfully!',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEdit,
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
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
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Profile Avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Color(0xFF2563EB), width: 3),
                            ),
                            child: CircleAvatar(
                              radius: isMobile ? 40 : 50,
                              backgroundColor: Color(0xFF2563EB).withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                size: isMobile ? 40 : 50,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _nameController.text.isNotEmpty ? _nameController.text : 'Your Name',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: isMobile ? 20 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _emailController.text.isNotEmpty ? _emailController.text : 'your.email@gmail.com',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: isMobile ? 14 : 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Combined Personal Details Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isMobile ? 20 : 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFF2563EB), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_outline, color: Color(0xFF2563EB), size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Personal Details',
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
                          
                          // Name Field (Mandatory)
                          _buildInputField(
                            'Full Name *',
                            _nameController,
                            Icons.person,
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 16),
                          
                          // Email Field (Mandatory)
                          _buildInputField(
                            'Email Address *',
                            _emailController,
                            Icons.email,
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 16),
                          
                          // Phone Field (Mandatory) - with 10 digit validation
                          _buildInputField(
                            'Phone Number * (10 digits)',
                            _phoneController,
                            Icons.phone,
                            enabled: _isEditing,
                            keyboardType: TextInputType.phone,
                            maxLength: 10, // Limit to 10 characters
                          ),
                          SizedBox(height: 16),
                          
                          // Location Field (Mandatory)
                          _buildInputField(
                            'Location *',
                            _locationController,
                            Icons.location_on,
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 16),
                          
                          // Age Field (Mandatory)
                          _buildInputField(
                            'Age *',
                            _ageController,
                            Icons.cake,
                            enabled: _isEditing,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 16),
                          
                          // Occupation Field (Optional)
                          _buildInputField(
                            'Occupation (Optional)',
                            _occupationController,
                            Icons.work,
                            enabled: _isEditing,
                          ),
                          
                          SizedBox(height: 16),
                          
                          // Field info note
                          Row(
                            children: [
                              Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                              SizedBox(width: 8),
                              Text(
                                '* Required fields',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 32),
                    
                    // Save Button (when editing)
                    if (_isEditing)
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFF2563EB), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF2563EB).withOpacity(0.2),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Save Profile',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? Color(0xFF2563EB).withOpacity(0.3) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: enabled ? Color(0xFF2563EB) : Colors.grey.shade400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade50,
          labelStyle: TextStyle(
            color: enabled ? Color(0xFF2563EB) : Colors.grey.shade500,
            fontFamily: 'Inter',
          ),
          counterText: '', // Hide the character counter
        ),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: enabled ? Colors.black87 : Colors.grey.shade600,
        ),
      ),
    );
  }
}
