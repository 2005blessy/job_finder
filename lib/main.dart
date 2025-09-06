// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  runApp(const JobFinderApp());
}

class JobFinderApp extends StatelessWidget {
  const JobFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Job Finder",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const LoginSignUpPage(),
    );
  }
}

/* =========================== LOGIN / SIGNUP =========================== */

class LoginSignUpPage extends StatefulWidget {
  const LoginSignUpPage({super.key});

  @override
  State<LoginSignUpPage> createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  bool isLogin = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();


  // Store account info locally for simulation
  static String? _savedName;
  static String? _savedHeadline;
  static String? _savedLocation;
  static String? _savedEmail;
  static String? _savedPassword;

  void _toggle() => setState(() => isLogin = !isLogin);

  void _submit() {
    final email = _email.text.trim();
    final pass = _password.text.trim();
    final conf = _confirm.text.trim();
    final emailOk = RegExp(r'^[\w\.\-+]+@[\w\.\-]+\.[A-Za-z]{2,}$').hasMatch(email);

    if (!emailOk || pass.isEmpty || (!isLogin && conf.isEmpty)) {
      _toast("Please enter a valid email and password.");
      return;
    }
    if (!isLogin && pass != conf) {
      _toast("Passwords do not match.");
      return;
    }

    if (isLogin) {
      // Simulate login: check if email/password match
      if (_savedEmail == email && _savedPassword == pass) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              name: _savedName ?? _extractNameFromEmail(_savedEmail),
              headline: _savedHeadline,
              location: _savedLocation,
              email: _savedEmail,
            ),
          ),
        );
      } else {
        _toast("Invalid credentials or account not found.");
      }
    } else {
      // Simulate account creation
      _savedEmail = email;
      _savedPassword = pass;
      _savedName = _extractNameFromEmail(email);
      _savedHeadline = "";
      _savedLocation = "";
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            name: _savedName,
            headline: _savedHeadline,
            location: _savedLocation,
            email: _savedEmail,
          ),
        ),
      );
    }
  }

  String _extractNameFromEmail(String? email) {
    if (email == null || email.isEmpty) return "";
    final namePart = email.split('@').first;
    // Replace dots/underscores/hyphens with spaces and capitalize
    final name = namePart.replaceAll(RegExp(r'[._-]'), ' ');
    return name.split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '').join(' ');
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (ctx) {
        final forgotEmail = TextEditingController();
        return AlertDialog(
          title: const Text("Forgot Password"),
          content: TextField(
            controller: forgotEmail,
            decoration: const InputDecoration(
              labelText: "Enter your email",
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final email = forgotEmail.text.trim();
                if (email.isEmpty) {
                  Navigator.pop(ctx);
                  _toast("Please enter your email.");
                  return;
                }
                if (_savedEmail == email) {
                  Navigator.pop(ctx);
                  _toast("A password reset link has been sent to $email (simulated).");
                } else {
                  Navigator.pop(ctx);
                  _toast("No account found for $email.");
                }
              },
              child: const Text("Send Reset Link"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0f2027), // dark blue
              Color(0xFF2c5364), // deep teal
              Color(0xFF1c92d2), // blue
              Color(0xFF43cea2), // teal-green
              Color(0xFF185a9d), // rich blue
              Color(0xFFf8ffae), // soft yellow
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 20,
              shadowColor: Colors.black45,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.work_outline, size: 70, color: Color(0xFF185a9d)),
                    const SizedBox(height: 18),
                    Text(
                      isLogin ? "Welcome" : "Create your account",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0f2027),
                        fontFamily: 'Montserrat',
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Job Finder",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1c92d2),
                        fontFamily: 'Montserrat',
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2c5364),
                      ),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF185a9d),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF43cea2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFf8ffae).withOpacity(0.15),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2c5364),
                      ),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF185a9d),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF43cea2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        // ignore: deprecated_member_use
                        fillColor: const Color(0xFFf8ffae).withOpacity(0.15),
                      ),
                    ),
                    if (!isLogin) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirm,
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2c5364),
                        ),
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF185a9d),
                          ),
                          prefixIcon: const Icon(Icons.lock_reset, color: Color(0xFF43cea2)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFf8ffae).withOpacity(0.15),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF185a9d),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            letterSpacing: 1.1,
                          ),
                        ),
                        child: Text(isLogin ? "Sign In" : "Create Account"),
                      ),
                    ),
                    if (isLogin) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _forgotPassword,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1c92d2),
                          textStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        child: const Text("Forgot Password?"),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _toggle,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF2c5364),
                        textStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      child: Text(isLogin
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Sign In"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ================================ HOME ================================ */

class HomePage extends StatelessWidget {

  final String? name;
  final String? headline;
  final String? location;
  final String? email;
  const HomePage({super.key, this.name, this.headline, this.location, this.email});

  void _goToDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardPage(
          name: name,
          headline: headline,
          location: location,
          email: email,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "JOB FINDER",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: const Color.fromARGB(255, 139, 204, 197),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE3FDF5), Color.fromARGB(255, 166, 179, 251)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 6,
                        color: surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Find roles that fit your skills",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Upload your resume and we’ll extract your skills to recommend the most relevant jobs.",
                                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 22),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: const [
                                  _FeatureChip("Smart skill extraction"),
                                  _FeatureChip("Curated job matches"),
                                  _FeatureChip("Apply in one tap"),
                                ],
                              ),
                              const SizedBox(height: 22),
                              FilledButton.icon(
                                onPressed: () => _goToDashboard(context),
                                icon: const Icon(Icons.rocket_launch_outlined),
                                label: const Text("Get Started"),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(height: 10),
                            Icon(Icons.work_history, size: 160, color: Colors.teal),
                            SizedBox(height: 12),
                            Text(
                              "Your next job is one upload away.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
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
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String text;
  const _FeatureChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      avatar: const Icon(Icons.check_circle_outline, size: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: Colors.teal.shade200),
      backgroundColor: Colors.teal.shade50,
    );
  }
}

/* ============================== DASHBOARD ============================== */

class DashboardPage extends StatefulWidget {
  final String? name;
  final String? headline;
  final String? location;
  final String? email;
  const DashboardPage({super.key, this.name, this.headline, this.location, this.email});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // sidebar selection
  int _selected = 0;

  // extraction state
  bool _loading = false;
  String? _lastFileName;
  final List<String> _extractedSkills = [];

  // simple profile state (no DB)
  final _name = TextEditingController();
  final _headline = TextEditingController();
  final _location = TextEditingController();
  String? _email;

  // applied jobs state
  final List<_Job> _appliedJobs = [];

  @override
  void initState() {
    super.initState();
    // Fill profile fields if info is available
    final widgetName = widget.name ?? "";
    final widgetHeadline = widget.headline ?? "";
    final widgetLocation = widget.location ?? "";
    _email = widget.email;
    _name.text = widgetName;
    _headline.text = widgetHeadline;
    _location.text = widgetLocation;
  }

  // skills dictionary
  final List<String> _skillKeywords = [
    // Core IT
    "Flutter","Dart","Java","Kotlin","Swift","Objective-C","C","C++","C#","Go","Rust","Python","R",
    "JavaScript","TypeScript","React","Angular","Vue","Node","Node.js","Next.js","Nuxt",
    "SQL","MySQL","PostgreSQL","MongoDB","Firebase","SQLite","NoSQL","GraphQL","REST","gRPC",
    "AWS","Azure","GCP","Docker","Kubernetes","CI/CD","DevOps","Terraform","Ansible","Linux",
    "HTML","CSS","Sass","Tailwind","Bootstrap",
    "Pandas","NumPy","scikit-learn","TensorFlow","Keras","PyTorch","Machine Learning","Deep Learning",
    "Data Analysis","ETL","Power BI","Tableau","Spring","Django","Flask",
    // Non-IT / soft / domain
    "Project Management","Scrum","Agile","Jira","Stakeholder Management","Risk Management",
    "HR","Recruitment","Payroll","Onboarding","Performance Management",
    "Sales","Cold Calling","Negotiation","CRM","Customer Success",
    "Marketing","Digital Marketing","SEO","Content Writing","Copywriting","Social Media",
    "Finance","Accounting","Bookkeeping","Excel","Financial Analysis",
    "Operations","Supply Chain","Procurement","Logistics","Quality Assurance",
    "Business Analysis","Requirement Gathering","UAT","Wireframing",
    "Communication","Leadership","Teamwork","Presentation","Time Management",
  ];

  // job bank (>= 14 jobs; IT + non-IT)
  final List<_Job> _jobs = const [
    _Job("Flutter Developer", "TechSolutions", "Remote", ["Flutter","Dart","Firebase"]),
    _Job("Backend Engineer", "WebWorks", "New York", ["Java","Spring","SQL"]),
    _Job("Full Stack Dev", "Appify", "Remote", ["React","Node.js","PostgreSQL"]),
    _Job("Cloud Engineer", "CloudNine", "Bengaluru", ["AWS","Docker","Kubernetes","CI/CD"]),
    _Job("ML Engineer", "AIWorks", "Remote", ["Python","PyTorch","Machine Learning"]),
    _Job("Frontend Dev", "Designify", "Chicago", ["React","TypeScript","Tailwind"]),
    _Job("Data Analyst", "DataCorp", "San Francisco", ["Python","Pandas","SQL","Tableau"]),
    _Job("DevOps Engineer", "PipeOps", "Berlin", ["Docker","Kubernetes","Terraform"]),
    // Non-IT
    _Job("HR Generalist", "PeopleFirst", "Chennai", ["HR","Onboarding","Payroll"]),
    _Job("Recruiter", "TalentHub", "Hyderabad", ["Recruitment","Interviewing","ATS"]),
    _Job("Project Manager", "BuildRight", "Pune", ["Project Management","Scrum","Stakeholder Management"]),
    _Job("Operations Manager", "FlowOps", "Mumbai", ["Operations","Supply Chain","Procurement"]),
    _Job("Sales Executive", "GrowFast", "Delhi", ["Sales","CRM","Negotiation"]),
    _Job("Marketing Specialist", "Brandify", "Bengaluru", ["Marketing","SEO","Social Media"]),
    _Job("Business Analyst", "Insights Co.", "Kochi", ["Business Analysis","Requirement Gathering","UAT"]),
    _Job("Finance Associate", "LedgerPro", "Kolkata", ["Accounting","Excel","Financial Analysis"]),
  ];

  // derived matches
  List<_Job> get _matchedJobs {
    if (_extractedSkills.isEmpty) return [];
    final have = _extractedSkills.map((e) => e.toLowerCase()).toSet();
    return _jobs.where((job) => job.skills.any((s) => have.contains(s.toLowerCase()))).toList();
  }

  /* -------------------------- Resume Upload + Extract -------------------------- */

  Future<void> _pickAndExtract() async {
    try {
      setState(() {
        _loading = true;
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null) {
        setState(() => _loading = false);
        _snack("No file selected");
        return;
      }

      _lastFileName = result.files.single.name;

      Uint8List? bytes = result.files.single.bytes;
      if (bytes == null && result.files.single.path != null) {
        bytes = await File(result.files.single.path!).readAsBytes();
      }
      if (bytes == null) {
        setState(() => _loading = false);
        _snack("Could not read file bytes.");
        return;
      }

      final text = await _extractPdfText(bytes);

      final lower = text.toLowerCase();
      final found = <String>{};
      for (final skill in _skillKeywords) {
        if (lower.contains(skill.toLowerCase())) {
          found.add(skill);
        }
      }

      setState(() {
        _extractedSkills
          ..clear()
          ..addAll(found.toList()..sort());
        _loading = false;
      });

      if (_extractedSkills.isEmpty) {
        _snack("No recognizable skills found. Try another resume?");
      } else {
        _snack("Skills extracted from $_lastFileName");
      }
    } catch (e) {
      setState(() => _loading = false);
      _snack("Error extracting text: $e");
    }
  }

  Future<String> _extractPdfText(Uint8List bytes) async {
    final doc = PdfDocument(inputBytes: bytes);
    final extractor = PdfTextExtractor(doc);
    final buffer = StringBuffer();
    for (int i = 0; i < doc.pages.count; i++) {
      buffer.write(extractor.extractText(startPageIndex: i));
      buffer.write('\n');
    }
    doc.dispose();
    return buffer.toString();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  /* --------------------------------- UI --------------------------------- */

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Profile",
            onPressed: () => setState(() => _selected = 4),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(right: BorderSide(color: cs.outlineVariant)),
            ),
            child: ListView(
              children: [
                const SizedBox(height: 12),
                _SideTile(
                  icon: Icons.dashboard_outlined,
                  label: "Overview",
                  selected: _selected == 0,
                  onTap: () => setState(() => _selected = 0),
                ),
                _SideTile(
                  icon: Icons.work_outline,
                  label: "Jobs",
                  selected: _selected == 1,
                  onTap: () => setState(() => _selected = 1),
                ),
                _SideTile(
                  icon: Icons.assignment_turned_in_outlined,
                  label: "Applied Jobs",
                  selected: _selected == 2,
                  onTap: () => setState(() => _selected = 2),
                ),
                _SideTile(
                  icon: Icons.description_outlined,
                  label: "Resumes",
                  selected: _selected == 3,
                  onTap: () => setState(() => _selected = 3),
                ),
                _SideTile(
                  icon: Icons.settings_outlined,
                  label: "Settings",
                  selected: _selected == 4,
                  onTap: () => setState(() => _selected = 4),
                ),
                const Divider(),
                _SideTile(
                  icon: Icons.person_outline,
                  label: "Profile",
                  selected: _selected == 5,
                  onTap: () => setState(() => _selected = 5),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IndexedStack(
                index: _selected,
                children: [
                  _buildOverview(),
                  _buildJobsTab(),
                  _buildAppliedJobsTab(),
                  _buildResumesTab(),
                  _buildSettingsTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* -------------------------------- PAGES -------------------------------- */

  Widget _buildOverview() {
    return ListView(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _StatCard(
              title: "Uploaded Resume",
              value: _lastFileName ?? "None",
              icon: Icons.upload_file,
            ),
            _StatCard(
              title: "Skills Found",
              value: "${_extractedSkills.length}",
              icon: Icons.verified_outlined,
            ),
            _StatCard(
              title: "Matches",
              value: "${_matchedJobs.length}",
              icon: Icons.search,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Resume uploader
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(
                  title: "Resume",
                  subtitle: "Upload a PDF resume to extract your skills",
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: _loading ? null : _pickAndExtract,
                      icon: _loading
                          ? const SizedBox(
                              width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.cloud_upload_outlined),
                      label: Text(_loading ? "Processing..." : "Upload & Extract"),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _lastFileName = null;
                          _extractedSkills.clear();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Skills
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(
                  title: "Extracted Skills",
                  subtitle: "We detected the following skills from your resume",
                ),
                const SizedBox(height: 12),
                if (_extractedSkills.isEmpty)
                  Text("No skills extracted yet.", style: TextStyle(color: Colors.grey[700]))
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _extractedSkills
                        .map((s) => Chip(
                              label: Text(s),
                              avatar: const Icon(Icons.check_circle_outline, size: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              side: BorderSide(color: Colors.teal.shade200),
                              backgroundColor: Colors.teal.shade50,
                            ))
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Job recommendations
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(
                  title: "Recommended Jobs",
                  subtitle: "Based on your extracted skills",
                ),
                const SizedBox(height: 12),
                if (_matchedJobs.isEmpty)
                  Text("No matching jobs yet. Upload a resume to see recommendations.",
                      style: TextStyle(color: Colors.grey[700]))
                else
                  ..._matchedJobs.map((j) => _JobTile(job: j)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobsTab() {
    return ListView(
      children: [
        const _SectionHeader(
          title: "All Jobs",
          subtitle: "Explore current openings (IT & Non-IT)",
        ),
        const SizedBox(height: 12),
        ..._jobs.map((j) => _JobTile(
          job: j,
          onApplied: () {
            setState(() {
              if (!_appliedJobs.contains(j)) {
                _appliedJobs.add(j);
              }
            });
          },
        )),
      ],
    );
  }

  Widget _buildAppliedJobsTab() {
    return ListView(
      children: [
        const _SectionHeader(
          title: "Applied Jobs",
          subtitle: "Jobs you have applied for.",
        ),
        const SizedBox(height: 12),
        if (_appliedJobs.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("No jobs applied yet.", style: TextStyle(color: Colors.grey[700])),
          )
        else
          ..._appliedJobs.map((j) => _JobTile(job: j)),
      ],
    );
  }

  Widget _buildResumesTab() {
    return ListView(
      children: [
        const _SectionHeader(
          title: "Resumes",
          subtitle: "Upload or re-upload your resume",
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _lastFileName == null ? "No resume uploaded yet." : "Latest: $_lastFileName",
                  ),
                ),
                FilledButton.icon(
                  onPressed: _loading ? null : _pickAndExtract,
                  icon: _loading
                      ? const SizedBox(
                          width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.upload_file),
                  label: Text(_loading ? "Processing..." : "Upload PDF"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      children: [
        const _SectionHeader(
          title: "Settings",
          subtitle: "Personalize your dashboard (local only)",
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text("Enable smart recommendations"),
            subtitle: const Text("Uses your extracted skills to rank jobs higher"),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text("Show non-IT jobs"),
            subtitle: const Text("Include HR, Sales, Marketing, Operations etc."),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab() {
    return ListView(
      children: [
        const _SectionHeader(
          title: "Profile",
          subtitle: "Enter your essential details below.",
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Date of Birth",
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                if (_email != null && _email!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text("Email: $_email", style: const TextStyle(color: Colors.grey)),
                ],
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () {
                      _snack("Profile saved locally.");
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: const Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/* ============================ SMALL COMPONENTS ============================ */

class _SideTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SideTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: selected ? cs.primary : cs.onSurfaceVariant),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? cs.primary : cs.onSurfaceVariant,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.teal.shade100,
                child: Icon(icon, color: Colors.teal.shade900, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.segment, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/* ============================== JOB MODELS ============================== */

class _Job {
  final String title;
  final String company;
  final String location;
  final List<String> skills;
  const _Job(this.title, this.company, this.location, this.skills);
}

class _JobTile extends StatelessWidget {
  final _Job job;
  final VoidCallback? onApplied;
  const _JobTile({required this.job, this.onApplied});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.work_outline)),
      title: Text(job.title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text("${job.company} • ${job.location}\nSkills: ${job.skills.join(', ')}"),
      isThreeLine: true,
      trailing: FilledButton(
        onPressed: () {
          if (onApplied != null) onApplied!();
          showDialog(
            context: context,
            builder: (ctx) {
              final interviewDate = DateTime.now().add(const Duration(days: 3));
              final formattedDate = "${interviewDate.day}/${interviewDate.month}/${interviewDate.year} at 10:00 AM";
              return AlertDialog(
                title: const Text("Application Submitted"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("You have applied for ${job.title} at ${job.company}.", style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Text("Interview Details:", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("Date: $formattedDate"),
                    Text("Location: ${job.location}"),
                    Text("Contact: hr@${job.company.toLowerCase().replaceAll(' ', '')}.com"),
                    const SizedBox(height: 10),
                    Text("Further details will be sent to your registered email.", style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },
        child: const Text("Apply"),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    );
  }
}
