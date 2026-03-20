import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../widgets/section_card.dart';
import '../widgets/review_checklist_card.dart';
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
            indicatorWeight: 3,
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
            _ReviewListView(model: model),
            _SectionListView(sections: allSections),
          ],
        ),
      ),
    );
  }
}

class _ReviewListView extends StatelessWidget {
  const _ReviewListView({required this.model});

  final MotorcycleModel model;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: model.reviewChecklist.length,
      itemBuilder: (context, index) {
        return ReviewChecklistCard(checkpoint: model.reviewChecklist[index]);
      },
    );
  }
}

class _SectionListView extends StatelessWidget {
  const _SectionListView({required this.sections});

  final List<ContentSection> sections;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        return SectionCard(
          section: sections[index],
          initiallyExpanded: index == 0,
        );
      },
    );
  }
}
