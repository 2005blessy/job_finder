import 'package:job_finder/src/core/services/api_service.dart';

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
  
  // Initialize from backend login/register response
  static void setUserData(Map<String, dynamic> userData, String token) {
    final user = userData['user'];
    userId = user['id'] ?? '';
    name = user['full_name'] ?? '';
    email = user['email'] ?? '';
    phone = user['phone_number'] ?? '';
    dateOfBirth = user['dob'] ?? '';
    
    _apiService.setToken(token);
  }
  
  // Helper methods for skills
  static void setExtractedSkills(List<String> skills) {
    extractedSkills = skills;
    topSkills = skills.take(3).toList(); // Get top 3 skills
    hasRecommendations = skills.isNotEmpty;
    lastResumeUpload = DateTime.now();
    resumeUploaded = skills.isNotEmpty;
  }
  
  static void clearSkills() {
    extractedSkills.clear();
    topSkills.clear();
    hasRecommendations = false;
    lastResumeUpload = null;
    resumeUploaded = false;
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
  
  // Clear all profile data
  static void clearProfile() {
    name = '';
    email = '';
    phone = '';
    dateOfBirth = '';
    userId = '';
    resumeUploaded = false;
    clearSkills();
    clearAppliedJobs();
    _apiService.clearToken();
  }
}
