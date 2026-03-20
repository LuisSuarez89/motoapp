import 'package:flutter/material.dart';
import '../models/app_models.dart';

class ReviewChecklistCard extends StatelessWidget {
  const ReviewChecklistCard({
    super.key,
    required this.checkpoint,
  });

  final ReviewCheckpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(Icons.build_circle_outlined, color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        title: Text(
          '${checkpoint.km} km',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        subtitle: Text(
          checkpoint.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: checkpoint.items.map((item) {
          return ListTile(
            leading: Icon(
              Icons.check_circle,
              color: Colors.green.shade400,
            ),
            title: Text(item),
          );
        }).toList(),
      ),
    );
  }
}
