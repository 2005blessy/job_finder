import 'package:flutter/material.dart';
import 'package:job_finder/src/shared/user_profile.dart';
import 'package:job_finder/src/core/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  List<Map<String, dynamic>> jobs = [];
  List<Map<String, dynamic>> filteredJobs = [];
  List<Map<String, dynamic>> popularSearches = [];
  String searchQuery = '';
  String selectedJobType = 'All';
  bool _isLoading = false;
  bool _isLoadingPopular = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPopularSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load popular job searches from backend
  Future<void> _loadPopularSearches() async {
    setState(() {
      _isLoadingPopular = true;
    });

    try {
      print('📚 Loading popular job searches...');
      final response = await ApiService().getPopularJobSearches();
      
      print('✅ Received popular searches: ${response.length}');
      
      setState(() {
        popularSearches = (response as List).cast<Map<String, dynamic>>();
        _isLoadingPopular = false;
      });
    } catch (e) {
      print('❌ Error loading popular searches: $e');
      setState(() {
        _isLoadingPopular = false;
      });
    }
  }

  // Clear search and return to categories view
  void _clearSearch() {
    setState(() {
      jobs = [];
      filteredJobs = [];
      searchQuery = '';
      selectedJobType = 'All';
      _errorMessage = null;
      _searchController.clear();
    });
  }

  // Search jobs with a query
  Future<void> _loadJobs({String? query}) async {
    final searchTerm = query ?? searchQuery;
    
    if (searchTerm.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a search query or select a category';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      searchQuery = searchTerm;
    });

    try {
      print('🔍 Searching jobs with query: $searchTerm');
      final res = await ApiService().searchJobs(searchTerm);
      
      print('✅ Received response: ${res.length} jobs');
      
      if (res.isEmpty) {
        setState(() {
          jobs = [];
          filteredJobs = [];
          _isLoading = false;
          _errorMessage = 'No jobs found for "$searchTerm". Try different keywords.';
        });
        return;
      }

      setState(() {
        jobs = (res as List<dynamic>).map((e) {
          return {
            'title': e['job_title'] ?? e['title'] ?? 'Unknown Title',
            'company': e['employer_name'] ?? e['company'] ?? 'Unknown Company',
            'location': e['job_city'] ?? e['job_state'] ?? e['job_country'] ?? e['location'] ?? 'Remote',
            'salary': e['job_min_salary'] != null && e['job_max_salary'] != null
                ? '\$${e['job_min_salary']} - \$${e['job_max_salary']}'
                : e['job_salary'] ?? e['salary'] ?? 'Not specified',
            'type': e['job_employment_type'] ?? e['type'] ?? 'Full-time',
            'skills': (e['job_required_skills'] ?? e['skills'] ?? []) is List 
                ? (e['job_required_skills'] ?? e['skills']) 
                : [],
            'description': e['job_description'] ?? e['description'] ?? 'No description available',
            'posted': e['job_posted_at_datetime_utc'] ?? e['posted'] ?? 'Recently',
            'id': e['job_id'] ?? e['id'] ?? '',
            'apply_link': e['job_apply_link'] ?? '',
          };
        }).toList();
        filteredJobs = jobs;
        _isLoading = false;
        _errorMessage = null;
      });
      _filterJobs();
      
      print('✨ Successfully loaded ${jobs.length} jobs');
    } catch (e) {
      print('❌ Error loading jobs: $e');
      setState(() {
        jobs = [];
        filteredJobs = [];
        _isLoading = false;
        _errorMessage = e.toString().contains('RAPIDAPI_KEY') 
            ? 'API Key Error: Please check backend configuration'
            : 'Failed to load jobs. Please try again.';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load jobs: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _loadJobs(query: searchTerm),
            ),
          ),
        );
      }
    }
  }

  void _filterJobs() {
    setState(() {
      if (selectedJobType == 'All') {
        filteredJobs = jobs;
      } else {
        filteredJobs = jobs
            .where((job) => job['type'].toString().toLowerCase().contains(selectedJobType.toLowerCase()))
            .toList();
      }
    });
  }

  void _onSearchChanged(String value) {
    searchQuery = value;
  }

  void _onSearchSubmitted() {
    _loadJobs();
  }

  // Handle clicking on popular search category
  void _onPopularSearchTapped(String query) {
    _searchController.text = query;
    _loadJobs(query: query);
  }

  // Add this method to launch URL
  Future<void> _launchJobUrl(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No application link available for this job'),
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
            content: Text('Failed to open application link: ${e.toString()}'),
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
          'Explore Jobs',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: jobs.isNotEmpty || _errorMessage != null
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _clearSearch,
                tooltip: 'Back to Categories',
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            tooltip: 'Home',
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
                            onChanged: _onSearchChanged,
                            onSubmitted: (_) => _onSearchSubmitted(),
                            decoration: InputDecoration(
                              hintText: 'Search jobs (e.g., Software Engineer, Data Scientist)',
                              prefixIcon: Icon(Icons.search, color: Color(0xFF2563EB)),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear, color: Colors.grey),
                                      onPressed: _clearSearch,
                                      tooltip: 'Clear search',
                                    )
                                  : null,
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
                          onPressed: _isLoading ? null : _onSearchSubmitted,
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
                    
                    // Job Type Filter
                    if (jobs.isNotEmpty) ...[
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Full-time', 'Part-time', 'Contract', 'Internship']
                              .map((type) => Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: Text(type),
                                      selected: selectedJobType == type,
                                      onSelected: (selected) {
                                        setState(() {
                                          selectedJobType = type;
                                          _filterJobs();
                                        });
                                      },
                                      selectedColor: Color(0xFF2563EB),
                                      labelStyle: TextStyle(
                                        color: selectedJobType == type ? Colors.white : Colors.black87,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
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
                              'Searching for jobs...',
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
                        : filteredJobs.isEmpty
                            ? _buildEmptyState(isMobile)
                            : _buildJobsList(isMobile),
              ),
            ],
          );
        },
      ),
    );
  }

  // Build empty state with popular searches
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
                Icon(Icons.work_outline, size: 64, color: Color(0xFF2563EB)),
                SizedBox(height: 16),
                Text(
                  'Discover Your Next Opportunity',
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
                  'Search for jobs or browse popular categories below',
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

          // Popular Job Categories
          Row(
            children: [
              Icon(Icons.trending_up, color: Color(0xFF2563EB), size: 24),
              SizedBox(width: 8),
              Text(
                'Popular Job Categories',
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
                  itemCount: popularSearches.length,
                  itemBuilder: (context, index) {
                    final search = popularSearches[index];
                    return _buildPopularSearchCard(search);
                  },
                ),
        ],
      ),
    );
  }

  // Build popular search card
  Widget _buildPopularSearchCard(Map<String, dynamic> search) {
    return GestureDetector(
      onTap: () => _onPopularSearchTapped(search['query']),
      child: Container(
        padding: EdgeInsets.all(12), // Reduced from 16 to give more space
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
          mainAxisSize: MainAxisSize.min, // Added to prevent overflow
          children: [
            Text(
              search['icon'] ?? '💼',
              style: TextStyle(fontSize: 28), // Reduced from 32
            ),
            SizedBox(height: 6), // Reduced from 8
            Flexible( // Wrap title in Flexible
              child: Text(
                search['title'] ?? '',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13, // Reduced from 14
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2, // Added line height
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 3), // Reduced from 4
            Flexible( // Wrap description in Flexible
              child: Text(
                search['description'] ?? '',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9, // Reduced from 10
                  color: Colors.grey.shade600,
                  height: 1.2, // Added line height
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build error state
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
              onPressed: () => _loadJobs(),
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

  // Build jobs list
  Widget _buildJobsList(bool isMobile) {
    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: filteredJobs.length,
      itemBuilder: (context, index) {
        final job = filteredJobs[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildJobCard(job, isMobile),
        );
      },
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, bool isMobile) {
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
          // Job Title and Company
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['title'],
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
                        Icon(Icons.business, size: 14, color: Colors.grey.shade600),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            job['company'],
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
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
                  job['type'],
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

          // Location and Salary
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  job['location'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.attach_money, size: 16, color: Color(0xFF2563EB)),
              Text(
                job['salary'],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Description
          Text(
            job['description'],
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // FIXED: Added missing closing bracket for skills section
          if (job['skills'] != null && (job['skills'] as List).isNotEmpty) ...[
            SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (job['skills'] as List).take(5).map((skill) => Container(
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

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showJobDetails(job),
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
                onPressed: () => _saveJob(job),
                icon: Icon(Icons.bookmark_border, size: 16),
                label: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF2563EB),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  side: BorderSide(color: Color(0xFF2563EB)),
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

  void _showJobDetails(Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          job['title'],
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Company: ${job['company']}'),
              SizedBox(height: 8),
              Text('Location: ${job['location']}'),
              SizedBox(height: 8),
              Text('Salary: ${job['salary']}'),
              SizedBox(height: 8),
              Text('Type: ${job['type']}'),
              SizedBox(height: 16),
              Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(job['description']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if (job['apply_link'] != null && job['apply_link'].toString().isNotEmpty)
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                
                // Mark as applied in backend
                try {
                  await UserProfile.addAppliedJob(job);
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Job marked as applied! Opening application link...'),
                          ],
                        ),
                        backgroundColor: Colors.green.shade400,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error marking job as applied: $e');
                }
                
                // Launch the application URL
                await _launchJobUrl(job['apply_link']);
              },
              icon: Icon(Icons.open_in_new, size: 16),
              label: Text('Apply Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _saveJob(Map<String, dynamic> job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.bookmark, color: Colors.white),
            SizedBox(width: 8),
            Text('Job saved successfully!'),
          ],
        ),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
