import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000'; // Change for production
  String? _token;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Helper method to handle API responses
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw ApiException(error, response.statusCode);
    }
  }

  // Authentication endpoints
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? dob,
    String? phoneNumber,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'full_name': fullName,
        if (dob != null) 'dob': dob,
        if (phoneNumber != null) 'phone_number': phoneNumber,
      }),
    );

    final data = _handleResponse(response);
    _token = data['token'];
    return data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = _handleResponse(response);
    _token = data['token'];
    return data;
  }

  // Job search endpoints
  Future<List<dynamic>> searchJobs(String query, {String? location}) async {
    final params = <String, String>{
      'query': query,
      if (location != null) 'location': location,
    };
    
    final uri = Uri.parse('$baseUrl/jobs/search').replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);

    final data = _handleResponse(response);
    return data['data'] ?? [];
  }

  Future<Map<String, dynamic>> getJobDetails(String jobId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/$jobId'),
      headers: _headers,
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getJobWithSkillAnalysis(String jobId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/$jobId/details'),
      headers: _headers,
    );

    return _handleResponse(response);
  }

  Future<List<dynamic>> getJobsByCompany(String company) async {
    final uri = Uri.parse('$baseUrl/jobs/company').replace(
      queryParameters: {'company': company},
    );
    final response = await http.get(uri, headers: _headers);

    final data = _handleResponse(response);
    return data['data'] ?? [];
  }

  // Job recommendations endpoints
  Future<List<dynamic>> getJobRecommendations({String? location}) async {
    final params = <String, String>{
      if (location != null) 'location': location,
    };
    
    final uri = Uri.parse('$baseUrl/jobs/recommendations').replace(
      queryParameters: params.isNotEmpty ? params : null,
    );
    final response = await http.get(uri, headers: _headers);

    final data = _handleResponse(response);
    return data['data'] ?? [];
  }

  // Resume upload endpoint
  Future<List<String>> uploadResume(File resumeFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/resume/upload'),
    );
    
    request.headers.addAll({
      'Authorization': 'Bearer $_token',
    });
    
    request.files.add(await http.MultipartFile.fromPath('file', resumeFile.path));
    
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    
    final data = _handleResponse(response);
    return List<String>.from(data['skills'] ?? []);
  }

  // Job application endpoints
  Future<void> markJobAsApplied({
    required String jobId,
    required String jobTitle,
    String? companyName,
    String? jobApplyLink,
    String? jobDescription,
    String? location,
    String? employmentType,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jobs/applications'),
      headers: _headers,
      body: jsonEncode({
        'job_id': jobId,
        'job_title': jobTitle,
        if (companyName != null) 'company_name': companyName,
        if (jobApplyLink != null) 'job_apply_link': jobApplyLink,
        if (jobDescription != null) 'job_description': jobDescription,
        if (location != null) 'location': location,
        if (employmentType != null) 'employment_type': employmentType,
        if (notes != null) 'notes': notes,
      }),
    );

    _handleResponse(response);
  }

  Future<List<dynamic>> getAppliedJobs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/applications'),
      headers: _headers,
    );

    final data = _handleResponse(response);
    return data['applications'] ?? [];
  }

  Future<Map<String, dynamic>?> checkJobApplication(String jobId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/applications/$jobId'),
      headers: _headers,
    );

    if (response.statusCode == 404) {
      return null; // Job not applied
    }

    final data = _handleResponse(response);
    return data;
  }

  Future<void> updateApplicationStatus(String jobId, String status, {String? notes}) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/jobs/applications/$jobId'),
      headers: _headers,
      body: jsonEncode({
        'status': status,
        if (notes != null) 'notes': notes,
      }),
    );

    _handleResponse(response);
  }

  Future<void> deleteApplication(String jobId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/jobs/applications/$jobId'),
      headers: _headers,
    );

    _handleResponse(response);
  }

  // Course recommendations endpoint
  Future<Map<String, dynamic>> getCourseRecommendations(String jobId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/$jobId/courses'),
      headers: _headers,
    );

    return _handleResponse(response);
  }

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}