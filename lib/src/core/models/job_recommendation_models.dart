import 'package:flutter/material.dart';

class JobMatch {
  final String jobId;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String jobType;
  final List<String> requiredSkills;
  final String description;
  final String postedDate;
  final int matchPercentage;
  final List<String> matchingSkills;
  final List<String> missingSkills;
  final bool isRecommended;
  final String? applyLink;

  const JobMatch({
    required this.jobId,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.requiredSkills,
    required this.description,
    required this.postedDate,
    required this.matchPercentage,
    required this.matchingSkills,
    required this.missingSkills,
    required this.isRecommended,
    this.applyLink,
  });

  factory JobMatch.fromJson(Map<String, dynamic> json) {
    return JobMatch(
      jobId: json['job_id'] ?? json['id'] ?? '',
      title: json['job_title'] ?? json['title'] ?? 'No Title',
      company: json['employer_name'] ?? json['company'] ?? 'Unknown Company',
      location: json['job_city'] ?? json['job_state'] ?? json['location'] ?? 'Remote',
      
      // Salary handling - FIXED to remove unwanted spaces
      salary: _parseSalary(json),
      
      jobType: json['job_employment_type'] ?? json['job_type'] ?? 'Full-time',
      
      requiredSkills: _parseSkillsList(json['job_required_skills']) ?? 
                       _parseSkillsList(json['required_skills']) ?? [],
      
      description: json['job_description'] ?? json['description'] ?? 'No description available',
      
      postedDate: _parsePostedDate(json),
      
      // FIXED: Ensure matchPercentage is properly converted to int
      matchPercentage: _parseMatchPercentage(json),
      
      matchingSkills: _parseSkillsList(json['matched_skills']) ?? 
                      _parseSkillsList(json['matching_skills']) ?? [],
      missingSkills: _parseSkillsList(json['missing_skills']) ?? [],
      
      isRecommended: json['is_recommended'] ?? true,
      applyLink: json['job_apply_link'] ?? json['apply_link'],
    );
  }

  // FIXED: Helper to parse match percentage and ensure it's a clean integer
  static int _parseMatchPercentage(Map<String, dynamic> json) {
    var value = json['skill_match_percentage'] ?? json['match_percentage'] ?? 0;
    
    if (value is int) {
      return value;
    }
    
    if (value is double) {
      return value.round();
    }
    
    if (value is String) {
      // Remove any non-numeric characters except decimal point
      String cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleaned)?.round() ?? 0;
    }
    
    return 0;
  }

  // FIXED: Helper to parse salary - removes spaces and formats cleanly
  static String _parseSalary(Map<String, dynamic> json) {
    // Try different salary field names from JSearch API
    String? rawSalary;
    
    if (json['job_salary'] != null && json['job_salary'].toString().isNotEmpty) {
      rawSalary = json['job_salary'].toString();
    } else if (json['job_min_salary'] != null && json['job_max_salary'] != null) {
      // Format salary range with proper number formatting
      var minSalary = _formatSalaryNumber(json['job_min_salary']);
      var maxSalary = _formatSalaryNumber(json['job_max_salary']);
      return '\$$minSalary - \$$maxSalary';
    } else if (json['salary'] != null && json['salary'].toString().isNotEmpty) {
      rawSalary = json['salary'].toString();
    }
    
    if (rawSalary != null && rawSalary.isNotEmpty && rawSalary != 'null') {
      // Remove any unwanted spaces and clean up the salary string
      return rawSalary
          .replaceAll(RegExp(r'\s+'), ' ')  // Replace multiple spaces with single space
          .trim();  // Remove leading/trailing spaces
    }
    
    return 'Not specified';
  }

  // Helper to format salary numbers (remove spaces, add commas properly)
  static String _formatSalaryNumber(dynamic value) {
    if (value == null) return '0';
    
    String strValue = value.toString()
        .replaceAll(RegExp(r'[^\d.]'), '');  // Remove everything except digits and decimal
    
    double? numValue = double.tryParse(strValue);
    if (numValue == null) return '0';
    
    // Format with commas (no spaces)
    int intValue = numValue.round();
    String formatted = intValue.toString();
    
    // Add commas for thousands
    String result = '';
    int count = 0;
    for (int i = formatted.length - 1; i >= 0; i--) {
      if (count == 3) {
        result = ',$result';
        count = 0;
      }
      result = formatted[i] + result;
      count++;
    }
    
    return result;
  }

  // Helper to parse posted date
  static String _parsePostedDate(Map<String, dynamic> json) {
    if (json['job_posted_at_datetime_utc'] != null) {
      try {
        DateTime postedDate = DateTime.parse(json['job_posted_at_datetime_utc']);
        Duration diff = DateTime.now().difference(postedDate);
        
        if (diff.inDays == 0) return 'Today';
        if (diff.inDays == 1) return 'Yesterday';
        if (diff.inDays < 7) return '${diff.inDays} days ago';
        if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
        return '${(diff.inDays / 30).floor()} months ago';
      } catch (e) {
        // Fall through to other options
      }
    }
    
    if (json['job_posted_at_timestamp'] != null) {
      try {
        int timestamp = json['job_posted_at_timestamp'];
        DateTime postedDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        Duration diff = DateTime.now().difference(postedDate);
        
        if (diff.inDays == 0) return 'Today';
        if (diff.inDays == 1) return 'Yesterday';
        if (diff.inDays < 7) return '${diff.inDays} days ago';
        return '${(diff.inDays / 7).floor()} weeks ago';
      } catch (e) {
        // Fall through
      }
    }
    
    return json['posted_date'] ?? 'Recently';
  }

  // Helper to parse skills list
  static List<String>? _parseSkillsList(dynamic skillsData) {
    if (skillsData == null) return null;
    
    if (skillsData is List) {
      return skillsData.map((e) => e.toString()).toList();
    }
    
    if (skillsData is String && skillsData.isNotEmpty) {
      // If it's a comma-separated string
      return skillsData.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    
    return null;
  }
}

class CourseRecommendation {
  final String courseId;
  final String title;
  final String provider;
  final String duration;
  final String level;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String price;
  final List<String> skillsCovered;
  final String category;
  final bool isFree;

  const CourseRecommendation({
    required this.courseId,
    required this.title,
    required this.provider,
    required this.duration,
    required this.level,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.skillsCovered,
    required this.category,
    required this.isFree,
  });

  factory CourseRecommendation.fromJson(Map<String, dynamic> json) {
    return CourseRecommendation(
      courseId: json['course_id'] ?? json['id'] ?? '',
      title: json['title'] ?? 'No Title',
      provider: json['provider'] ?? 'Unknown',
      duration: json['duration'] ?? 'Self-paced',
      level: json['level'] ?? 'Beginner',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? json['thumbnail'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      price: json['price'] ?? 'Free',
      skillsCovered: _parseSkillsList(json['skills_covered']) ?? 
                     _parseSkillsList(json['skills']) ?? [],
      category: json['category'] ?? 'General',
      isFree: json['is_free'] ?? (json['price'] == 'Free' || json['price'] == '0'),
    );
  }

  static List<String> _parseSkillsList(dynamic skillsData) {
    if (skillsData == null) return [];
    
    if (skillsData is List) {
      return skillsData.map((e) => e.toString()).toList();
    }
    
    if (skillsData is String && skillsData.isNotEmpty) {
      return skillsData.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    
    return [];
  }
}

// Example usage inside a widget class or build method:
Widget buildMatchPercentageText(JobMatch job) {
  return Text(
    '${job.matchPercentage}%',  // Display match percentage with '%' sign
    style: TextStyle(
      fontFeatures: [FontFeature.tabularFigures()],  // Forces monospaced numbers
    ),
  );
}