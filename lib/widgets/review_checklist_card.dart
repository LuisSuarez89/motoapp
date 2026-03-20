import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_models.dart';
import '../services/checklist_service.dart';

class ReviewChecklistCard extends ConsumerWidget {
  const ReviewChecklistCard({
    super.key,
    required this.checkpoint,
  });

  final ReviewCheckpoint checkpoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistState = ref.watch(checklistStateProvider);

    return Card(
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(Icons.build_circle_outlined, color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        title: Text(
          checkpoint.km,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        subtitle: Text(
          checkpoint.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: checkpoint.items.map((item) {
          final isChecked = checklistState[item.id] ?? false;

          return CheckboxListTile(
            value: isChecked,
            onChanged: (bool? value) {
              ref.read(checklistStateProvider.notifier).toggleItem(item.id);
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.green.shade500,
            title: Text(
              item.text,
              style: TextStyle(
                decoration: isChecked ? TextDecoration.lineThrough : null,
                color: isChecked ? Colors.grey : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
