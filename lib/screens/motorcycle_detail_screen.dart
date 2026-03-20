import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';
import '../services/app_data_service.dart';
import '../widgets/section_card.dart';
import '../widgets/review_checklist_card.dart';
import 'scanner_screen.dart';

class MotorcycleDetailScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final appDataAsync = ref.watch(appDataProvider);

    return appDataAsync.when(
      data: (appData) {
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
                  Tab(text: 'Mi Moto'),
                  Tab(text: 'Revisiones'),
                ],
                indicatorWeight: 3,
              ),
            ),
            // floatingActionButton: FloatingActionButton.extended(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute<void>(builder: (_) => const ScannerScreen()),
            //     );
            //   },
            //   icon: const Icon(Icons.bluetooth_searching),
            //   label: const Text('Escáner OBD2'),
            // ),
            body: TabBarView(
              children: [
                _SectionListView(sections: allSections),
                _ReviewListView(checklist: appData.universalChecklist),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}

class _ReviewListView extends StatelessWidget {
  const _ReviewListView({required this.checklist});

  final List<ReviewCheckpoint> checklist;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: checklist.length,
      itemBuilder: (context, index) {
        return ReviewChecklistCard(checkpoint: checklist[index]);
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
