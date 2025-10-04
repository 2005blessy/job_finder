import 'package:flutter/material.dart';
import 'package:job_finder/src/core/models/job_recommendation_models.dart';

class CourseRecommendationsPage extends StatefulWidget {
  final List<String> missingSkills;
  
  const CourseRecommendationsPage({
    super.key,
    required this.missingSkills,
  });

  @override
  State<CourseRecommendationsPage> createState() => _CourseRecommendationsPageState();
}

class _CourseRecommendationsPageState extends State<CourseRecommendationsPage> {
  List<CourseRecommendation> recommendedCourses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourseRecommendations();
  }

  Future<void> _loadCourseRecommendations() async {
    // Simulate API call to backend
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      recommendedCourses = _generateMockCourses();
      _isLoading = false;
    });
  }

  List<CourseRecommendation> _generateMockCourses() {
    // This will be replaced with actual backend API call
    List<CourseRecommendation> allCourses = [
      CourseRecommendation(
        courseId: '1',
        title: 'React Native Mobile Development',
        provider: 'TechEdu',
        description: 'Learn to build cross-platform mobile apps with React Native. Master navigation, state management, and native modules.',
        duration: '6 weeks',
        level: 'Intermediate',
        rating: 4.8,
        reviews: 245,
        price: 'Free',
        imageUrl: '',
        skillsCovered: ['React Native', 'JavaScript', 'Mobile Development'],
        category: 'Mobile Development',
        isFree: true,
      ),
      CourseRecommendation(
        courseId: '2',
        title: 'JavaScript Fundamentals to Advanced',
        provider: 'CodeAcademy',
        description: 'Complete JavaScript course covering ES6+, async programming, DOM manipulation, and modern frameworks.',
        duration: '8 weeks',
        level: 'Beginner to Advanced',
        rating: 4.7,
        reviews: 189,
        price: '\$49',
        imageUrl: '',
        skillsCovered: ['JavaScript', 'DOM Manipulation', 'Async Programming'],
        category: 'Programming',
        isFree: false,
      ),
      CourseRecommendation(
        courseId: '3',
        title: 'Agile Project Management',
        provider: 'ProjectPro',
        description: 'Master Agile methodologies, Scrum framework, and project management tools for efficient software development.',
        duration: '4 weeks',
        level: 'Beginner',
        rating: 4.6,
        reviews: 156,
        price: 'Free',
        imageUrl: '',
        skillsCovered: ['Agile', 'Scrum', 'Project Management'],
        category: 'Management',
        isFree: true,
      ),
      CourseRecommendation(
        courseId: '4',
        title: 'TypeScript for Modern Development',
        provider: 'DevSkills',
        description: 'Learn TypeScript from basics to advanced concepts. Build type-safe applications with confidence.',
        duration: '5 weeks',
        level: 'Intermediate',
        rating: 4.9,
        reviews: 203,
        price: '\$39',
        imageUrl: '',
        skillsCovered: ['TypeScript', 'Type Safety', 'JavaScript'],
        category: 'Programming',
        isFree: false,
      ),
      CourseRecommendation(
        courseId: '5',
        title: 'CSS Grid and Flexbox Mastery',
        provider: 'WebDesign Pro',
        description: 'Master modern CSS layout techniques with Grid and Flexbox. Create responsive designs that work everywhere.',
        duration: '3 weeks',
        level: 'Intermediate',
        rating: 4.5,
        reviews: 178,
        price: 'Free',
        imageUrl: '',
        skillsCovered: ['CSS', 'Grid', 'Flexbox', 'Responsive Design'],
        category: 'Web Design',
        isFree: true,
      ),
    ];

    // Filter courses based on missing skills
    return allCourses.where((course) {
      return course.skillsCovered.any((skill) => 
        widget.missingSkills.any((missingSkill) => 
          skill.toLowerCase().contains(missingSkill.toLowerCase()) ||
          missingSkill.toLowerCase().contains(skill.toLowerCase())
        )
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Recommended Courses',
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
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Finding perfect courses for you...',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;
                
                return Column(
                  children: [
                    // Header Section
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.school, color: Colors.orange.shade600, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Skill Development',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Learn these skills to improve your job match percentage:',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.missingSkills.map((skill) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.orange.withOpacity(0.3)),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                    
                    // Courses List
                    Expanded(
                      child: recommendedCourses.isEmpty
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
                                    'Check our full course catalog',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pushNamed(context, '/courses'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF2563EB),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text('View All Courses'),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(isMobile ? 16 : 24),
                              itemCount: recommendedCourses.length,
                              itemBuilder: (context, index) {
                                final course = recommendedCourses[index];
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
    );
  }

  Widget _buildCourseCard(CourseRecommendation course, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
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
                      course.title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      course.provider,
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: course.isFree ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: course.isFree ? Colors.green.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      course.price,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: course.isFree ? Colors.green.shade700 : Colors.blue.shade700,
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
                        course.rating.toString(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(${course.reviews})',
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
          
          // Course Info
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: Color(0xFF2563EB)),
              SizedBox(width: 4),
              Text(
                course.duration,
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
                course.level,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.category, size: 14, color: Color(0xFF2563EB)),
              SizedBox(width: 4),
              Text(
                course.category,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Description
          Text(
            course.description,
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
          
          // Skills Covered
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
            spacing: 6,
            runSpacing: 6,
            children: course.skillsCovered.map((skill) {
              bool isTargetSkill = widget.missingSkills.any((missingSkill) => 
                skill.toLowerCase().contains(missingSkill.toLowerCase()) ||
                missingSkill.toLowerCase().contains(skill.toLowerCase())
              );
              
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isTargetSkill 
                      ? Colors.orange.withOpacity(0.1)
                      : Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isTargetSkill 
                        ? Colors.orange.withOpacity(0.3)
                        : Color(0xFF2563EB).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isTargetSkill 
                        ? Colors.orange.shade700
                        : Color(0xFF2563EB),
                  ),
                ),
              );
            }).toList(),
          ),
          
          SizedBox(height: 16),
          
          // Action Button
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _redirectToCourse(course),
              icon: Icon(Icons.play_arrow, size: 18),
              label: Text(course.isFree ? 'Start Free Course' : 'Enroll Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: course.isFree ? Colors.green : Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _redirectToCourse(CourseRecommendation course) {
    // This will be handled by backend - redirect to course page
    Navigator.pushNamed(
      context, 
      '/course-details',
      arguments: {
        'courseId': course.title, // or course.id if available
        'courseName': course.title,
        'isFree': course.isFree,
      },
    );
  }
}