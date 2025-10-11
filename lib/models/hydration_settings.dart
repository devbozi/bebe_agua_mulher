class HydrationSettings {
  final int dailyGoal; // em ml
  final int reminderInterval; // em minutos
  final int startHour; // hora de início (0-23)
  final int endHour; // hora de fim (0-23)
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String customMessage;
  final int glassSize; // tamanho do copo em ml

  const HydrationSettings({
    this.dailyGoal = 2000,
    this.reminderInterval = 60,
    this.startHour = 8,
    this.endHour = 22,
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.customMessage = '',
    this.glassSize = 250,
  });

  HydrationSettings copyWith({
    int? dailyGoal,
    int? reminderInterval,
    int? startHour,
    int? endHour,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? customMessage,
    int? glassSize,
  }) {
    return HydrationSettings(
      dailyGoal: dailyGoal ?? this.dailyGoal,
      reminderInterval: reminderInterval ?? this.reminderInterval,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      customMessage: customMessage ?? this.customMessage,
      glassSize: glassSize ?? this.glassSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyGoal': dailyGoal,
      'reminderInterval': reminderInterval,
      'startHour': startHour,
      'endHour': endHour,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'customMessage': customMessage,
      'glassSize': glassSize,
    };
  }

  factory HydrationSettings.fromJson(Map<String, dynamic> json) {
    return HydrationSettings(
      dailyGoal: json['dailyGoal'] ?? 2000,
      reminderInterval: json['reminderInterval'] ?? 60,
      startHour: json['startHour'] ?? 8,
      endHour: json['endHour'] ?? 22,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      customMessage: json['customMessage'] ?? '',
      glassSize: json['glassSize'] ?? 250,
    );
  }
}

