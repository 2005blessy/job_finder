import 'package:flutter/material.dart';
import 'package:job_finder/src/shared/user_profile.dart';
import 'package:job_finder/src/core/models/job_recommendation_models.dart';

class JobRecommendationsPage extends StatefulWidget {
  const JobRecommendationsPage({super.key});

  @override
  State<JobRecommendationsPage> createState() => _JobRecommendationsPageState();
}

class _JobRecommendationsPageState extends State<JobRecommendationsPage> {
  List<JobMatch> recommendedJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    // Simulate API call to backend
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      // Simulate recommended jobs based on user's top skills
      recommendedJobs = _generateMockRecommendations();
      _isLoading = false;
    });
  }

  List<JobMatch> _generateMockRecommendations() {
    // This will be replaced with actual backend API call
    return [
      JobMatch(
        jobId: '1',
        title: 'Senior Flutter Developer',
        company: 'TechCorp Solutions',
        location: 'Remote',
        salary: '\$90,000 - \$130,000',
        jobType: 'Full-time',
        requiredSkills: ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git', 'Agile'],
        description: 'Build cutting-edge mobile applications using Flutter framework with a focus on performance and user experience.',
        postedDate: '2 days ago',
        matchPercentage: 85,
        matchingSkills: ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git'],
        missingSkills: ['Agile'],
        isRecommended: true,
      ),
      JobMatch(
        jobId: '2',
        title: 'Mobile App Developer',
        company: 'StartupXYZ',
        location: 'San Francisco, CA',
        salary: '\$80,000 - \$120,000',
        jobType: 'Full-time',
        requiredSkills: ['Flutter', 'React Native', 'JavaScript', 'Mobile Development', 'UI/UX Design'],
        description: 'Develop cross-platform mobile applications and collaborate with design team for optimal user experience.',
        postedDate: '1 day ago',
        matchPercentage: 75,
        matchingSkills: ['Flutter', 'Mobile Development', 'UI/UX Design'],
        missingSkills: ['React Native', 'JavaScript'],
        isRecommended: true,
      ),
      JobMatch(
        jobId: '3',
        title: 'Frontend Developer',
        company: 'Digital Agency',
        location: 'New York, NY',
        salary: '\$70,000 - \$100,000',
        jobType: 'Full-time',
        requiredSkills: ['JavaScript', 'React', 'TypeScript', 'UI/UX Design', 'CSS'],
        description: 'Create responsive web applications and work closely with designers to implement pixel-perfect interfaces.',
        postedDate: '3 days ago',
        matchPercentage: 60,
        matchingSkills: ['UI/UX Design'],
        missingSkills: ['JavaScript', 'React', 'TypeScript', 'CSS'],
        isRecommended: true,
      ),
      JobMatch(
        jobId: '4',
        title: 'Mobile UI/UX Designer',
        company: 'Design Studio',
        location: 'Remote',
        salary: '\$75,000 - \$110,000',
        jobType: 'Contract',
        requiredSkills: ['UI/UX Design', 'Figma', 'Adobe XD', 'Mobile Development', 'Prototyping'],
        description: 'Design intuitive mobile interfaces and create prototypes for mobile applications.',
        postedDate: '1 week ago',
        matchPercentage: 70,
        matchingSkills: ['UI/UX Design', 'Mobile Development'],
        missingSkills: ['Figma', 'Adobe XD', 'Prototyping'],
        isRecommended: true,
      ),
    ];
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
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
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Based on your top skills: ${UserProfile.topSkills.join(", ")}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
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
                      child: ListView.builder(
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
                      '${job.company} • ${job.location}',
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _applyForJob(job);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Apply Now'),
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

  void _applyForJob(JobMatch job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.send, color: Colors.white),
            SizedBox(width: 8),
            Text('Application submitted successfully!'),
          ],
        ),
        backgroundColor: Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}