import 'package:flutter/material.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  List<Map<String, dynamic>> jobs = [
    {
      'title': 'Flutter Developer',
      'company': 'TechCorp Inc.',
      'location': 'Remote',
      'salary': '\$80,000 - \$120,000',
      'type': 'Full-time',
      'skills': ['Flutter', 'Dart', 'Firebase'],
      'description': 'Build cross-platform mobile applications using Flutter framework.',
      'posted': '2 days ago',
    },
    {
      'title': 'Backend Engineer',
      'company': 'WebWorks Solutions',
      'location': 'New York, NY',
      'salary': '\$90,000 - \$130,000',
      'type': 'Full-time',
      'skills': ['Java', 'Spring Boot', 'AWS'],
      'description': 'Develop scalable backend services and APIs for web applications.',
      'posted': '1 day ago',
    },
    {
      'title': 'UI/UX Designer',
      'company': 'Design Studio',
      'location': 'San Francisco, CA',
      'salary': '\$70,000 - \$100,000',
      'type': 'Full-time',
      'skills': ['Figma', 'Adobe XD', 'Prototyping'],
      'description': 'Create intuitive user interfaces and exceptional user experiences.',
      'posted': '3 days ago',
    },
    {
      'title': 'Mobile App Developer',
      'company': 'StartupXYZ',
      'location': 'Austin, TX',
      'salary': '\$75,000 - \$110,000',
      'type': 'Contract',
      'skills': ['React Native', 'JavaScript', 'Node.js'],
      'description': 'Develop and maintain mobile applications for iOS and Android.',
      'posted': '5 days ago',
    },
    {
      'title': 'DevOps Engineer',
      'company': 'CloudTech',
      'location': 'Seattle, WA',
      'salary': '\$95,000 - \$140,000',
      'type': 'Full-time',
      'skills': ['Docker', 'Kubernetes', 'CI/CD'],
      'description': 'Manage cloud infrastructure and deployment pipelines.',
      'posted': '1 week ago',
    },
  ];

  List<Map<String, dynamic>> filteredJobs = [];
  String searchQuery = '';
  String selectedJobType = 'All';

  @override
  void initState() {
    super.initState();
    filteredJobs = jobs;
  }

  void _filterJobs() {
    setState(() {
      filteredJobs = jobs.where((job) {
        final titleMatch = job['title'].toString().toLowerCase().contains(searchQuery.toLowerCase());
        final companyMatch = job['company'].toString().toLowerCase().contains(searchQuery.toLowerCase());
        
        // Fix the skills filtering logic
        final skillsMatch = (job['skills'] as List<dynamic>).any((skill) => 
          skill.toString().toLowerCase().contains(searchQuery.toLowerCase())
        );
        
        final matchesSearch = titleMatch || companyMatch || skillsMatch;
        final matchesType = selectedJobType == 'All' || job['type'] == selectedJobType;
        
        return matchesSearch && matchesType;
      }).toList();
    });
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
                        onChanged: (value) {
                          searchQuery = value;
                          _filterJobs();
                        },
                        decoration: InputDecoration(
                          hintText: 'Search jobs, companies, or skills...',
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
                        children: ['All', 'Full-time', 'Contract', 'Part-time'].map((type) {
                          bool isSelected = selectedJobType == type;
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(type),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedJobType = type;
                                });
                                _filterJobs();
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
              Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${filteredJobs.length} job${filteredJobs.length != 1 ? 's' : ''} found',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              
              // Jobs List
              Expanded(
                child: filteredJobs.isEmpty 
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No jobs found',
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
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                      itemCount: filteredJobs.length,
                      itemBuilder: (context, index) {
                        final job = filteredJobs[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: _buildJobCard(job, isMobile),
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

  Widget _buildJobCard(Map<String, dynamic> job, bool isMobile) {
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
          // Job Header
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
                    Text(
                      '${job['company']} • ${job['location']}',
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
                  color: job['type'] == 'Full-time' 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: job['type'] == 'Full-time' 
                        ? Colors.green.withOpacity(0.3)
                        : Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  job['type'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: job['type'] == 'Full-time' 
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
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
                job['salary'],
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
                job['posted'],
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
          
          SizedBox(height: 16),
          
          // Skills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (job['skills'] as List<dynamic>).map<Widget>((skill) => Container(
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
          
          SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle view details
                    _showJobDetails(job);
                  },
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
                onPressed: () {
                  // Handle save job
                  _saveJob(job);
                },
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
                  job['title'],
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
                Text(
                  '${job['company']} • ${job['location']}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Salary: ${job['salary']}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Job Type: ${job['type']}',
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
                  job['description'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Required Skills:',
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
                  children: (job['skills'] as List<dynamic>).map<Widget>((skill) => Container(
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
                // Handle apply for job
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

  void _applyForJob(Map<String, dynamic> job) {
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
