import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/water_intake.dart';

class DailyStatsWidget extends StatelessWidget {
  final DailyProgress progress;
  final VoidCallback onViewHistory;

  const DailyStatsWidget({
    super.key,
    required this.progress,
    required this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPink.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estatísticas do dia',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: onViewHistory,
                child: const Text(
                  'Ver histórico',
                  style: TextStyle(
                    color: AppTheme.primaryPink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.local_drink,
                  title: 'Copos',
                  value: '${(progress.totalIntake / 250).ceil()}',
                  subtitle: 'de água',
                  color: AppTheme.lightBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.timer,
                  title: 'Última',
                  value: progress.intakes.isNotEmpty 
                      ? progress.intakes.last.formattedTime
                      : '--:--',
                  subtitle: 'hidratação',
                  color: AppTheme.lavender,
                ),
              ),
            ],
          ),

          if (progress.remainingAmount > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.softPink,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppTheme.lightPink,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.water_drop,
                    color: AppTheme.primaryPink,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Faltam ${progress.remainingAmount}ml',
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'para atingir sua meta! 💪',
                          style: TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
