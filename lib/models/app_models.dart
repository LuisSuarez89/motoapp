class AppData {
  AppData({
    required this.countries,
    required this.universalChecklist,
  });

  final List<CountryData> countries;
  final List<ReviewCheckpoint> universalChecklist;

  // factory no es necesaria para la carga modular nueva, pero se mantiene la estructura
}

class CountryData {
  CountryData({
    required this.code,
    required this.name,
    required this.generalSections,
    required this.brands,
  });

  final String code;
  final String name;
  final List<ContentSection> generalSections;
  final List<BrandData> brands;

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      code: json['code'] as String,
      name: json['name'] as String,
      generalSections: (json['generalSections'] as List<dynamic>? ?? [])
          .map((section) => ContentSection.fromJson(section as Map<String, dynamic>))
          .toList(),
      brands: (json['brands'] as List<dynamic>? ?? [])
          .map((brand) => BrandData.fromJson(brand as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BrandData {
  BrandData({required this.name, required this.models, required this.sharedSections});

  final String name;
  final List<MotorcycleModel> models;
  final List<ContentSection> sharedSections;

  factory BrandData.fromJson(Map<String, dynamic> json) {
    return BrandData(
      name: json['name'] as String,
      models: (json['models'] as List<dynamic>)
          .map((model) => MotorcycleModel.fromJson(model as Map<String, dynamic>))
          .toList(),
      sharedSections: (json['sharedSections'] as List<dynamic>? ?? const [])
          .map((section) => ContentSection.fromJson(section as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MotorcycleModel {
  MotorcycleModel({
    required this.name,
    required this.category,
    required this.sections,
  });

  final String name;
  final String category;
  final List<ContentSection> sections;

  factory MotorcycleModel.fromJson(Map<String, dynamic> json) {
    return MotorcycleModel(
      name: json['name'] as String,
      category: json['category'] as String? ?? 'General',
      sections: (json['sections'] as List<dynamic>? ?? const [])
          .map((section) => ContentSection.fromJson(section as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ReviewCheckpoint {
  ReviewCheckpoint({
    required this.km,
    required this.title,
    required this.items,
  });

  final String km;
  final String title;
  final List<ChecklistItem> items;

  factory ReviewCheckpoint.fromJson(Map<String, dynamic> json) {
    return ReviewCheckpoint(
      km: json['km'] as String,
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChecklistItem {
  ChecklistItem({
    required this.id,
    required this.text,
  });

  final String id;
  final String text;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }
}

class ContentSection {
  ContentSection({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
  });

  final String id;
  final String title;
  final String description;
  final List<SectionItem> items;

  factory ContentSection.fromJson(Map<String, dynamic> json) {
    return ContentSection(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      items: (json['items'] as List<dynamic>)
          .map((item) => SectionItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SectionItem {
  SectionItem({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.value,
    required this.tags,
  });

  final String title;
  final String subtitle;
  final String type;
  final String value;
  final List<String> tags;

  factory SectionItem.fromJson(Map<String, dynamic> json) {
    return SectionItem(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      type: json['type'] as String,
      value: json['value'] as String,
      tags: (json['tags'] as List<dynamic>? ?? const []).map((tag) => tag as String).toList(),
    );
  }
}
