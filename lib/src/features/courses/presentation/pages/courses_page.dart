import 'package:flutter/material.dart';
import 'package:job_finder/src/core/services/api_service.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> filteredCourses = [];
  String searchQuery = '';
  String selectedProvider = 'all';
  bool _isLoading = false;
  bool _initialLoad = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPopularCourses();
  }

  Future<void> _loadPopularCourses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('📚 Loading popular courses...');
      final res = await ApiService().getPopularCourses();
      print('✅ Received ${res.length} popular courses');
      
      setState(() {
        courses = (res as List<dynamic>).map((e) => {
          'title': e['title'] ?? '',
          'description': e['description'] ?? '',
          'query': e['query'] ?? '',
          'category': e['category'] ?? 'General',
          'icon': e['icon'] ?? '📚',
        }).toList();
        filteredCourses = courses;
        _isLoading = false;
        _errorMessage = null;
        _initialLoad = true;
      });
    } catch (e) {
      print('❌ Error loading courses: $e');
      setState(() {
        courses = [];
        filteredCourses = [];
        _isLoading = false;
        _errorMessage = 'Failed to load courses: ${e.toString()}';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load courses: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _searchCourses() async {
    if (searchQuery.isEmpty) {
      _loadPopularCourses();
      return;
    }

    setState(() {
      _isLoading = true;
      _initialLoad = false;
      _errorMessage = null;
    });

    try {
      print('🔍 Searching courses: query=$searchQuery, provider=$selectedProvider');
      final res = await ApiService().searchCourses(searchQuery, provider: selectedProvider);
      print('✅ Found ${res.length} courses');
      
      setState(() {
        courses = (res as List<dynamic>).map((e) => {
          'title': e['title'] ?? '',
          'provider': e['provider'] ?? 'Unknown',
          'url': e['url'] ?? '',
          'description': e['description'] ?? '',
          'level': e['level'] ?? 'All Levels',
          'skills': e['skills'] ?? [],
        }).toList();
        filteredCourses = courses;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      print('❌ Error searching courses: $e');
      setState(() {
        courses = [];
        filteredCourses = [];
        _isLoading = false;
        _errorMessage = 'Search failed: ${e.toString()}';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to search courses: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _openCourseUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open course link')),
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
          'Learning Courses',
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
                        onSubmitted: (value) {
                          searchQuery = value;
                          _searchCourses();
                        },
                        decoration: InputDecoration(
                          hintText: 'Search courses (e.g., Python, Machine Learning)...',
                          prefixIcon: Icon(Icons.search, color: Color(0xFF2563EB)),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send, color: Color(0xFF2563EB)),
                            onPressed: _searchCourses,
                          ),
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
                        onChanged: (value) {
                          searchQuery = value;
                        },
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Provider Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['all', 'udemy', 'coursera', 'linkedin', 'pluralsight'].map((provider) {
                          bool isSelected = selectedProvider == provider;
                          String displayName = provider == 'all' ? 'All Providers' 
                              : provider[0].toUpperCase() + provider.substring(1);
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(displayName),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedProvider = provider;
                                });
                                if (!_initialLoad) {
                                  _searchCourses();
                                }
                              },
                              backgroundColor: Colors.grey.shade100,
                              selectedColor: Color(0xFF2563EB).withOpacity(0.1),
                              checkmarkColor: Color(0xFF2563EB),
                              labelStyle: TextStyle(
                                fontFamily: 'Inter',
                                color: isSelected ? Color(0xFF2563EB) : Colors.grey.shade700,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? Color(0xFF2563EB) : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Results Count
              if (courses.isNotEmpty) Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _initialLoad 
                        ? 'Popular Course Categories' 
                        : '${filteredCourses.length} course${filteredCourses.length != 1 ? 's' : ''} found',
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
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredCourses.isEmpty 
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 16),
                              Text(
                                courses.isEmpty ? 'Search for courses' : 'No courses found',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                courses.isEmpty 
                                    ? 'Enter a skill or topic to start searching'
                                    : 'Try adjusting your search criteria',
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
                          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                          itemCount: filteredCourses.length,
                          itemBuilder: (context, index) {
                            final course = filteredCourses[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: _initialLoad 
                                  ? _buildPopularCourseCard(course, isMobile)
                                  : _buildCourseCard(course, isMobile),
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

  Widget _buildPopularCourseCard(Map<String, dynamic> course, bool isMobile) {
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  course['icon'] ?? '📚',
                  style: TextStyle(fontSize: 32),
                ),
              ),
              SizedBox(width: 16),
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
                      course['category'] ?? 'General',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          Text(
            course['description'],
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          
          SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                searchQuery = course['query'] ?? '';
                _searchCourses();
              },
              icon: Icon(Icons.search, size: 20),
              label: Text('Find Courses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
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
                      course['provider'] ?? 'Unknown',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  course['level'] ?? 'All Levels',
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
          
          SizedBox(height: 12),
          
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
          
          if (course['skills'] != null && (course['skills'] as List).isNotEmpty) ...[
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (course['skills'] as List<dynamic>).take(5).map<Widget>((skill) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
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
          ],
          
          SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (course['url'] != null && course['url'].toString().isNotEmpty) {
                  _openCourseUrl(course['url']);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Course link not available')),
                  );
                }
              },
              icon: Icon(Icons.open_in_new, size: 20),
              label: Text('View Course'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
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
