import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text(
                  'Job Finder',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Login', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 24),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 32),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/dreamjob.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Job Finder',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Welcome to Job Finder, your gateway to new career opportunities. Our platform helps job seekers discover roles tailored to their skills and interests, while employers find the perfect candidates. Build your resume, explore courses, and get personalized recommendations—all in one place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.email, color: Colors.white),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.white),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.linked_camera, color: Colors.white),
                    onPressed: () {},
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
