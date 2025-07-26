// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Job Finder app",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Finder"),
        backgroundColor: const Color.fromARGB(255, 8, 224, 231),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.work,
                size: 100,
                color: Color.fromARGB(255, 139, 75, 1),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome to Job Finder App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Discover your dream job easily. Search, filter, and connect with top recruiters—all in one app!',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dashboardpage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dashboardpage extends StatelessWidget {
  const Dashboardpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for jobs',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),

          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: ()async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'doc', 'docx'],
              );

              if(result!=null){
                String fileName = result.files.single.name;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected file: $fileName')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No file selected')),
                );
              }
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Resume'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Expanded(child: ListView(
            padding: const EdgeInsets.all(10),
            children:const [
              Jobcard(jobTitle: 'flutter developer', companyName: 'techsolutions', location: 'remote'),
              Jobcard(jobTitle: 'backend developer', companyName: 'webworks', location: 'new york'),
              Jobcard(jobTitle: 'data analyst', companyName: 'datacorp', location:' san francisco'),
            ],
          ))
        ],
      ),
    );
  }
}

class Jobcard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  const Jobcard({super.key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.work_outline),
        title: Text(jobTitle),
        subtitle: Text( '$companyName\n$location'),
        trailing: ElevatedButton(onPressed: (){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Applied for $jobTitle at $companyName')),
          );
        }, child: const Text('Apply')),
      ),
    );
  }
}
