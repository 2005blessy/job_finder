import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';  // ADD THIS IMPORT
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.43:3000'; // Changed from localhost
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
    return data['jobs'] ?? [];
  }

  Future<List<dynamic>> getPopularJobSearches() async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/popular'),
      headers: _headers,
    );

    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['popular_searches'] ?? []);
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
      queryParameters: {'name': company},
    );
    final response = await http.get(uri, headers: _headers);

    final data = _handleResponse(response);
    return data['jobs'] ?? [];
  }

  // Job recommendations endpoints
  Future<dynamic> getJobRecommendations({String? location}) async {
    final params = <String, String>{
      if (location != null) 'location': location,
    };
    
    final uri = Uri.parse('$baseUrl/jobs/recommendations').replace(
      queryParameters: params.isNotEmpty ? params : null,
    );
    
    print('🔍 Fetching job recommendations from: $uri');
    print('🔑 Auth token present: ${_token != null}');
    
    final response = await http.get(uri, headers: _headers);
    
    print('📥 Response status: ${response.statusCode}');
    
    // Return the full response data (includes jobs, user_skills, top_skills, etc.)
    final data = _handleResponse(response);
    
    print('✅ Job recommendations response received');
    print('📊 Response keys: ${data is Map ? (data as Map).keys.toList() : "Not a map"}');
    
    return data;  // Changed from: data['jobs'] ?? []
  }

  // Resume upload endpoint (for mobile/desktop with file path)
  Future<List<String>> uploadResume(File resumeFile) async {
    try {
      print('📤 Starting resume upload...');
      print('📁 File path: ${resumeFile.path}');
      print('📄 File exists: ${await resumeFile.exists()}');
      print('🔑 Token available: ${_token != null ? "Yes" : "No"}');
      
      if (_token == null || _token!.isEmpty) {
        throw ApiException('Not authenticated. Please login first.', 401);
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/resume/upload'),
      );
      
      request.headers.addAll({
        'Authorization': 'Bearer $_token',
      });
      
      var multipartFile = await http.MultipartFile.fromPath(
        'resume',
        resumeFile.path,
      );
      request.files.add(multipartFile);
      
      print('📋 Multipart file added: ${multipartFile.filename}, size: ${multipartFile.length} bytes');
      print('🌐 Uploading to: $baseUrl/resume/upload');
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final skillsList = List<String>.from(data['extracted_skills'] ?? data['skills'] ?? []);
        print('✅ Successfully extracted ${skillsList.length} skills: $skillsList');
        return skillsList;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'] ?? errorData['message'] ?? 'Unknown error';
        print('❌ Upload failed: $errorMessage');
        throw ApiException(errorMessage, response.statusCode);
      }
    } catch (e) {
      print('❌ Exception during resume upload: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to upload resume: ${e.toString()}', 500);
    }
  }

  // Resume upload with bytes (works on web and mobile) - ADD THIS METHOD
  Future<List<String>> uploadResumeBytes(Uint8List fileBytes, String fileName) async {
    try {
      print('📤 Starting resume upload with bytes...');
      print('📁 File name: $fileName');
      print('📊 File size: ${fileBytes.length} bytes');
      print('🔑 Token available: ${_token != null ? "Yes" : "No"}');
      
      if (_token == null || _token!.isEmpty) {
        throw ApiException('Not authenticated. Please login first.', 401);
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/resume/upload'),
      );
      
      request.headers.addAll({
        'Authorization': 'Bearer $_token',
      });
      
      // Add file from bytes (works on web and mobile)
      var multipartFile = http.MultipartFile.fromBytes(
        'resume',  // Backend expects 'resume' field name
        fileBytes,
        filename: fileName,
      );
      request.files.add(multipartFile);
      
      print('📋 Multipart file added: $fileName, size: ${fileBytes.length} bytes');
      print('🌐 Uploading to: $baseUrl/resume/upload');
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        
        // Backend returns 'extracted_skills'
        final skills = data['extracted_skills'];
        
        if (skills == null) {
          print('⚠️  No extracted_skills in response, checking alternatives...');
          print('📋 Available keys: ${data.keys.toList()}');
        }
        
        final skillsList = List<String>.from(skills ?? data['skills'] ?? []);
        print('✅ Successfully extracted ${skillsList.length} skills: $skillsList');
        
        return skillsList;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'] ?? errorData['message'] ?? 'Unknown error';
        print('❌ Upload failed: $errorMessage');
        throw ApiException(errorMessage, response.statusCode);
      }
    } catch (e) {
      print('❌ Exception during resume upload: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to upload resume: ${e.toString()}', 500);
    }
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
      return null;
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

  // Course recommendations endpoints
  Future<Map<String, dynamic>> getCourseRecommendations(String jobId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/$jobId/courses'),
      headers: _headers,
    );

    return _handleResponse(response);
  }

  Future<List<dynamic>> getCoursesBySkills(List<String> skills) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses/recommendations'),
      headers: _headers,
      body: jsonEncode({'skills': skills}),
    );

    final data = _handleResponse(response);
    return data['data'] ?? data['courses'] ?? [];
  }

  Future<List<dynamic>> searchCourses(String query, {String? provider}) async {
    final params = <String, String>{
      'query': query,
      if (provider != null && provider != 'all') 'provider': provider,
    };
    
    final uri = Uri.parse('$baseUrl/courses/search').replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);

    final data = _handleResponse(response);
    return data['courses'] ?? [];
  }

  Future<List<dynamic>> getPopularCourses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/courses/popular'),
      headers: _headers,
    );

    final data = _handleResponse(response);
    return data['popular_courses'] ?? [];
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