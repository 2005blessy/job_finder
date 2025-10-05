import 'package:job_finder/src/core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProfile {
  static String name = '';
  static String email = '';
  static String phone = '';
  static String dateOfBirth = '';
  static String userId = '';
  static bool resumeUploaded = false;
  
  // New fields for skill-based recommendations
  static List<String> extractedSkills = [];
  static List<String> topSkills = []; // Top 3 skills for recommendations
  static bool hasRecommendations = false;
  static DateTime? lastResumeUpload;
  
  // Applied Jobs tracking (now synced with backend)
  static List<Map<String, dynamic>> appliedJobs = [];
  
  static final ApiService _apiService = ApiService();
  
  // SharedPreferences keys
  static const String _keyExtractedSkills = 'extracted_skills';
  static const String _keyTopSkills = 'top_skills';
  static const String _keyResumeUploaded = 'resume_uploaded';
  static const String _keyLastUploadDate = 'last_upload_date';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserDob = 'user_dob';
  static const String _keyUserId = 'user_id';
  
  // Initialize app - load persisted data
  static Future<void> init() async {
    await loadPersistedData();
  }
  
  // Load persisted data from SharedPreferences
  static Future<void> loadPersistedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load user data
      userId = prefs.getString(_keyUserId) ?? '';
      name = prefs.getString(_keyUserName) ?? '';
      email = prefs.getString(_keyUserEmail) ?? '';
      phone = prefs.getString(_keyUserPhone) ?? '';
      dateOfBirth = prefs.getString(_keyUserDob) ?? '';
      
      // Load resume data
      resumeUploaded = prefs.getBool(_keyResumeUploaded) ?? false;
      
      final skillsJson = prefs.getStringList(_keyExtractedSkills);
      if (skillsJson != null) {
        extractedSkills = skillsJson;
      }
      
      final topSkillsJson = prefs.getStringList(_keyTopSkills);
      if (topSkillsJson != null) {
        topSkills = topSkillsJson;
      }
      
      final uploadDateStr = prefs.getString(_keyLastUploadDate);
      if (uploadDateStr != null) {
        lastResumeUpload = DateTime.parse(uploadDateStr);
      }
      
      hasRecommendations = extractedSkills.isNotEmpty;
      
      print('✅ Loaded persisted data: ${extractedSkills.length} skills, resume uploaded: $resumeUploaded');
    } catch (e) {
      print('❌ Error loading persisted data: $e');
    }
  }
  
  // Initialize from backend login/register response
  static Future<void> setUserData(Map<String, dynamic> userData, String token) async {
    final user = userData['user'];
    userId = user['id'] ?? '';
    name = user['full_name'] ?? '';
    email = user['email'] ?? '';
    phone = user['phone_number'] ?? '';
    dateOfBirth = user['dob'] ?? '';
    
    _apiService.setToken(token);
    
    // Persist user data
    await _persistUserData();
  }
  
  // Persist user data to SharedPreferences
  static Future<void> _persistUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserId, userId);
      await prefs.setString(_keyUserName, name);
      await prefs.setString(_keyUserEmail, email);
      await prefs.setString(_keyUserPhone, phone);
      await prefs.setString(_keyUserDob, dateOfBirth);
      
      print('✅ User data persisted');
    } catch (e) {
      print('❌ Error persisting user data: $e');
    }
  }
  
  // Helper methods for skills
  static Future<void> setExtractedSkills(List<String> skills) async {
    extractedSkills = skills;
    topSkills = skills.take(3).toList(); // Get top 3 skills
    hasRecommendations = skills.isNotEmpty;
    lastResumeUpload = DateTime.now();
    resumeUploaded = skills.isNotEmpty;
    
    // Persist resume data
    await _persistResumeData();
  }
  
  // Persist resume data to SharedPreferences
  static Future<void> _persistResumeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyExtractedSkills, extractedSkills);
      await prefs.setStringList(_keyTopSkills, topSkills);
      await prefs.setBool(_keyResumeUploaded, resumeUploaded);
      
      if (lastResumeUpload != null) {
        await prefs.setString(_keyLastUploadDate, lastResumeUpload!.toIso8601String());
      }
      
      print('✅ Resume data persisted: ${extractedSkills.length} skills');
    } catch (e) {
      print('❌ Error persisting resume data: $e');
    }
  }
  
  static Future<void> clearSkills() async {
    extractedSkills.clear();
    topSkills.clear();
    hasRecommendations = false;
    lastResumeUpload = null;
    resumeUploaded = false;
    
    // Clear from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyExtractedSkills);
      await prefs.remove(_keyTopSkills);
      await prefs.remove(_keyResumeUploaded);
      await prefs.remove(_keyLastUploadDate);
      
      print('✅ Resume data cleared from storage');
    } catch (e) {
      print('❌ Error clearing resume data: $e');
    }
  }
  
  // Applied jobs methods (now with backend sync)
  static Future<void> addAppliedJob(Map<String, dynamic> job) async {
    try {
      await _apiService.markJobAsApplied(
        jobId: job['job_id'] ?? job['title'] ?? '',
        jobTitle: job['job_title'] ?? job['title'] ?? '',
        companyName: job['employer_name'] ?? job['company'] ?? '',
        location: job['job_city'] ?? job['location'] ?? '',
        employmentType: job['job_employment_type'] ?? job['type'] ?? '',
      );
      
      // Add to local cache
      if (!appliedJobs.any((appliedJob) => 
          appliedJob['job_id'] == job['job_id'] || 
          (appliedJob['title'] == job['title'] && appliedJob['company'] == job['company']))) {
        final jobWithApplicationDate = Map<String, dynamic>.from(job);
        jobWithApplicationDate['appliedDate'] = DateTime.now().toString().split(' ')[0];
        jobWithApplicationDate['applicationStatus'] = 'Applied';
        appliedJobs.add(jobWithApplicationDate);
      }
    } catch (e) {
      throw Exception('Failed to mark job as applied: $e');
    }
  }
  
  static bool hasAppliedToJob(Map<String, dynamic> job) {
    return appliedJobs.any((appliedJob) => 
      appliedJob['job_id'] == job['job_id'] ||
      (appliedJob['title'] == job['title'] && appliedJob['company'] == job['company'])
    );
  }
  
  static Future<void> syncAppliedJobs() async {
    try {
      final backendJobs = await _apiService.getAppliedJobs();
      appliedJobs = backendJobs.map<Map<String, dynamic>>((job) => {
        'job_id': job['job_id'],
        'title': job['job_title'],
        'company': job['company_name'],
        'location': job['location'],
        'type': job['employment_type'],
        'appliedDate': job['applied_at']?.toString().split('T')[0] ?? '',
        'applicationStatus': job['status'] ?? 'Applied',
      }).toList();
    } catch (e) {
      print('Failed to sync applied jobs: $e');
    }
  }
  
  static void clearAppliedJobs() {
    appliedJobs.clear();
  }
  
  static int get totalApplications => appliedJobs.length;
  
  // Profile completion helper
  static double get profileCompletionPercentage {
    int filledFields = 0;
    int totalFields = 4; // name, email, phone, dateOfBirth
    
    if (name.isNotEmpty) filledFields++;
    if (email.isNotEmpty) filledFields++;
    if (phone.isNotEmpty) filledFields++;
    if (dateOfBirth.isNotEmpty) filledFields++;
    
    return filledFields / totalFields;
  }
  
  // Clear all profile data (only on logout)
  static Future<void> clearProfile() async {
    name = '';
    email = '';
    phone = '';
    dateOfBirth = '';
    userId = '';
    resumeUploaded = false;
    await clearSkills();
    clearAppliedJobs();
    _apiService.clearToken();
    
    // Clear all from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('✅ All profile data cleared from storage');
    } catch (e) {
      print('❌ Error clearing profile data: $e');
    }
  }
}
