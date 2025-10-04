class UserProfile {
  static String name = '';
  static String email = '';
  static String phone = '';
  static String dateOfBirth = '';
  static bool resumeUploaded = false;
  
  // New fields for skill-based recommendations
  static List<String> extractedSkills = [];
  static List<String> topSkills = []; // Top 3 skills for recommendations
  static bool hasRecommendations = false;
  static DateTime? lastResumeUpload;
  
  // Applied Jobs tracking (session-based)
  static List<Map<String, dynamic>> appliedJobs = [];
  
  // Helper methods
  static void setExtractedSkills(List<String> skills) {
    extractedSkills = skills;
    topSkills = skills.take(3).toList(); // Get top 3 skills
    hasRecommendations = skills.isNotEmpty;
    lastResumeUpload = DateTime.now();
  }
  
  static void clearSkills() {
    extractedSkills.clear();
    topSkills.clear();
    hasRecommendations = false;
    lastResumeUpload = null;
  }
  
  // Applied jobs method
  static void addAppliedJob(Map<String, dynamic> job) {
    if (!appliedJobs.any((appliedJob) => appliedJob['title'] == job['title'] && appliedJob['company'] == job['company'])) {
      final jobWithApplicationDate = Map<String, dynamic>.from(job);
      jobWithApplicationDate['appliedDate'] = DateTime.now();
      jobWithApplicationDate['applicationStatus'] = 'Applied';
      appliedJobs.add(jobWithApplicationDate);
    }
  }
  
  static bool hasAppliedToJob(Map<String, dynamic> job) {
    return appliedJobs.any((appliedJob) => 
      appliedJob['title'] == job['title'] && appliedJob['company'] == job['company']
    );
  }
  
  static void clearAppliedJobs() {
    appliedJobs.clear();
  }
  
  static int get totalApplications => appliedJobs.length;
}
