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
  });

  factory JobMatch.fromJson(Map<String, dynamic> json) {
    return JobMatch(
      jobId: json['job_id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      salary: json['salary'],
      jobType: json['job_type'],
      requiredSkills: List<String>.from(json['required_skills']),
      description: json['description'],
      postedDate: json['posted_date'],
      matchPercentage: json['match_percentage'],
      matchingSkills: List<String>.from(json['matching_skills']),
      missingSkills: List<String>.from(json['missing_skills']),
      isRecommended: json['is_recommended'] ?? false,
    );
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
      courseId: json['course_id'],
      title: json['title'],
      provider: json['provider'],
      duration: json['duration'],
      level: json['level'],
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      reviews: json['reviews'] ?? 0,
      price: json['price'] ?? 'Free',
      skillsCovered: List<String>.from(json['skills_covered']),
      category: json['category'],
      isFree: json['is_free'] ?? false,
    );
  }
}