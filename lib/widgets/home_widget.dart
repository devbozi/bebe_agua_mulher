import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/water_intake.dart';
import '../services/storage_service.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  DailyProgress? _todayProgress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayProgress();
  }

  Future<void> _loadTodayProgress() async {
    setState(() => _isLoading = true);
    
    final progress = await StorageService.getDailyProgress(DateTime.now());
    
    setState(() {
      _todayProgress = progress;
      _isLoading = false;
    });
  }

  Future<void> _addQuickIntake(int amount) async {
    final intake = WaterIntake(
      dateTime: DateTime.now(),
      amount: amount,
    );

    await StorageService.saveWaterIntake(intake);
    await _loadTodayProgress();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _todayProgress == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: AppTheme.romanticGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppTheme.white,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.romanticGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPink.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Row(
              children: [
                const Icon(
                  Icons.water_drop,
                  color: AppTheme.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Hidratação do dia 💕',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progresso
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_todayProgress!.totalIntake}ml',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'de ${_todayProgress!.goal}ml',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Barra de progresso circular
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        value: _todayProgress!.progressPercentage,
                        strokeWidth: 6,
                        backgroundColor: AppTheme.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.white),
                      ),
                      Center(
                        child: Text(
                          '${(_todayProgress!.progressPercentage * 100).toInt()}%',
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Barra de progresso linear
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _todayProgress!.progressPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Botões rápidos
            Row(
              children: [
                Expanded(
                  child: _QuickButton(
                    amount: 250,
                    label: 'Copo',
                    onPressed: () => _addQuickIntake(250),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _QuickButton(
                    amount: 500,
                    label: 'Grande',
                    onPressed: () => _addQuickIntake(500),
                  ),
                ),
              ],
            ),

            if (_todayProgress!.isGoalReached) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: AppTheme.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Meta atingida! 🎉',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3);
  }
}

class _QuickButton extends StatelessWidget {
  final int amount;
  final String label;
  final VoidCallback onPressed;

  const _QuickButton({
    required this.amount,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              '${amount}ml',
              style: const TextStyle(
                color: AppTheme.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.white.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

