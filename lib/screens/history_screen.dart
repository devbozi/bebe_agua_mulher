import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/water_intake.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DailyProgress> _weeklyProgress = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeeklyProgress();
  }

  Future<void> _loadWeeklyProgress() async {
    setState(() => _isLoading = true);
    
    final List<DailyProgress> progress = [];
    final now = DateTime.now();
    
    // Carregar progresso dos últimos 7 dias
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dailyProgress = await StorageService.getDailyProgress(date);
      progress.add(dailyProgress);
    }
    
    setState(() {
      _weeklyProgress = progress;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.romanticGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppTheme.primaryPink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Seu histórico 💕',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              // Conteúdo
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryPink,
                        ),
                      )
                    : _weeklyProgress.isEmpty
                        ? _buildEmptyState()
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                // Resumo semanal
                                _buildWeeklySummary(),
                                
                                const SizedBox(height: 24),
                                
                                // Gráfico de barras
                                _buildWeeklyChart(),
                                
                                const SizedBox(height: 24),
                                
                                // Lista de dias
                                _buildDailyList(),
                                
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.water_drop_outlined,
            size: 80,
            color: AppTheme.lightBlue,
          ),
          const SizedBox(height: 24),
          Text(
            'Ainda não há histórico',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Comece a beber água para ver seu progresso aqui! 💧',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary() {
    final totalIntake = _weeklyProgress.fold(0, (sum, progress) => sum + progress.totalIntake);
    final averageIntake = totalIntake / _weeklyProgress.length;
    final goalReachedDays = _weeklyProgress.where((p) => p.isGoalReached).length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPink.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Resumo da semana',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.local_drink,
                  title: 'Total',
                  value: '${(totalIntake / 1000).toStringAsFixed(1)}L',
                  subtitle: 'bebidos',
                  color: AppTheme.primaryPink,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.trending_up,
                  title: 'Média',
                  value: '${(averageIntake / 1000).toStringAsFixed(1)}L',
                  subtitle: 'por dia',
                  color: AppTheme.lightBlue,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.emoji_events,
                  title: 'Metas',
                  value: '$goalReachedDays',
                  subtitle: 'atingidas',
                  color: AppTheme.lavender,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.calendar_today,
                  title: 'Dias',
                  value: '${_weeklyProgress.length}',
                  subtitle: 'registrados',
                  color: AppTheme.lightPink,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3);
  }

  Widget _buildWeeklyChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPink.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Progresso semanal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 24),
          
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _weeklyProgress.map((progress) {
                final height = progress.progressPercentage * 150;
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('E', 'pt_BR').format(progress.date),
                      style: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 30,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: progress.isGoalReached 
                            ? AppTheme.heartGradient
                            : LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppTheme.lightBlue,
                                  AppTheme.primaryPink,
                                ],
                              ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress.totalIntake / 1000).toStringAsFixed(1)}L',
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.3);
  }

  Widget _buildDailyList() {
    return Column(
      children: _weeklyProgress.map((progress) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPink.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Data
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd/MM', 'pt_BR').format(progress.date),
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    DateFormat('EEEE', 'pt_BR').format(progress.date),
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 20),
              
              // Progresso
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${progress.totalIntake}ml',
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(progress.progressPercentage * 100).toInt()}%',
                          style: TextStyle(
                            color: progress.isGoalReached 
                                ? AppTheme.primaryPink 
                                : AppTheme.textLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppTheme.lightGray,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.progressPercentage,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: progress.isGoalReached 
                                ? AppTheme.heartGradient
                                : LinearGradient(
                                    colors: [AppTheme.lightBlue, AppTheme.primaryPink],
                                  ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Status
              Icon(
                progress.isGoalReached ? Icons.emoji_events : Icons.water_drop,
                color: progress.isGoalReached ? AppTheme.primaryPink : AppTheme.lightBlue,
                size: 24,
              ),
            ],
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 400.ms, duration: 800.ms).slideY(begin: 0.3);
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _SummaryCard({
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
