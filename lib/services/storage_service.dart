import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hydration_settings.dart';
import '../models/water_intake.dart';

class StorageService {
  static const String _settingsKey = 'hydration_settings';
  static const String _intakesKey = 'water_intakes';
  static const String _isFirstTimeKey = 'is_first_time';

  static Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  // Configurações
  static Future<HydrationSettings> getSettings() async {
    final prefs = await _prefs;
    final settingsJson = prefs.getString(_settingsKey);
    
    if (settingsJson != null) {
      final settingsMap = json.decode(settingsJson);
      return HydrationSettings.fromJson(settingsMap);
    }
    
    return const HydrationSettings();
  }

  static Future<void> saveSettings(HydrationSettings settings) async {
    final prefs = await _prefs;
    final settingsJson = json.encode(settings.toJson());
    await prefs.setString(_settingsKey, settingsJson);
  }

  // Consumo de água
  static Future<List<WaterIntake>> getWaterIntakes() async {
    final prefs = await _prefs;
    final intakesJson = prefs.getString(_intakesKey);
    
    if (intakesJson != null) {
      final List<dynamic> intakesList = json.decode(intakesJson);
      return intakesList
          .map((json) => WaterIntake.fromJson(json))
          .toList();
    }
    
    return [];
  }

  static Future<void> saveWaterIntake(WaterIntake intake) async {
    final intakes = await getWaterIntakes();
    intakes.add(intake);
    await _saveWaterIntakes(intakes);
  }

  static Future<void> _saveWaterIntakes(List<WaterIntake> intakes) async {
    final prefs = await _prefs;
    final intakesJson = json.encode(
      intakes.map((intake) => intake.toJson()).toList(),
    );
    await prefs.setString(_intakesKey, intakesJson);
  }

  // Progresso diário
  static Future<DailyProgress> getDailyProgress(DateTime date) async {
    final intakes = await getWaterIntakes();
    final settings = await getSettings();
    
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final dayIntakes = intakes.where((intake) {
      return intake.dateTime.isAfter(startOfDay) && 
             intake.dateTime.isBefore(endOfDay);
    }).toList();
    
    final totalIntake = dayIntakes.fold(0, (sum, intake) => sum + intake.amount);
    
    return DailyProgress(
      date: date,
      totalIntake: totalIntake,
      goal: settings.dailyGoal,
      intakes: dayIntakes,
    );
  }

  // Primeira vez
  static Future<bool> isFirstTime() async {
    final prefs = await _prefs;
    return prefs.getBool(_isFirstTimeKey) ?? true;
  }

  static Future<void> setFirstTimeCompleted() async {
    final prefs = await _prefs;
    await prefs.setBool(_isFirstTimeKey, false);
  }

  // Limpar dados
  static Future<void> clearAllData() async {
    final prefs = await _prefs;
    await prefs.remove(_settingsKey);
    await prefs.remove(_intakesKey);
    await prefs.remove(_isFirstTimeKey);
  }
}

