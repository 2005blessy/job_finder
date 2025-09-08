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

  String? _createdEmail;
  String? _createdPassword;
  bool _isHovering = false;

  void _toggle() => setState(() => isLogin = !isLogin);

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
      _createdEmail = email;
      _createdPassword = password;
      // Set user profile info on sign up
      UserProfile.email = email;
      String rawName = email.split('@')[0].replaceAll('.', ' ');
      UserProfile.name = rawName.isNotEmpty ? rawName[0].toUpperCase() + rawName.substring(1) : '';
      setState(() {
        isLogin = true;
        _email.clear();
        _password.clear();
        _fullName.clear();
      });
      Navigator.pushReplacementNamed(context, '/home');
    }
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
      body: Stack(
        children: [
          // Gradient background with soft abstract blobs
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
                        color: Color(0xFF7B2FF2).withOpacity(0.15), // slightly more visible
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
                        color: Color(0xFF185a9d).withOpacity(0.12), // slightly more visible
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(blurRadius: 40, color: Color(0xFF185a9d).withOpacity(0.12))],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 15,
                color: Colors.white.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.black12, width: 1),
                ),
                shadowColor: Colors.black.withOpacity(0.1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.work_outline, color: Color(0xFF185a9d), size: 48),
                          const SizedBox(height: 12),
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Color(0xFF185a9d), Color(0xFF7B2FF2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              "Job Finder",
                              style: const TextStyle(
                                fontFamily: 'DMSerifDisplay',
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isLogin ? "Sign In" : "Create Account",
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF185a9d),
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 32),
                          if (!isLogin) ...[
                            TextField(
                              controller: _fullName,
                              style: const TextStyle(
                                fontFamily: 'SourceCodePro',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Full Name",
                                labelStyle: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFF185a9d), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFF185a9d), width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFF7B2FF2), width: 2),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                // Subtle shadow
                                enabled: true,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.red, width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                                hintStyle: const TextStyle(
                                  fontFamily: 'SourceCodePro',
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          TextField(
                            controller: _email,
                            style: const TextStyle(
                              fontFamily: 'SourceCodePro',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: const TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFF185a9d), width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFF185a9d), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFF7B2FF2), width: 2),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              // Subtle shadow
                              enabled: true,
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.red, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.red, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              hintStyle: const TextStyle(
                                fontFamily: 'SourceCodePro',
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _password,
                            obscureText: true,
                            style: const TextStyle(
                              fontFamily: 'SourceCodePro',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFF185a9d), width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFF185a9d), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFF7B2FF2), width: 2),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              // Subtle shadow
                              enabled: true,
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.red, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.red, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              hintStyle: const TextStyle(
                                fontFamily: 'SourceCodePro',
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            child: MouseRegion(
                              onEnter: (_) => setState(() => _isHovering = true),
                              onExit: (_) => setState(() => _isHovering = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isHovering
                                        ? const Color(0xFF2563EB) // lighter blue on hover
                                        : const Color(0xFF0A2540), // deep blue
                                    foregroundColor: Colors.white,
                                    elevation: 8,
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      side: const BorderSide(color: Color(0xFFb6d0ff), width: 2),
                                    ),
                                    shadowColor: Colors.black.withOpacity(0.15),
                                  ),
                                  onPressed: _submit,
                                  child: Text(
                                    isLogin ? "Sign In" : "Create Account",
                                    style: const TextStyle(
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _showForgotPasswordDialog,
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFF64748B),
                                textStyle: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              child: const Text("Forgot Password?"),
                            ),
                          ),
                          TextButton(
                            onPressed: _toggle,
                            style: TextButton.styleFrom(
                              foregroundColor: Color(0xFF64748B),
                              textStyle: const TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            child: Text(isLogin
                                ? "Don't have an account? Create Account"
                                : "Already have an account? Sign In"),
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
      ),
    );
  }
}
