import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:job_finder/src/shared/user_profile.dart';

class LoginSignUpPage extends StatefulWidget {
  const LoginSignUpPage({super.key});

  @override
  State<LoginSignUpPage> createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  bool isLogin = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  String? _createdEmail;
  String? _createdPassword;
  bool _isHovering = false;

  void _toggle() => setState(() => isLogin = !isLogin);

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 20)), // Default to 20 years ago
      firstDate: DateTime.now().subtract(Duration(days: 365 * 100)), // 100 years ago
      lastDate: DateTime.now(), // Can't pick future dates
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF2563eb),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submit() {
    final email = _email.text.trim();
    final password = _password.text.trim();
    final isGmail = email.endsWith('@gmail.com');
    if (!isGmail) {
      _showError('Please enter a valid Gmail address (must end with @gmail.com).');
      return;
    }
    if (password.isEmpty) {
      _showError('Please enter your password.');
      return;
    }
    if (isLogin) {
      if (_createdEmail == null || _createdPassword == null) {
        _showError('No account found. Please sign up first.');
        return;
      }
      if (email != _createdEmail || password != _createdPassword) {
        _showError('Invalid credentials.');
        return;
      }
      // Set user profile info on login
      UserProfile.email = email;
      String rawName = email.split('@')[0].replaceAll('.', ' ');
      UserProfile.name = rawName.isNotEmpty ? rawName[0].toUpperCase() + rawName.substring(1) : '';
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final fullName = _fullName.text.trim();
      final phone = _phoneController.text.trim();
      final dateOfBirth = _dateOfBirthController.text.trim();
      
      // Validation for signup fields
      if (fullName.isEmpty) {
        _showError('Please enter your full name.');
        return;
      }
      if (phone.isEmpty) {
        _showError('Please enter your phone number.');
        return;
      }
      if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
        _showError('Phone number should contain exactly 10 digits.');
        return;
      }
      if (dateOfBirth.isEmpty) {
        _showError('Please select your date of birth.');
        return;
      }
      
      setState(() {
        _createdEmail = email;
        _createdPassword = password;
      });
      
      // Set user profile info on sign up - complete profile automatically
      UserProfile.email = email;
      UserProfile.name = fullName;
      UserProfile.phone = phone;
      UserProfile.dateOfBirth = dateOfBirth;
      Navigator.pushReplacementNamed(context, '/home');
    }
    _email.clear();
    _password.clear();
    _fullName.clear();
    _phoneController.clear();
    _dateOfBirthController.clear();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade400),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: const Text("A password reset link will be sent to your email if it exists in our system."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
          double cardMaxWidth = screenWidth < 500 ? screenWidth * 0.95 : 420;
          double horizontalPadding = screenWidth < 500 ? 8 : 32;
          double verticalPadding = screenWidth < 500 ? 16 : 32;
          double titleFontSize = screenWidth < 500 ? 24 : 32;
          double buttonFontSize = screenWidth < 500 ? 16 : 20;
          double inputFontSize = screenWidth < 500 ? 14 : 16;
          
          return Stack(
            children: [
              // Clean gradient background (no image)
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFFFFF), // pure white
                        Color(0xFFB6D0FF) // soft, visible blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 60,
                        left: 20,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Color(0xFF7B2FF2).withOpacity(0.15),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(blurRadius: 40, color: Color(0xFF7B2FF2).withOpacity(0.15))],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        right: 40,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xFF185a9d).withOpacity(0.12),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(blurRadius: 40, color: Color(0xFF185a9d).withOpacity(0.12))],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Centered card layout - back to normal
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: cardMaxWidth),
                    child: Card(
                      elevation: 12,
                      shadowColor: Colors.black.withOpacity(0.15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.only(
                            left: verticalPadding,
                            right: verticalPadding,
                            top: verticalPadding,
                            bottom: verticalPadding - 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // CareerLink Title with gradient
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Color(0xFF2563eb), Color(0xFF7c3aed)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: Text(
                                  'CareerLink',
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              SizedBox(height: verticalPadding * 0.6),
                              
                              // Form fields
                              if (!isLogin) ...[
                                // Full Name field
                                TextField(
                                  controller: _fullName,
                                  style: TextStyle(fontSize: inputFontSize),
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFF2563eb), width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFF2563eb), width: 2),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  ),
                                ),
                                SizedBox(height: verticalPadding * 0.4),
                                
                                // Phone Number field
                                TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  style: TextStyle(fontSize: inputFontSize),
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number (10 digits)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFF2563eb), width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFF2563eb), width: 2),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    counterText: '', // Hide character counter
                                  ),
                                ),
                                SizedBox(height: verticalPadding * 0.4),
                                
                                // Date of Birth field with date picker
                                GestureDetector(
                                  onTap: _selectDateOfBirth,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade400, width: 1),
                                    ),
                                    child: TextField(
                                      controller: _dateOfBirthController,
                                      enabled: false, // Disable text input, only date picker
                                      style: TextStyle(fontSize: inputFontSize),
                                      decoration: InputDecoration(
                                        labelText: 'Date of Birth',
                                        hintText: 'Tap to select date',
                                        suffixIcon: Icon(
                                          Icons.calendar_today,
                                          color: Color(0xFF2563eb),
                                        ),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        labelStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: verticalPadding * 0.4),
                              ],
                              
                              // Email field
                              TextField(
                                controller: _email,
                                style: TextStyle(fontSize: inputFontSize),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Color(0xFF2563eb), width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Color(0xFF2563eb), width: 2),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                              SizedBox(height: verticalPadding * 0.4),
                              
                              // Password field
                              TextField(
                                controller: _password,
                                obscureText: true,
                                style: TextStyle(fontSize: inputFontSize),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Color(0xFF2563eb), width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Color(0xFF2563eb), width: 2),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                              SizedBox(height: verticalPadding * 0.5),
                              
                              // Submit button
                              MouseRegion(
                                onEnter: (_) => setState(() => _isHovering = true),
                                onExit: (_) => setState(() => _isHovering = false),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: _isHovering ? Color(0xFF1e3a8a) : Color(0xFF1e40af),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF1e40af).withOpacity(0.3),
                                        offset: Offset(0, 4),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    onPressed: _submit,
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      isLogin ? 'Sign In' : 'Create Account',
                                      style: TextStyle(
                                        fontSize: buttonFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: verticalPadding * 0.4),
                              
                              // Footer actions
                              if (isLogin)
                                TextButton(
                                  onPressed: _showForgotPasswordDialog,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: inputFontSize * 0.9,
                                    ),
                                  ),
                                ),
                              
                              TextButton(
                                onPressed: _toggle,
                                child: Text(
                                  isLogin ? 'Create Account' : 'Sign In',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: inputFontSize * 0.9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
