import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';
import '../services/app_data_service.dart';
import 'motorcycle_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  CountryData? selectedCountry;
  BrandData? selectedBrand;
  MotorcycleModel? selectedModel;

  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MotoApp Colombia')),
      body: appData.when(
        data: (data) => _SelectionView(
          data: data,
          selectedCountry: selectedCountry,
          selectedBrand: selectedBrand,
          selectedModel: selectedModel,
          onCountryChanged: (country) {
            setState(() {
              selectedCountry = country;
              selectedBrand = null;
              selectedModel = null;
            });
          },
          onBrandChanged: (brand) {
            setState(() {
              selectedBrand = brand;
              selectedModel = null;
            });
          },
          onModelChanged: (model) {
            setState(() {
              selectedModel = model;
            });
          },
          onContinue: () {
            if (selectedCountry == null || selectedBrand == null || selectedModel == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selecciona país, marca y modelo para continuar.')),
              );
              return;
            }

            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => MotorcycleDetailScreen(
                  country: selectedCountry!,
                  brand: selectedBrand!,
                  model: selectedModel!,
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('No fue posible cargar los datos: $error')),
      ),
    );
  }
}

class _SelectionView extends StatelessWidget {
  const _SelectionView({
    required this.data,
    required this.selectedCountry,
    required this.selectedBrand,
    required this.selectedModel,
    required this.onCountryChanged,
    required this.onBrandChanged,
    required this.onModelChanged,
    required this.onContinue,
  });

  final AppData data;
  final CountryData? selectedCountry;
  final BrandData? selectedBrand;
  final MotorcycleModel? selectedModel;
  final ValueChanged<CountryData?> onCountryChanged;
  final ValueChanged<BrandData?> onBrandChanged;
  final ValueChanged<MotorcycleModel?> onModelChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final brands = selectedCountry?.brands ?? <BrandData>[];
    final models = selectedBrand?.models ?? <MotorcycleModel>[];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Selecciona tu moto para personalizar clima, talleres, repuestos, videos y redes sociales.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<CountryData>(
          value: selectedCountry,
          decoration: const InputDecoration(labelText: 'País', border: OutlineInputBorder()),
          items: data.countries
              .map((country) => DropdownMenuItem(value: country, child: Text(country.name)))
              .toList(),
          onChanged: onCountryChanged,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<BrandData>(
          value: selectedBrand,
          decoration: const InputDecoration(labelText: 'Marca', border: OutlineInputBorder()),
          items: brands.map((brand) => DropdownMenuItem(value: brand, child: Text(brand.name))).toList(),
          onChanged: selectedCountry == null ? null : onBrandChanged,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<MotorcycleModel>(
          value: selectedModel,
          decoration: const InputDecoration(labelText: 'Modelo', border: OutlineInputBorder()),
          items: models.map((model) => DropdownMenuItem(value: model, child: Text(model.name))).toList(),
          onChanged: selectedBrand == null ? null : onModelChanged,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onContinue,
          icon: const Icon(Icons.two_wheeler),
          label: const Text('Ver revisiones y recursos'),
        ),
      ],
    );
  }
}
