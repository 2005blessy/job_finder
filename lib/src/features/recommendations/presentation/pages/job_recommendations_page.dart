import 'package:flutter/material.dart';
import 'package:job_finder/src/shared/user_profile.dart';
import 'package:job_finder/src/core/models/job_recommendation_models.dart';
import 'package:job_finder/src/core/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';  // ADD THIS IMPORT

class JobRecommendationsPage extends StatefulWidget {
  const JobRecommendationsPage({super.key});

  @override
  State<JobRecommendationsPage> createState() => _JobRecommendationsPageState();
}

class _JobRecommendationsPageState extends State<JobRecommendationsPage> {
  List<JobMatch> recommendedJobs = [];
  bool _isLoading = true;
  String? _errorMessage;
  List<String> _userSkills = [];
  List<String> _topSkills = [];

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🎯 Loading job recommendations from backend...');

      // Call backend API
      final response = await ApiService().getJobRecommendations();

      print('✅ Received response from backend');
      print('📦 Response type: ${response.runtimeType}');
      print('📊 Response data: $response');

      // Backend returns: { jobs: [...], user_skills: [...], top_skills: [...], ... }
      List<dynamic> jobs;

      if (response is Map<String, dynamic>) {
        // Extract jobs array from response
        jobs = response['jobs'] ?? [];
        _userSkills = List<String>.from(response['user_skills'] ?? []);
        _topSkills = List<String>.from(response['top_skills'] ?? []);

        print('👤 User has ${_userSkills.length} total skills');
        print('⭐ Top skills: $_topSkills');
        print('💼 Found ${jobs.length} job recommendations');
      } else if (response is List) {
        // Fallback if response is directly a list
        jobs = response;
        _userSkills = UserProfile.extractedSkills;
        _topSkills = UserProfile.topSkills;
      } else {
        throw Exception('Unexpected response format: ${response.runtimeType}');
      }

      setState(() {
        recommendedJobs = jobs
            .map<JobMatch>((e) => JobMatch.fromJson(e as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });

      print('✨ Successfully loaded ${recommendedJobs.length} job recommendations');
    } catch (e) {
      print('❌ Error loading job recommendations: $e');

      setState(() {
        recommendedJobs = [];
        _isLoading = false;

        // Provide user-friendly error messages
        if (e.toString().contains('401') || e.toString().contains('User ID not found')) {
          _errorMessage = 'Please login to view job recommendations.';
        } else if (e.toString().contains('No skills found')) {
          _errorMessage = 'Please upload your resume first to get personalized job recommendations.';
        } else if (e.toString().contains('RAPIDAPI_KEY')) {
          _errorMessage = 'Job search service is temporarily unavailable. Please contact support.';
        } else {
          _errorMessage = 'Failed to load recommendations. Please try again later.';
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Error Loading Recommendations'),
                  ],
                ),
                SizedBox(height: 4),
                Text(_errorMessage ?? e.toString()),
              ],
            ),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _loadRecommendations,
            ),
          ),
        );
      }
    }
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  // Add this method to launch URL
  Future<void> _launchJobUrl(String? url) async {
    if (url == null || url.isEmpty) {
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
          mode: LaunchMode.externalApplication,  // Opens in browser
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
          'Job Recommendations',
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
            icon: Icon(Icons.refresh),
            onPressed: _loadRecommendations,
            tooltip: 'Refresh recommendations',
          ),
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
                    'Analyzing your skills and finding perfect matches...',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This may take a few moments',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_errorMessage!.contains('resume')) ...[
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/resume'),
                                icon: Icon(Icons.upload_file),
                                label: Text('Upload Resume'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                            ],
                            OutlinedButton.icon(
                              onPressed: _loadRecommendations,
                              icon: Icon(Icons.refresh),
                              label: Text('Try Again'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFF2563EB),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                side: BorderSide(color: Color(0xFF2563EB)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobile = constraints.maxWidth < 600;

                    return Column(
                      children: [
                        // Header Section with updated skills display
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
                                  Icon(Icons.auto_awesome, color: Color(0xFF2563EB), size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Personalized for You',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2563EB).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${recommendedJobs.length} Jobs',
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
                              SizedBox(height: 8),
                              Text(
                                'Based on your top skills: ${_topSkills.isNotEmpty ? _topSkills.join(", ") : UserProfile.topSkills.join(", ")}',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              if (_userSkills.isNotEmpty) ...[
                                SizedBox(height: 4),
                                Text(
                                  'Total skills in your profile: ${_userSkills.length}',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildLegendItem(Colors.green, '80%+ Match'),
                                  SizedBox(width: 16),
                                  _buildLegendItem(Colors.orange, '60-79% Match'),
                                  SizedBox(width: 16),
                                  _buildLegendItem(Colors.red, 'Below 60%'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Jobs List
                        Expanded(
                          child: recommendedJobs.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.work_off,
                                        size: 64,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No job recommendations available.',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Try uploading your resume or updating your skills.',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                                  itemCount: recommendedJobs.length,
                                  itemBuilder: (context, index) {
                                    final job = recommendedJobs[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: _buildJobRecommendationCard(job, isMobile),
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

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildJobRecommendationCard(JobMatch job, bool isMobile) {
    Color matchColor = _getMatchColor(job.matchPercentage);

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
          // Job Header with Match Percentage
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${job.company} \u2022 ${job.location}',
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
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: matchColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: matchColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 14, color: matchColor),
                    SizedBox(width: 4),
                    Text(
                      '${job.matchPercentage}% Match',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: matchColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Salary and Posted Date
          Row(
            children: [
              Icon(Icons.attach_money, size: 16, color: Color(0xFF2563EB)),
              SizedBox(width: 4),
              Text(
                job.salary,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
              Spacer(),
              Icon(Icons.schedule, size: 16, color: Colors.grey.shade500),
              SizedBox(width: 4),
              Text(
                job.postedDate,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Description
          Text(
            job.description,
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

          // Matching Skills
          if (job.matchingSkills.isNotEmpty) ...[
            Text(
              'Matching Skills:',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: job.matchingSkills.map((skill) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade700,
                  ),
                ),
              )).toList(),
            ),
            SizedBox(height: 12),
          ],

          // Missing Skills
          if (job.missingSkills.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Skills to Learn:',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showCourseRecommendations(job.missingSkills),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFF2563EB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'View Courses',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: job.missingSkills.map((skill) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange.shade700,
                  ),
                ),
              )).toList(),
            ),
            SizedBox(height: 16),
          ],

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

  void _showJobDetails(JobMatch job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.work, color: Color(0xFF2563EB), size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  job.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getMatchColor(job.matchPercentage).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getMatchColor(job.matchPercentage).withOpacity(0.3)),
                  ),
                  child: Text(
                    '${job.matchPercentage}% Match',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getMatchColor(job.matchPercentage),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '${job.company} • ${job.location}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Salary: ${job.salary}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Job Type: ${job.jobType}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
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
                  job.description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'All Required Skills:',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.requiredSkills.map((skill) {
                    bool isMatching = job.matchingSkills.contains(skill);
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isMatching
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isMatching
                              ? Colors.green.withOpacity(0.3)
                              : Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isMatching ? Icons.check : Icons.school,
                            size: 12,
                            color: isMatching ? Colors.green.shade700 : Colors.orange.shade700,
                          ),
                          SizedBox(width: 4),
                          Text(
                            skill,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isMatching ? Colors.green.shade700 : Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            if (job.missingSkills.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showCourseRecommendations(job.missingSkills);
                },
                child: Text(
                  'View Courses',
                  style: TextStyle(color: Colors.orange.shade600),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            if (!UserProfile.hasAppliedToJob(_jobMatchToMap(job))) ...[
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _markAsApplied(job);
                },
                icon: Icon(Icons.bookmark, size: 18),
                label: Text('Mark as Applied'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(width: 8),
            ],
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _redirectToJobApplication(job);
              },
              icon: Icon(Icons.open_in_new, size: 18),
              label: Text(UserProfile.hasAppliedToJob(_jobMatchToMap(job)) ? 'View Application' : 'Apply Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: UserProfile.hasAppliedToJob(_jobMatchToMap(job)) ? Colors.grey : Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCourseRecommendations(List<String> missingSkills) {
    Navigator.pushNamed(
      context,
      '/course-recommendations',
      arguments: missingSkills,
    );
  }

  void _saveJob(JobMatch job) {
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

  void _markAsApplied(JobMatch job) {
    UserProfile.addAppliedJob(_jobMatchToMap(job));
    setState(() {}); // Refresh the UI to show updated status

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Job marked as applied!'),
          ],
        ),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Map<String, dynamic> _jobMatchToMap(JobMatch job) {
    return {
      'title': job.title,
      'company': job.company,
      'location': job.location,
      'type': job.jobType,
      'salary': job.salary,
      'matchPercentage': job.matchPercentage,
    };
  }

  void _redirectToJobApplication(JobMatch job) async {
    // Convert JobMatch to Map for backend compatibility
    final jobMap = {
      'job_id': job.jobId,
      'job_title': job.title,
      'employer_name': job.company,
      'job_city': job.location,
      'job_employment_type': job.jobType,
      'apply_link': job.applyLink,
    };

    // Mark as applied in backend
    try {
      await UserProfile.addAppliedJob(jobMap);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Job marked as applied! Opening application link...')),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark job as applied: ${e.toString()}'),
            backgroundColor: Colors.orange.shade400,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
    
    // Launch the application URL
      await _launchJobUrl(job.applyLink);
    }
  }