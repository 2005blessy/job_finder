import 'package:flutter/material.dart';
import '../../data/models/job_model.dart';

class JobTile extends StatelessWidget {
  final JobModel job;
  final VoidCallback? onApplied;
  const JobTile({required this.job, this.onApplied, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.work_outline)),
      title: Text(job.title),
      subtitle: Text("${job.company} • ${job.location}\nSkills: ${job.skills.join(', ')}"),
      trailing: ElevatedButton(
        onPressed: onApplied,
        child: const Text("Apply"),
      ),
    );
  }
}
