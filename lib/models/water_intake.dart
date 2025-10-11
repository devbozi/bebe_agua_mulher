import 'package:intl/intl.dart';

class WaterIntake {
  final DateTime dateTime;
  final int amount; // em ml
  final String note;

  const WaterIntake({
    required this.dateTime,
    required this.amount,
    this.note = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'amount': amount,
      'note': note,
    };
  }

  factory WaterIntake.fromJson(Map<String, dynamic> json) {
    return WaterIntake(
      dateTime: DateTime.parse(json['dateTime']),
      amount: json['amount'],
      note: json['note'] ?? '',
    );
  }

  String get formattedTime {
    return DateFormat('HH:mm').format(dateTime);
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}

class DailyProgress {
  final DateTime date;
  final int totalIntake;
  final int goal;
  final List<WaterIntake> intakes;

  const DailyProgress({
    required this.date,
    required this.totalIntake,
    required this.goal,
    required this.intakes,
  });

  double get progressPercentage {
    if (goal == 0) return 0.0;
    return (totalIntake / goal).clamp(0.0, 1.0);
  }

  bool get isGoalReached {
    return totalIntake >= goal;
  }

  int get remainingAmount {
    return (goal - totalIntake).clamp(0, goal);
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String get dayOfWeek {
    return DateFormat('EEEE', 'pt_BR').format(date);
  }
}

