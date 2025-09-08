# Job Finder API Documentation

**Base URL:** `https://your-backend-api.railway.app/api/v1`

---

## Authentication

### 1. Register a new user
- **Endpoint:** `/auth/register`
- **Method:** `POST`
- **Request Body:**
```json
{
  "full_name": "John Doe",
  "email": "student@example.com",
  "password": "securepassword123"
}
```
- **Success Response (201 Created):**
```json
{
  "token": "your_jwt_token",
  "user": {
    "id": "user_id_123",
    "full_name": "John Doe",
    "email": "student@example.com"
  }
}
```
- **Error Response (400 Bad Request):**
```json
{
  "error": "Invalid email, password, or full name"
}
```

### 2. Login a user
- **Endpoint:** `/auth/login`
- **Method:** `POST`
- **Request Body:**
```json
{
  "email": "student@example.com",
  "password": "securepassword123"
}
```
- **Success Response (200 OK):**
```json
{
  "token": "your_jwt_token",
  "user": {
    "id": "user_id_123",
    "full_name": "John Doe",
    "email": "student@example.com"
  }
}
```

---

## Profile

### 1. Get user profile
- **Endpoint:** `/profile`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer your_jwt_token`
- **Success Response (200 OK):**
```json
{
  "id": "user_id_123",
  "name": "John Doe",
  "headline": "Aspiring Software Engineer",
  "location": "New York, NY",
  "email": "student@example.com",
  "skills": ["Flutter", "Dart", "Firebase"]
}
```

### 2. Update user profile
- **Endpoint:** `/profile`
- **Method:** `PUT`
- **Headers:** `Authorization: Bearer your_jwt_token`
- **Request Body:**
```json
{
  "name": "John Doe",
  "headline": "Aspiring Software Engineer",
  "location": "New York, NY"
}
```
- **Success Response (200 OK):**
```json
{
  "message": "Profile updated successfully"
}
```

---

## Resume

### 1. Upload a resume
- **Endpoint:** `/resume/upload`
- **Method:** `POST`
- **Headers:** `Authorization: Bearer your_jwt_token`
- **Request Body:** `multipart/form-data` with a resume file field (PDF).
- **Success Response (200 OK):**
```json
{
  "message": "Resume uploaded and skills are being extracted.",
  "extracted_skills": ["Flutter", "Dart", "Firebase"]
}
```

---

## Jobs

### 1. Get all jobs
- **Endpoint:** `/jobs`
- **Method:** `GET`
- **Query Parameters:**
  - `search` (string, optional): Keyword or job title (e.g., Flutter Developer).
  - `location` (string, optional): City, state, or country.
  - `remote` (boolean, optional): true/false for remote jobs.
  - `salary_min` (number, optional): Minimum salary filter.
  - `salary_max` (number, optional): Maximum salary filter.
  - `experience_level` (string, optional): entry, mid, senior.
  - `contract_type` (string, optional): full-time, part-time, contract, internship.
  - `sort` (string, optional): relevance, date, salary.
  - `page` (number, optional): Page number for pagination.
  - `limit` (number, optional): Results per page.
- **Success Response (200 OK):**
```json
{
  "jobs": [
    {
      "id": "job_id_123",
      "title": "Flutter Developer",
      "company": "TechSolutions",
      "location": "Remote",
      "salary": "₹80000/month",
      "experience_level": "mid",
      "contract_type": "full-time",
      "remote": true
    }
  ],
  "page": 1,
  "limit": 10,
  "total_results": 100
}
```

### 2. Get recommended jobs
- **Endpoint:** `/jobs/recommended`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer your_jwt_token`
- **Success Response (200 OK):**
```json
{
  "jobs": [
    {
      "id": "job_id_123",
      "title": "Flutter Developer",
      "company": "TechSolutions",
      "location": "Remote"
    }
  ]
}
```

### 3. Get job details
- **Endpoint:** `/jobs/{id}`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer your_jwt_token`
- **Success Response (200 OK):**
```json
{
  "id": "job_id_123",
  "title": "Flutter Developer",
  "company": "TechSolutions",
  "location": "Remote",
  "description": "...",
  "required_skills": ["Flutter", "Dart", "Firebase", "REST APIs"],
  "cv_match": {
    "matching_skills": ["Flutter", "Dart", "Firebase"],
    "missing_skills": ["REST APIs"]
  }
}
```

### 4. Get courses for missing skills
- **Endpoint:** `/courses`
- **Method:** `POST`
- **Headers:** `Authorization: Bearer your_jwt_token`
- **Request Body:**
```json
{
  "skills": ["REST APIs", "GraphQL"]
}
```
- **Success Response (200 OK):**
```json
{
  "courses": [
    {
      "skill": "REST APIs",
      "course_name": "Complete Guide to RESTful APIs",
      "provider": "Udemy",
      "url": "https://udemy.com/course/...",
      "difficulty": "Beginner",
      "language": "English",
      "price": "₹499"
    }
  ]
}
```
