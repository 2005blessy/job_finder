import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Map<String, dynamic>> courses = [
    // Programming & Development
    {
      'title': 'Complete Flutter Development Bootcamp',
      'provider': 'TechEdu Academy',
      'category': 'Mobile Development',
      'level': 'Beginner to Advanced',
      'duration': '12 weeks',
      'price': 'Free',
      'rating': 4.8,
      'students': 25430,
      'skills': ['Flutter', 'Dart', 'Mobile Development', 'Firebase', 'UI/UX'],
      'description': 'Master Flutter development from basics to advanced concepts. Build real-world apps with Firebase integration.',
      'instructor': 'Dr. Sarah Johnson',
      'isFree': true,
      'certification': true,
    },
    {
      'title': 'Full Stack Web Development with React & Node.js',
      'provider': 'CodeMasters',
      'category': 'Web Development',
      'level': 'Intermediate',
      'duration': '16 weeks',
      'price': '\$89',
      'rating': 4.9,
      'students': 18750,
      'skills': ['React', 'Node.js', 'JavaScript', 'MongoDB', 'Express'],
      'description': 'Build complete web applications using modern JavaScript stack. Industry-ready projects included.',
      'instructor': 'Alex Chen',
      'isFree': false,
      'certification': true,
    },
    {
      'title': 'Python for Data Science & Machine Learning',
      'provider': 'DataScience Pro',
      'category': 'Data Science',
      'level': 'Beginner',
      'duration': '10 weeks',
      'price': 'Free',
      'rating': 4.7,
      'students': 34200,
      'skills': ['Python', 'Pandas', 'NumPy', 'Machine Learning', 'Data Analysis'],
      'description': 'Learn Python programming for data analysis and machine learning. Hands-on projects with real datasets.',
      'instructor': 'Prof. Maria Rodriguez',
      'isFree': true,
      'certification': true,
    },
    {
      'title': 'Advanced Java Programming & Spring Boot',
      'provider': 'JavaExperts',
      'category': 'Backend Development',
      'level': 'Advanced',
      'duration': '14 weeks',
      'price': '\$129',
      'rating': 4.6,
      'students': 12890,
      'skills': ['Java', 'Spring Boot', 'Microservices', 'REST APIs', 'Database Design'],
      'description': 'Master enterprise Java development with Spring ecosystem. Build scalable microservices.',
      'instructor': 'James Wilson',
      'isFree': false,
      'certification': true,
    },
    {
      'title': 'UI/UX Design Masterclass',
      'provider': 'DesignCraft',
      'category': 'Design',
      'level': 'Beginner to Intermediate',
      'duration': '8 weeks',
      'price': '\$69',
      'rating': 4.8,
      'students': 22150,
      'skills': ['Figma', 'Adobe XD', 'Prototyping', 'User Research', 'Design Thinking'],
      'description': 'Create stunning user interfaces and exceptional user experiences. Portfolio projects included.',
      'instructor': 'Emma Thompson',
      'isFree': false,
      'certification': true,
    },
    {
      'title': 'Cloud Computing with AWS',
      'provider': 'CloudMasters',
      'category': 'Cloud Computing',
      'level': 'Intermediate',
      'duration': '12 weeks',
      'price': 'Free',
      'rating': 4.7,
      'students': 19680,
      'skills': ['AWS', 'EC2', 'S3', 'Lambda', 'DevOps'],
      'description': 'Learn Amazon Web Services from fundamentals to advanced concepts. Prepare for AWS certification.',
      'instructor': 'Michael Kim',
      'isFree': true,
      'certification': true,
    },
    {
      'title': 'Cybersecurity Fundamentals',
      'provider': 'SecureLearn',
      'category': 'Cybersecurity',
      'level': 'Beginner',
      'duration': '6 weeks',
      'price': '\$79',
      'rating': 4.5,
      'students': 15430,
      'skills': ['Network Security', 'Ethical Hacking', 'Risk Assessment', 'Incident Response'],
      'description': 'Understand cybersecurity principles and practices. Learn to protect digital assets and systems.',
      'instructor': 'Robert Garcia',
      'isFree': false,
      'certification': true,
    },
    {
      'title': 'Digital Marketing & SEO Strategies',
      'provider': 'MarketingHub',
      'category': 'Marketing',
      'level': 'Beginner',
      'duration': '8 weeks',
      'price': 'Free',
      'rating': 4.6,
      'students': 28750,
      'skills': ['SEO', 'Google Analytics', 'Social Media Marketing', 'Content Marketing'],
      'description': 'Master digital marketing techniques to grow businesses online. Real campaign case studies.',
      'instructor': 'Lisa Park',
      'isFree': true,
      'certification': true,
    },
    {
      'title': 'Blockchain & Cryptocurrency Development',
      'provider': 'BlockchainAcademy',
      'category': 'Blockchain',
      'level': 'Advanced',
      'duration': '10 weeks',
      'price': '\$149',
      'rating': 4.4,
      'students': 8920,
      'skills': ['Solidity', 'Smart Contracts', 'Web3', 'DeFi', 'NFTs'],
      'description': 'Build decentralized applications and smart contracts. Explore the future of finance.',
      'instructor': 'David Lee',
      'isFree': false,
      'certification': true,
    },
    {
      'title': 'Project Management Professional (PMP)',
      'provider': 'PM Institute',
      'category': 'Project Management',
      'level': 'Intermediate',
      'duration': '8 weeks',
      'price': '\$99',
      'rating': 4.7,
      'students': 16540,
      'skills': ['Project Management', 'Agile', 'Scrum', 'Risk Management', 'Leadership'],
      'description': 'Prepare for PMP certification while learning industry-standard project management practices.',
      'instructor': 'Jennifer Adams',
      'isFree': false,
      'certification': true,
    },
    {
      'title': 'Artificial Intelligence & Neural Networks',
      'provider': 'AI Learning Hub',
      'category': 'Artificial Intelligence',
      'level': 'Advanced',
      'duration': '14 weeks',
      'price': 'Free',
      'rating': 4.8,
      'students': 21340,
      'skills': ['TensorFlow', 'PyTorch', 'Deep Learning', 'Computer Vision', 'NLP'],
      'description': 'Dive deep into AI and machine learning. Build neural networks and intelligent systems.',
      'instructor': 'Dr. Kevin Zhang',
      'isFree': true,
      'certification': true,
    },
    {
      'title': 'iOS App Development with Swift',
      'provider': 'AppleDevs',
      'category': 'Mobile Development',
      'level': 'Beginner to Intermediate',
      'duration': '12 weeks',
      'price': '\$119',
      'rating': 4.6,
      'students': 14280,
      'skills': ['Swift', 'iOS', 'Xcode', 'Core Data', 'SwiftUI'],
      'description': 'Create professional iOS applications using Swift and modern iOS development techniques.',
      'instructor': 'Ryan Murphy',
      'isFree': false,
      'certification': true,
    },
  ];

  List<Map<String, dynamic>> filteredCourses = [];
  String searchQuery = '';
  String selectedCategory = 'All';
  String selectedLevel = 'All';
  String selectedPrice = 'All';

  @override
  void initState() {
    super.initState();
    filteredCourses = courses;
    _configureStatusBar();
  }

  void _configureStatusBar() {
    // Configure status bar appearance
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness: Brightness.light, // Light icons for dark AppBar
        statusBarBrightness: Brightness.dark, // For iOS
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _filterCourses() {
    setState(() {
      filteredCourses = courses.where((course) {
        final titleMatch = course['title'].toString().toLowerCase().contains(searchQuery.toLowerCase());
        final providerMatch = course['provider'].toString().toLowerCase().contains(searchQuery.toLowerCase());
        final skillsMatch = (course['skills'] as List<dynamic>).any((skill) => 
          skill.toString().toLowerCase().contains(searchQuery.toLowerCase())
        );
        final instructorMatch = course['instructor'].toString().toLowerCase().contains(searchQuery.toLowerCase());
        
        final matchesSearch = titleMatch || providerMatch || skillsMatch || instructorMatch;
        final matchesCategory = selectedCategory == 'All' || course['category'] == selectedCategory;
        final matchesLevel = selectedLevel == 'All' || course['level'] == selectedLevel;
        final matchesPrice = selectedPrice == 'All' || 
          (selectedPrice == 'Free' && course['isFree'] == true) ||
          (selectedPrice == 'Paid' && course['isFree'] == false);
        
        return matchesSearch && matchesCategory && matchesLevel && matchesPrice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false, // Don't apply SafeArea to top since AppBar handles it
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SafeArea(
            child: AppBar(
              title: Text(
                'Explore Courses',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                SafeArea(
                  child: IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    tooltip: 'Home',
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: false, // AppBar already handles top safe area
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;
              
              return Column(
                children: [
                  // Search and Filter Section
                  Container(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFF2563EB).withOpacity(0.3), width: 1.5),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              searchQuery = value;
                              _filterCourses();
                            },
                            decoration: InputDecoration(
                              hintText: 'Search courses, providers, or skills...',
                              prefixIcon: Icon(Icons.search, color: Color(0xFF2563EB)),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.grey.shade500,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Category Filter
                              _buildFilterDropdown(
                                'Category',
                                selectedCategory,
                                ['All', 'Mobile Development', 'Web Development', 'Data Science', 'Backend Development', 'Design', 'Cloud Computing', 'Cybersecurity', 'Marketing', 'Blockchain', 'Project Management', 'Artificial Intelligence'],
                                (value) {
                                  setState(() {
                                    selectedCategory = value!;
                                  });
                                  _filterCourses();
                                },
                              ),
                              SizedBox(width: 12),
                              
                              // Level Filter
                              _buildFilterDropdown(
                                'Level',
                                selectedLevel,
                                ['All', 'Beginner', 'Intermediate', 'Advanced', 'Beginner to Intermediate', 'Beginner to Advanced'],
                                (value) {
                                  setState(() {
                                    selectedLevel = value!;
                                  });
                                  _filterCourses();
                                },
                              ),
                              SizedBox(width: 12),
                              
                              // Price Filter
                              _buildFilterDropdown(
                                'Price',
                                selectedPrice,
                                ['All', 'Free', 'Paid'],
                                (value) {
                                  setState(() {
                                    selectedPrice = value!;
                                  });
                                  _filterCourses();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Results Count
                  Padding(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${filteredCourses.length} course${filteredCourses.length != 1 ? 's' : ''} found',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  
                  // Courses List
                  Expanded(
                    child: filteredCourses.isEmpty 
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No courses found',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Try adjusting your search criteria',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            left: isMobile ? 16 : 24,
                            right: isMobile ? 16 : 24,
                            bottom: 24, // Add bottom padding for safe area
                          ),
                          itemCount: filteredCourses.length,
                          itemBuilder: (context, index) {
                            final course = filteredCourses[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: _buildCourseCard(course, isMobile),
                            );
                          },
                        ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: value != 'All' ? Color(0xFF2563EB).withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: value != 'All' ? Color(0xFF2563EB) : Colors.grey.shade300,
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(label),
        items: options.map((option) => DropdownMenuItem(
          value: option,
          child: Text(
            option,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: value == option ? Color(0xFF2563EB) : Colors.grey.shade700,
              fontWeight: value == option ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        )).toList(),
        onChanged: onChanged,
        underline: SizedBox(),
        isDense: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: value != 'All' ? Color(0xFF2563EB) : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course, bool isMobile) {
    return Container(
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
          // Course Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${course['provider']} • ${course['instructor']}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: course['isFree'] ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: course['isFree'] ? Colors.green.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      course['price'],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: course['isFree'] ? Colors.green.shade700 : Colors.blue.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: 2),
                      Text(
                        course['rating'].toString(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(${course['students']})',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Course Details
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: Color(0xFF2563EB)),
              SizedBox(width: 4),
              Text(
                course['duration'],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.signal_cellular_alt, size: 14, color: Color(0xFF2563EB)),
              SizedBox(width: 4),
              Text(
                course['level'],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.category, size: 14, color: Color(0xFF2563EB)),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  course['category'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Description
          Text(
            course['description'],
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 16),
          
          // Skills
          Text(
            'Skills you\'ll learn:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (course['skills'] as List<dynamic>).take(4).map<Widget>((skill) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF2563EB).withOpacity(0.2)),
              ),
              child: Text(
                skill.toString(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2563EB),
                ),
              ),
            )).toList(),
          ),
          
          if ((course['skills'] as List).length > 4) ...[
            SizedBox(height: 4),
            Text(
              '+${(course['skills'] as List).length - 4} more skills',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          
          SizedBox(height: 20),
          
          // Action Buttons (only 2 buttons now)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showCourseDetails(course),
                  icon: Icon(Icons.visibility, size: 16),
                  label: Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _redirectToCourse(course),
                icon: Icon(Icons.play_arrow, size: 16),
                label: Text(course['isFree'] ? 'Start Free' : 'Enroll Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: course['isFree'] ? Colors.green : Colors.white,
                  foregroundColor: course['isFree'] ? Colors.white : Color(0xFF2563EB),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  side: course['isFree'] ? null : BorderSide(color: Color(0xFF2563EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCourseDetails(Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.school, color: Color(0xFF2563EB), size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    course['title'],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Provider: ${course['provider']}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Instructor: ${course['instructor']}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Duration: ${course['duration']}', style: TextStyle(fontSize: 12)),
                            Text('Level: ${course['level']}', style: TextStyle(fontSize: 12)),
                            Text('Category: ${course['category']}', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${course['rating']} ⭐', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('${course['students']} students', style: TextStyle(fontSize: 12)),
                          Text(course['price'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    course['description'],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Skills you\'ll learn:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (course['skills'] as List<dynamic>).map<Widget>((skill) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF2563EB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF2563EB).withOpacity(0.2)),
                      ),
                      child: Text(
                        skill.toString(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    )).toList(),
                  ),
                  if (course['certification']) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.verified, color: Colors.green.shade600, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Certificate of completion included',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _redirectToCourse(course);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: course['isFree'] ? Colors.green : Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(course['isFree'] ? 'Start Free Course' : 'Enroll Now'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _redirectToCourse(Map<String, dynamic> course) {
    // This will be handled by backend - redirect to course page
    Navigator.pushNamed(
      context, 
      '/course-details',
      arguments: {
        'courseId': course['title'], // or course['id'] if available
        'courseName': course['title'],
        'isFree': course['isFree'],
      },
    );
  }
}
