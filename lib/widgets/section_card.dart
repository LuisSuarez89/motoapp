import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/webview_screen.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.section,
    this.initiallyExpanded = false,
  });

  final ContentSection section;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(_iconForSection(section.id), color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          section.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(section.description),
        children: section.items.map((item) => _SectionItemTile(item: item)).toList(),
      ),
    );
  }

  IconData _iconForSection(String id) {
    switch (id) {
      case 'climate':
        return Icons.cloud_outlined;
      case 'roads':
        return Icons.route_outlined;
      case 'workshops':
      case 'tow':
        return Icons.garage_outlined;
      case 'parts':
        return Icons.settings_input_component_outlined;
      case 'videos':
        return Icons.play_circle_outline;
      case 'social':
        return Icons.groups_outlined;
      case 'paperwork':
        return Icons.description_outlined;
      case 'emergencies':
        return Icons.emergency_outlined;
      case 'community':
        return Icons.explore_outlined;
      default:
        return Icons.info_outline;
    }
  }
}

class _SectionItemTile extends StatelessWidget {
  const _SectionItemTile({required this.item});

  final SectionItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(item.subtitle),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      onTap: () => _handleItemTap(item, context),
    );
  }

  Future<void> _handleItemTap(SectionItem item, BuildContext context) async {
    if (item.type == 'phone') {
      final uri = Uri(scheme: 'tel', path: item.value);
      if (!await launchUrl(uri) && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No fue posible llamar a ${item.value}.')),
        );
      }
      return;
    }

    if (item.type == 'map') {
      final uri = Uri.parse(item.value);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No fue posible abrir ${item.title}.')),
        );
      }
      return;
    }

    if (<String>{'link', 'whatsapp', 'social'}.contains(item.type)) {
      if (item.value.contains('x.com') || item.value.contains('twitter.com')) {
        final uri = Uri.parse(item.value);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No fue posible abrir ${item.title}.')),
          );
        }
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebviewScreen(
            url: item.value,
            title: item.title,
          ),
        ),
      );
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(item.value)));
    }
  }
}
