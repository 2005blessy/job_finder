import 'package:flutter/material.dart';
import 'package:job_finder/src/core/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseRecommendationsPage extends StatefulWidget {
  final List<String>? missingSkills;

  const CourseRecommendationsPage({
    super.key,
    this.missingSkills,
  });

  @override
  State<CourseRecommendationsPage> createState() => _CourseRecommendationsPageState();
}

class _CourseRecommendationsPageState extends State<CourseRecommendationsPage> {
  List<Map<String, dynamic>> recommendedCourses = [];
  List<Map<String, dynamic>> popularCourses = [];
  bool _isLoading = true;
  bool _isLoadingPopular = false;
  String? _errorMessage;
  String selectedProvider = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    // Load popular courses first
    await _loadPopularCourses();
    
    // If missing skills are provided, load courses for those skills
    if (widget.missingSkills != null && widget.missingSkills!.isNotEmpty) {
      await _loadCoursesForSkills(widget.missingSkills!);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPopularCourses() async {
    setState(() {
      _isLoadingPopular = true;
    });

    try {
      print('📚 Loading popular courses...');
      final response = await ApiService().getPopularCourses();
      
      print('✅ Received popular courses: ${response.length}');
      
      setState(() {
        popularCourses = List<Map<String, dynamic>>.from(response);
        _isLoadingPopular = false;
      });
    } catch (e) {
      print('❌ Error loading popular courses: $e');
      setState(() {
        _isLoadingPopular = false;
      });
    }
  }

  Future<void> _loadCoursesForSkills(List<String> skills) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🔍 Loading courses for skills: ${skills.join(", ")}');
      
      List<Map<String, dynamic>> allCourses = [];
      
      // Search courses for each skill
      for (String skill in skills.take(3)) {  // Limit to first 3 skills to avoid too many requests
        try {
          final courses = await ApiService().searchCourses(skill, provider: selectedProvider);
          allCourses.addAll(List<Map<String, dynamic>>.from(courses));
        } catch (e) {
          print('❌ Error loading courses for skill "$skill": $e');
        }
      }
      
      setState(() {
        recommendedCourses = allCourses;
        _isLoading = false;
      });
      
      print('✅ Loaded ${allCourses.length} course recommendations');
    } catch (e) {
      print('❌ Error loading course recommendations: $e');
      setState(() {
        _errorMessage = 'Failed to load course recommendations. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchCourses(String query) async {
    if (query.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a search query';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🔍 Searching courses for: $query with provider: $selectedProvider');
      final courses = await ApiService().searchCourses(query, provider: selectedProvider);
      
      setState(() {
        recommendedCourses = List<Map<String, dynamic>>.from(courses);
        _isLoading = false;
      });
      
      print('✅ Found ${recommendedCourses.length} courses');
    } catch (e) {
      print('❌ Error searching courses: $e');
      setState(() {
        _errorMessage = 'Failed to search courses. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _onPopularCourseTapped(String query) {
    _searchController.text = query;
    _searchCourses(query);
  }

  Future<void> _launchCourseUrl(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No course link available'),
          backgroundColor: Colors.orange.shade400,
        ),
      );
      return;
    }

    try {
      final Uri uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open course link: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Course Recommendations',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Column(
            children: [
              // Search Header
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
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: _searchCourses,
                            decoration: InputDecoration(
                              hintText: 'Search courses (e.g., Python, React, Machine Learning)',
                              prefixIcon: Icon(Icons.search, color: Color(0xFF2563EB)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF2563EB)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF2563EB), width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isLoading ? null : () => _searchCourses(_searchController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 32,
                              vertical: isMobile ? 16 : 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Search',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    
                    // Provider Filter
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['all', 'udemy', 'coursera', 'linkedin', 'pluralsight', 'edx']
                            .map((provider) => Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(provider == 'all' ? 'All Platforms' : provider[0].toUpperCase() + provider.substring(1)),
                                    selected: selectedProvider == provider,
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedProvider = provider;
                                      });
                                      if (_searchController.text.isNotEmpty) {
                                        _searchCourses(_searchController.text);
                                      }
                                    },
                                    selectedColor: Color(0xFF2563EB),
                                    labelStyle: TextStyle(
                                      color: selectedProvider == provider ? Colors.white : Colors.black87,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Finding the best courses for you...',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _errorMessage != null
                        ? _buildErrorState(isMobile)
                        : recommendedCourses.isEmpty
                            ? _buildEmptyState(isMobile)
                            : _buildCoursesList(isMobile),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Container(
            padding: EdgeInsets.all(24),
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
                Icon(Icons.school, size: 64, color: Color(0xFF2563EB)),
                SizedBox(height: 16),
                Text(
                  'Discover Learning Opportunities',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Search for courses or browse popular categories below',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // Popular Course Categories
          Row(
            children: [
              Icon(Icons.trending_up, color: Color(0xFF2563EB), size: 24),
              SizedBox(width: 8),
              Text(
                'Popular Course Categories',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          _isLoadingPopular
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 2 : 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: popularCourses.length,
                  itemBuilder: (context, index) {
                    final course = popularCourses[index];
                    return _buildPopularCourseCard(course);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildPopularCourseCard(Map<String, dynamic> course) {
    return GestureDetector(
      onTap: () => _onPopularCourseTapped(course['query']),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF2563EB).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              course['icon'] ?? '📚',
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 8),
            Text(
              course['title'] ?? '',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              course['description'] ?? '',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isMobile) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            SizedBox(height: 16),
            Text(
              'Oops!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _searchCourses(_searchController.text),
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesList(bool isMobile) {
    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: recommendedCourses.length,
      itemBuilder: (context, index) {
        final course = recommendedCourses[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildCourseCard(course, isMobile),
        );
      },
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course, bool isMobile) {
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
          // Course Title and Provider
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'] ?? 'Course',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.school, size: 14, color: Colors.grey.shade600),
                        SizedBox(width: 4),
                        Text(
                          course['provider'] ?? 'Online Platform',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF2563EB).withOpacity(0.3)),
                ),
                child: Text(
                  course['level'] ?? 'All Levels',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Description
          Text(
            course['description'] ?? 'No description available',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          if (course['skills'] != null && (course['skills'] as List).isNotEmpty) ...[
            SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (course['skills'] as List).map((skill) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF2563EB).withOpacity(0.3)),
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
          ],

          SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _launchCourseUrl(course['url'] ?? ''),
              icon: Icon(Icons.open_in_new, size: 16),
              label: Text('View Course'),
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
        ],
      ),
    );
  }
}