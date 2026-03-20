import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_models.dart';
import 'scanner_screen.dart';

class MotorcycleDetailScreen extends StatelessWidget {
  const MotorcycleDetailScreen({
    super.key,
    required this.country,
    required this.brand,
    required this.model,
  });

  final CountryData country;
  final BrandData brand;
  final MotorcycleModel model;

  @override
  Widget build(BuildContext context) {
    final allSections = [
      ...country.generalSections,
      ...brand.sharedSections,
      ...model.sections,
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${brand.name} ${model.name}'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Revisiones'),
              Tab(text: 'Secciones'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ScannerScreen()),
            );
          },
          icon: const Icon(Icons.bluetooth_searching),
          label: const Text('Escáner OBD2'),
        ),
        body: TabBarView(
          children: [
            _ReviewList(model: model),
            _SectionList(sections: allSections),
          ],
        ),
      ),
    );
  }
}

class _ReviewList extends StatelessWidget {
  const _ReviewList({required this.model});

  final MotorcycleModel model;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: model.reviewChecklist.length,
      itemBuilder: (context, index) {
        final checkpoint = model.reviewChecklist[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: const Icon(Icons.build_circle_outlined),
            title: Text('${checkpoint.km} · ${checkpoint.title}'),
            children: checkpoint.items
                .map(
                  (item) => ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(item),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _SectionList extends StatelessWidget {
  const _SectionList({required this.sections});

  final List<ContentSection> sections;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            initiallyExpanded: index == 0,
            leading: Icon(_iconForSection(section.id)),
            title: Text(section.title),
            subtitle: Text(section.description),
            children: section.items
                .map(
                  (item) => ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.subtitle),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _handleItemTap(item, context),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  IconData _iconForSection(String id) {
    switch (id) {
      case 'climate':
        return Icons.cloud_outlined;
      case 'roads':
        return Icons.route_outlined;
      case 'workshops':
        return Icons.garage_outlined;
      case 'parts':
        return Icons.settings_input_component_outlined;
      case 'videos':
        return Icons.play_circle_outline;
      case 'social':
        return Icons.groups_outlined;
      default:
        return Icons.info_outline;
    }
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

    if (<String>{'link', 'map', 'whatsapp', 'social'}.contains(item.type)) {
      final uri = Uri.parse(item.value);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No fue posible abrir ${item.title}.')),
        );
      }
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(item.value)));
    }
  }
}
