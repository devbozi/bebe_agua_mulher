import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/water_intake.dart';
import '../services/storage_service.dart';
import '../widgets/water_progress_widget.dart';
import '../widgets/water_intake_button.dart';
import '../widgets/daily_stats_widget.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DailyProgress? _dailyProgress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDailyProgress();
  }

  Future<void> _loadDailyProgress() async {
    setState(() => _isLoading = true);
    
    final progress = await StorageService.getDailyProgress(DateTime.now());
    
    setState(() {
      _dailyProgress = progress;
      _isLoading = false;
    });
  }

  Future<void> _addWaterIntake(int amount) async {
    final intake = WaterIntake(
      dateTime: DateTime.now(),
      amount: amount,
    );

    await StorageService.saveWaterIntake(intake);
    await _loadDailyProgress();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.romanticGradient,
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryPink,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // App Bar personalizada
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, meu amor! 💕',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.textDark,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                DateFormat('EEEE, dd/MM/yyyy', 'pt_BR').format(DateTime.now()),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.settings,
                              color: AppTheme.primaryPink,
                              size: 28,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Widget de progresso da água
                      if (_dailyProgress != null)
                        WaterProgressWidget(
                          progress: _dailyProgress!,
                          onGoalReached: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Parabéns! Você atingiu sua meta diária! 🎉'),
                                backgroundColor: AppTheme.primaryPink,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            );
                          },
                        ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.3),

                      const SizedBox(height: 32),

                      // Frase motivacional
                      Container(
                        width: double.infinity,
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
                        child: Text(
                          AppTheme.romanticPhrases[DateTime.now().day % AppTheme.romanticPhrases.length],
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textDark,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 800.ms).slideY(begin: 0.3),

                      const SizedBox(height: 32),

                      // Botões de adicionar água
                      Row(
                        children: [
                          Expanded(
                            child: WaterIntakeButton(
                              amount: 250,
                              label: 'Copo pequeno',
                              icon: Icons.local_drink,
                              onPressed: () => _addWaterIntake(250),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: WaterIntakeButton(
                              amount: 500,
                              label: 'Copo grande',
                              icon: Icons.local_drink,
                              onPressed: () => _addWaterIntake(500),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 600.ms, duration: 800.ms).slideY(begin: 0.3),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: WaterIntakeButton(
                              amount: 1000,
                              label: 'Garrafa',
                              icon: Icons.water_drop,
                              onPressed: () => _addWaterIntake(1000),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: WaterIntakeButton(
                              amount: 0,
                              label: 'Personalizado',
                              icon: Icons.edit,
                              onPressed: _showCustomAmountDialog,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 800.ms, duration: 800.ms).slideY(begin: 0.3),

                      const SizedBox(height: 32),

                      // Estatísticas do dia
                      if (_dailyProgress != null)
                        DailyStatsWidget(
                          progress: _dailyProgress!,
                          onViewHistory: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HistoryScreen(),
                              ),
                            );
                          },
                        ).animate().fadeIn(delay: 1000.ms, duration: 800.ms).slideY(begin: 0.3),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _showCustomAmountDialog() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Quantidade personalizada 💧'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade (ml)',
                hintText: 'Ex: 300',
                prefixIcon: Icon(Icons.water_drop),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(controller.text);
              if (amount != null && amount > 0) {
                _addWaterIntake(amount);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
