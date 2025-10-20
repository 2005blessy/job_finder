# 🎯 Job Finder - Flutter Frontend

<div align="center">
  
  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  
  **A beautiful cross-platform job search application built with Flutter**
  
  [Features](#-features) • [Screenshots](#-screenshots) • [Tech Stack](#-tech-stack) • [Getting Started](#-getting-started)
  
</div>

---

## 📋 Overview

**Job Finder** is a modern, cross-platform mobile and web application for intelligent job searching and career management. Upload your resume, discover personalized job recommendations, track applications, and find courses to upskill - all with a beautiful, responsive UI.

### ✨ Key Highlights
- 🎨 **Beautiful UI/UX** - Modern design with smooth animations
- 📱 **Fully Responsive** - Works seamlessly on mobile, tablet, and desktop
- 🤖 **AI-Powered** - Smart resume analysis and job matching
- 🌐 **Cross-Platform** - Android, iOS, Web, Windows, macOS, Linux
- ⚡ **Real-time Search** - Instant job and course discovery
- 📊 **Application Tracking** - Manage your job applications effortlessly

---

## ✨ Features

### 🎨 Landing Page
- **Professional animated hero section** with fade and slide transitions
- **Fully responsive design** with three breakpoints:
  - 📱 Small (< 600px) - Mobile phones
  - 📲 Medium (600-1100px) - Tablets
  - 💻 Large (≥ 1100px) - Desktop
- **Gradient backgrounds** and modern UI elements
- **Hamburger menu** for mobile navigation
- **Call-to-action buttons** for Login/Sign Up

### 🔐 Authentication
- **User Registration** - Create account with email and password
- **Secure Login** - JWT-based authentication
- **Persistent Sessions** - Stay logged in with token storage
- **Form Validation** - Real-time input validation

### 📄 Resume Upload & Analysis
- **Multi-format Support** - Upload PDF or DOCX resumes
- **Cross-platform File Picker** - Works on mobile, web, and desktop
- **AI Skill Extraction** - Automatically extract skills from resume
- **Top Skills Display** - View your strongest skills
- **Progress Indicators** - Visual upload feedback

### 💼 Job Discovery

#### Job Search
- 🔍 **Advanced Search** - Search by job title, keywords, or company
- 📍 **Location Filtering** - Find jobs by city or remote options
- ⚡ **Popular Searches** - Quick access to trending job categories
- 🏢 **Company Listings** - Browse all jobs from specific companies
- 📊 **Rich Job Cards** - Company logos, location, salary, employment type

#### Personalized Recommendations
- 🎯 **Skill-Based Matching** - Jobs tailored to your resume skills
- 📊 **Skill Gap Analysis** - See which skills you have vs. need
- 🔄 **Refresh Recommendations** - Get new suggestions anytime
- 🎨 **Visual Skill Badges** - Color-coded skill indicators
  - 🟢 Green - Skills you have
  - 🔴 Red - Skills you need to learn

### 📱 Application Tracking
- ✅ **Mark as Applied** - Track jobs you've applied to
- 📝 **Add Notes** - Remember details about each application
- 🔄 **Status Management** - Update application status:
  - Applied
  - Interview Scheduled
  - Offer Received
  - Rejected
  - Withdrawn
- 📊 **Application Dashboard** - View all applications at a glance
- 🗑️ **Edit/Delete** - Manage your tracked applications
- 📅 **Date Tracking** - See when you applied

### 📚 Course Discovery
- 🔍 **Course Search** - Search across 8 major learning platforms:
  - Udemy
  - Coursera
  - LinkedIn Learning
  - Pluralsight
  - Udacity
  - edX
  - Khan Academy
  - Skillshare
- 🎯 **Skill-Based Recommendations** - Courses for missing job skills
- 🏷️ **Provider Filtering** - Filter by your preferred platform
- ⭐ **Popular Courses** - Trending courses in tech categories
- 🔗 **Direct Links** - One-click access to course pages

### 🎨 UI/UX Features
- 🌈 **Gradient Designs** - Beautiful gradient buttons and cards
- 🎭 **Smooth Animations** - Fade, slide, and scale transitions
- 📱 **Bottom Navigation** - Easy access to all sections:
  - 🏠 Home
  - 💼 Jobs
  - 🎯 Recommendations
  - ✅ Applied
  - 📚 Courses
- 🌙 **Clean Interface** - Intuitive and clutter-free design
- 🎨 **Color Coding** - Visual indicators for better UX
- 🖼️ **Image Handling** - Graceful fallbacks for missing images
- ⚡ **Loading States** - Skeleton screens and spinners
- ❌ **Error Handling** - User-friendly error messages

---

## 🛠️ Tech Stack

### Core Technologies
- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **Architecture:** Feature-based modular structure
- **State Management:** StatefulWidget with setState

### Key Packages
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0                      # Backend API communication
  file_picker: ^8.0.0+1            # File selection (PDF/DOCX)
  url_launcher: ^6.2.2             # Open external links
  shared_preferences: ^2.2.2       # Local data persistence
  cupertino_icons: ^1.0.2          # iOS-style icons
```

### Supported Platforms
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Windows** (Windows 10+)
- ✅ **macOS** (10.14+)
- ✅ **Linux**

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- Backend API running

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/2005blessy/job_finder.git
   cd job_finder/Job_Finder_Frontend
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint:**
   
   Edit `lib/src/core/services/api_service.dart`:
   ```dart
   // For local development
   static const String baseUrl = 'http://localhost:3000';
   
   // For mobile device testing (replace with your computer's IP)
   // static const String baseUrl = 'http://192.168.1.x:3000';
   ```

4. **Run the app:**
   
   **For Web:**
   ```bash
   flutter run -d chrome
   ```
   
   **For Android:**
   ```bash
   flutter run -d android
   ```
   
   **For iOS:**
   ```bash
   flutter run -d ios
   ```
   
   **For Windows:**
   ```bash
   flutter run -d windows
   ```

---

## 📁 Project Structure

```
Job_Finder_Frontend/
├── lib/
│   ├── main.dart                    # App entry point
│   └── src/
│       ├── core/
│       │   └── services/
│       │       └── api_service.dart # Backend API client (Singleton)
│       └── features/
│           ├── landing/
│           │   └── presentation/
│           │       └── pages/
│           │           └── landing_page.dart     # Landing page
│           ├── auth/
│           │   └── presentation/
│           │       └── pages/
│           │           ├── login_page.dart       # Login screen
│           │           └── registration_page.dart # Sign up screen
│           ├── home/
│           │   └── presentation/
│           │       └── pages/
│           │           └── home_page.dart        # Dashboard
│           ├── jobs/
│           │   └── presentation/
│           │       └── pages/
│           │           └── jobs_page.dart        # Job search
│           ├── recommendations/
│           │   └── presentation/
│           │       └── pages/
│           │           └── job_recommendations_page.dart
│           ├── applied_jobs/
│           │   └── presentation/
│           │       └── pages/
│           │           └── applied_jobs_page.dart
│           ├── courses/
│           │   └── presentation/
│           │       └── pages/
│           │           └── courses_page.dart
│           └── profile/
│               └── presentation/
│                   └── pages/
│                       └── profile_page.dart     # User profile
├── assets/
│   ├── images/
│   │   └── dreamjob.jpg            # Landing page background
│   ├── icons/
│   │   └── app_icon.png           # App icon
│   └── fonts/
│       ├── Roboto-Regular.ttf
│       └── Roboto-Bold.ttf
├── android/                        # Android-specific files
├── ios/                           # iOS-specific files
├── web/                           # Web-specific files
├── windows/                       # Windows-specific files
├── pubspec.yaml                   # Dependencies & assets
└── README.md                      # This file
```

---

## 🎯 Key Components

### ApiService (Singleton)
Centralized service for all backend API calls with JWT authentication:

```dart
class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  
  // Authentication
  Future<Map<String, dynamic>> login({...});
  Future<Map<String, dynamic>> register({...});
  
  // Resume Processing
  Future<List<String>> uploadResume(File resumeFile);
  Future<List<String>> uploadResumeBytes(Uint8List fileBytes, String fileName);
  
  // Job Search & Recommendations
  Future<List<dynamic>> searchJobs(String query, {String? location});
  Future<dynamic> getJobRecommendations({String? location});
  Future<Map<String, dynamic>> getJobDetails(String jobId);
  Future<List<dynamic>> getJobsByCompany(String company);
  Future<List<dynamic>> getPopularJobSearches();
  
  // Application Tracking
  Future<void> markJobAsApplied({...});
  Future<List<dynamic>> getAppliedJobs();
  Future<void> updateApplicationStatus(String jobId, String status, {String? notes});
  Future<void> deleteApplication(String jobId);
  
  // Course Discovery
  Future<List<dynamic>> searchCourses(String query, {String? provider});
  Future<Map<String, dynamic>> getCourseRecommendations(String jobId);
  Future<List<dynamic>> getPopularCourses();
}
```

### Responsive Design Strategy
Three breakpoints ensure optimal display across all devices:

```dart
final screenWidth = MediaQuery.of(context).size.width;
final isSmall = screenWidth < 600;      // Mobile phones
final isMedium = screenWidth < 1100;    // Tablets
final isLarge = screenWidth >= 1100;    // Desktop/laptop

// Adaptive layouts
Widget build(BuildContext context) {
  return isSmall 
    ? MobileLayout() 
    : isMedium 
      ? TabletLayout() 
      : DesktopLayout();
}
```

---

## 🎨 Design Principles

### Color Scheme
- **Primary:** Blue gradient (#2563EB to #3B82F6)
- **Success:** Green (#10B981)
- **Warning:** Amber (#F59E0B)
- **Error:** Red (#EF4444)
- **Background:** White (#FFFFFF) / Light Gray (#F3F4F6)
- **Text:** Dark Gray (#1F2937)

### Typography
- **Headings:** Roboto Bold (24-32px)
- **Body:** Roboto Regular (14-16px)
- **Captions:** Roboto Regular (12px)

### Animation Timings
- **Fast:** 200ms (buttons, toggles)
- **Normal:** 300ms (page transitions)
- **Slow:** 500ms (complex animations)

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Author

**Blessy** - [@2005blessy](https://github.com/2005blessy)

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - The amazing UI framework
- [Material Design](https://material.io/) - Design guidelines
- [file_picker](https://pub.dev/packages/file_picker) - File selection across platforms
- [http](https://pub.dev/packages/http) - HTTP client for API communication

---

<div align="center">
  
  **⭐ Star this repo if you find it helpful!**
  
  Made with ❤️ using Flutter
  
</div>
