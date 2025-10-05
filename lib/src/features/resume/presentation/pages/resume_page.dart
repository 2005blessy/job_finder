import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:job_finder/src/shared/user_profile.dart';
import 'package:job_finder/src/core/services/api_service.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  bool _hasUploadedFile = false;
  bool _isUploading = false;
  List<String> extractedSkills = [];
  String uploadedFileName = '';

  @override
  void initState() {
    super.initState();
    _loadPersistedResumeData();  // Load saved resume data
  }

  // Load persisted resume data from UserProfile
  void _loadPersistedResumeData() {
    print('📋 Loading persisted resume data...');
    
    // Load from UserProfile (which is already loaded from SharedPreferences in main)
    if (UserProfile.resumeUploaded && UserProfile.extractedSkills.isNotEmpty) {
      setState(() {
        _hasUploadedFile = true;
        extractedSkills = List<String>.from(UserProfile.extractedSkills);
        uploadedFileName = 'resume.pdf';  // We don't persist the filename, so use default
      });
      
      print('✅ Loaded ${extractedSkills.length} skills from persisted data');
      print('📋 Skills: ${extractedSkills.join(", ")}');
    } else {
      print('ℹ️  No persisted resume data found');
    }
  }

  Future<void> _uploadResume() async {
    try {
      print('🎯 Starting file picker...');
      
      // Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,  // IMPORTANT: Load file bytes for web platform
        withReadStream: false,
      );

      if (result == null) {
        print('⚠️  User cancelled file picker');
        return;
      }

      setState(() {
        _isUploading = true;
      });

      uploadedFileName = result.files.single.name;

      print('📁 Selected file: $uploadedFileName');
      print('📊 File size: ${result.files.single.size} bytes');
      
      // Check file size (max 10MB)
      int fileSize = result.files.single.size;
      if (fileSize > 10 * 1024 * 1024) {
        throw Exception('File size exceeds 10MB limit');
      }

      if (fileSize == 0) {
        throw Exception('File is empty');
      }

      // Get file bytes (works on both mobile and web)
      final bytes = result.files.single.bytes;
      if (bytes == null) {
        throw Exception('Failed to read file content');
      }

      print('✅ File bytes loaded: ${bytes.length} bytes');
      print('🚀 Calling API to upload resume...');
      
      // Call backend API with bytes
      final skills = await ApiService().uploadResumeBytes(bytes, uploadedFileName);

      print('✨ Upload successful! Skills received: ${skills.length}');

      setState(() {
        _hasUploadedFile = true;
        extractedSkills = skills;
        _isUploading = false;
      });

      // Update UserProfile with extracted skills (async, persists to storage)
      await UserProfile.setExtractedSkills(extractedSkills);
      
      print('💾 Skills persisted to storage');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cloud_upload, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Resume uploaded! ${skills.length} skills extracted.')),
              ],
            ),
            backgroundColor: Colors.green.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('❌ Error in _uploadResume: $e');
      
      setState(() {
        _isUploading = false;
      });
      
      String errorMessage = e.toString();
      
      // Provide user-friendly error messages
      if (errorMessage.contains('401') || errorMessage.contains('Not authenticated')) {
        errorMessage = 'Please login first to upload your resume.';
      } else if (errorMessage.contains('RAPIDAPI_KEY') || errorMessage.contains('GEMINI_API_KEY')) {
        errorMessage = 'Server configuration error. Please contact support.';
      } else if (errorMessage.contains('Failed to parse file')) {
        errorMessage = 'Invalid file format. Please upload a PDF file.';
      } else if (errorMessage.contains('exceeds')) {
        errorMessage = 'File too large. Maximum size is 10MB.';
      } else if (errorMessage.contains('path')) {
        errorMessage = 'File upload error. Please try again.';
      }
      
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
                    Text('Upload Failed', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 4),
                Text(errorMessage),
              ],
            ),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Details',
              textColor: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Error Details'),
                    content: SelectableText(e.toString()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    }
  }

  void _removeResume() async {  // Make async
    setState(() {
      _hasUploadedFile = false;
      uploadedFileName = '';
      extractedSkills.clear();
    });
    
    // Clear UserProfile skills (async - removes from storage)
    await UserProfile.clearSkills();
    
    print('🗑️  Resume and skills removed from storage');
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 8),
              Text('Resume removed successfully!'),
            ],
          ),
          backgroundColor: Colors.orange.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _viewRecommendations() {
    if (extractedSkills.isNotEmpty) {
      Navigator.pushNamed(context, '/job-recommendations');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload your resume first to get recommendations!'),
          backgroundColor: Colors.orange.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Upload Resume',
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
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
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
                        children: [
                          Icon(
                            Icons.description,
                            size: 48,
                            color: Color(0xFF2563EB),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Upload Your Resume',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Upload your PDF resume to extract skills and get personalized job recommendations',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Resume Upload Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
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
                        children: [
                          // Upload Area
                          GestureDetector(
                            onTap: (_hasUploadedFile || _isUploading) ? null : _uploadResume,
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFF2563EB).withOpacity(0.05),
                                border: Border.all(
                                  color: _hasUploadedFile
                                      ? Colors.green.shade400
                                      : Color(0xFF2563EB).withOpacity(0.3),
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: _isUploading
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(height: 16),
                                          Text('Uploading and extracting skills...'),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _hasUploadedFile ? Icons.check_circle : Icons.cloud_upload_outlined,
                                          size: 48,
                                          color: _hasUploadedFile ? Colors.green.shade400 : Color(0xFF2563EB),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          _hasUploadedFile
                                              ? 'Resume Uploaded Successfully!'
                                              : 'Click to Upload PDF Resume',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: _hasUploadedFile ? Colors.green.shade700 : Color(0xFF2563EB),
                                          ),
                                        ),
                                        if (!_hasUploadedFile) ...[
                                          SizedBox(height: 8),
                                          Text(
                                            'PDF files only • Max 10MB',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                            ),
                          ),
                          
                          if (_hasUploadedFile) ...[
                            SizedBox(height: 20),
                            
                            // Uploaded File Info
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.description, color: Color(0xFF2563EB)),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          uploadedFileName.isNotEmpty ? uploadedFileName : 'resume.pdf',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${extractedSkills.length} skills extracted',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red.shade400),
                                    onPressed: _removeResume,
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 24),
                            
                            // Extracted Skills
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2563EB).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFF2563EB).withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.auto_awesome, color: Color(0xFF2563EB), size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Extracted Skills',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2563EB),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: extractedSkills.map((skill) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2563EB),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          skill,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 24),
                            
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _viewRecommendations,
                                    icon: Icon(Icons.auto_awesome, size: 20),
                                    label: Text('Get Job Recommendations'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF2563EB),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 12),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _uploadResume,
                                    icon: Icon(Icons.refresh, size: 20),
                                    label: Text('Upload Different Resume'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Color(0xFF2563EB),
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      side: BorderSide(color: Color(0xFF2563EB)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    if (!_hasUploadedFile) ...[
                      SizedBox(height: 24),
                      
                      // Info Cards
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.blue.shade700),
                                SizedBox(width: 8),
                                Text(
                                  'How it works:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            _buildInfoItem('1. Upload your PDF resume'),
                            _buildInfoItem('2. AI extracts your skills automatically'),
                            _buildInfoItem('3. Get personalized job recommendations'),
                            _buildInfoItem('4. Discover courses to improve your skills'),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green.shade600),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}