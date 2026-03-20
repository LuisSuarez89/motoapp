import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';

final appDataProvider = FutureProvider<AppData>((ref) async {
  final raw = await rootBundle.loadString('assets/data/app_data.json');
  return AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
});
