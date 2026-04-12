import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_models.dart';
import '../services/app_data_service.dart';
import '../widgets/section_card.dart';
import '../widgets/review_checklist_card.dart';
import '../widgets/ad_banner.dart';
// ignore: unused_import
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
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      _SectionListView(sections: allSections),
                      _ReviewListView(checklist: appData.universalChecklist),
                    ],
                  ),
                ),
                const AdBanner(),
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
      itemCount: sections.length + 1,
      itemBuilder: (context, index) {
        if (index == sections.length) {
          return const Padding(
            padding: EdgeInsets.only(top: 16),
            child: _SuggestionsCard(),
          );
        }
        return SectionCard(
          section: sections[index],
          initiallyExpanded: index == 0,
        );
      },
    );
  }
}

class _SuggestionsCard extends StatelessWidget {
  const _SuggestionsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final uri = Uri.parse('https://forms.gle/BgnRWFz3UEH8Jwxd9');
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No fue posible abrir el formulario.')),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.feedback_outlined,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sugerencias y comentarios',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Déjanos tus ideas para mejorar la aplicación',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
