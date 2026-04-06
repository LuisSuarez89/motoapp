import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_models.dart';
import '../services/app_data_service.dart';
import '../widgets/modern_dropdown.dart';
import '../widgets/ad_banner.dart';
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

  String? _savedCountry;
  String? _savedBrand;
  String? _savedModel;
  bool _isInit = false;
  bool _prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedCountry = prefs.getString('selected_country');
      _savedBrand = prefs.getString('selected_brand');
      _savedModel = prefs.getString('selected_model');
      _prefsLoaded = true;
    });
  }

  Future<void> _savePreference(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      prefs.remove(key);
    } else {
      prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(appDataProvider);

    appData.whenData((data) {
      if (!_isInit && _prefsLoaded) {
        _isInit = true;
        if (_savedCountry != null) {
          final countryList = data.countries.where((c) => c.name == _savedCountry).toList();
          if (countryList.isNotEmpty) {
            selectedCountry = countryList.first;
            final brandList = selectedCountry!.brands.where((b) => b.name == _savedBrand).toList();
            if (brandList.isNotEmpty) {
              selectedBrand = brandList.first;
              final modelList = selectedBrand!.models.where((m) => m.name == _savedModel).toList();
              if (modelList.isNotEmpty) {
                selectedModel = modelList.first;
              }
            }
          }
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('MotoApp Colombia')),
      body: Column(
        children: [
          Expanded(
            child: appData.when(
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
                  _savePreference('selected_country', country?.name);
                  _savePreference('selected_brand', null);
                  _savePreference('selected_model', null);
                },
                onBrandChanged: (brand) {
                  setState(() {
                    selectedBrand = brand;
                    selectedModel = null;
                  });
                  _savePreference('selected_brand', brand?.name);
                  _savePreference('selected_model', null);
                },
                onModelChanged: (model) {
                  setState(() {
                    selectedModel = model;
                  });
                  _savePreference('selected_model', model?.name);
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
          ),
          const AdBanner(),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Bienvenido!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecciona tu moto para personalizar clima, talleres, repuestos, videos y redes sociales.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        ModernDropdown<CountryData>(
          label: 'País',
          value: selectedCountry,
          items: data.countries,
          itemLabelBuilder: (country) => country.name,
          onChanged: onCountryChanged,
        ),
        const SizedBox(height: 20),
        ModernDropdown<BrandData>(
          label: 'Marca',
          value: selectedBrand,
          items: brands,
          itemLabelBuilder: (brand) => brand.name,
          onChanged: selectedCountry == null ? null : onBrandChanged,
        ),
        const SizedBox(height: 20),
        ModernDropdown<MotorcycleModel>(
          label: 'Modelo',
          value: selectedModel,
          items: models,
          itemLabelBuilder: (model) => model.name,
          onChanged: selectedBrand == null ? null : onModelChanged,
        ),
        const SizedBox(height: 48),
        FilledButton.icon(
          onPressed: onContinue,
          icon: const Icon(Icons.two_wheeler),
          label: const Text('Ver revisiones y recursos'),
        ),
      ],
    );
  }
}
