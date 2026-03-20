import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';

final appDataProvider = FutureProvider<AppData>((ref) async {
  // Load global universal checklist
  final checklistRaw = await rootBundle.loadString('assets/data/sections/universal_checklist.json');
  final checklistJson = jsonDecode(checklistRaw) as List<dynamic>;
  final universalChecklist = checklistJson.map((s) => ReviewCheckpoint.fromJson(s as Map<String, dynamic>)).toList();

  final countriesRaw = await rootBundle.loadString('assets/data/countries.json');
  final countriesJson = jsonDecode(countriesRaw) as List<dynamic>;

  List<CountryData> loadedCountries = [];

  for (final countryBlock in countriesJson) {
    final code = countryBlock['code'] as String;
    final name = countryBlock['name'] as String;

    // Load sections
    final sectionsRaw = await rootBundle.loadString('assets/data/sections/${code.toLowerCase()}_sections.json');
    final sectionsJson = jsonDecode(sectionsRaw) as List<dynamic>;
    final generalSections = sectionsJson.map((s) => ContentSection.fromJson(s as Map<String, dynamic>)).toList();

    // Load brands list
    final brandsRaw = await rootBundle.loadString('assets/data/brands/${code.toLowerCase()}_brands.json');
    final brandsList = jsonDecode(brandsRaw) as List<dynamic>;

    List<BrandData> loadedBrands = [];
    for (final brandBlock in brandsList) {
      final brandName = (brandBlock['name'] as String).toLowerCase();
      final brandDataRaw = await rootBundle.loadString('assets/data/brands/$brandName.json');
      final brandDataJson = jsonDecode(brandDataRaw) as Map<String, dynamic>;
      loadedBrands.add(BrandData.fromJson(brandDataJson));
    }

    loadedCountries.add(CountryData(
      code: code,
      name: name,
      generalSections: generalSections,
      brands: loadedBrands,
    ));
  }

  return AppData(
    countries: loadedCountries,
    universalChecklist: universalChecklist,
  );
});
