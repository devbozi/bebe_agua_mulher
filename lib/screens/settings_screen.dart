import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/hydration_settings.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late HydrationSettings _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await StorageService.getSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await StorageService.saveSettings(_settings);
    await NotificationService.scheduleReminders(_settings);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configurações salvas com sucesso! 💕'),
          backgroundColor: AppTheme.primaryPink,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
              : Column(
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
                            'Configurações 💕',
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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // Meta diária
                            _SettingsCard(
                              title: 'Meta diária de água',
                              icon: Icons.water_drop,
                              child: Column(
                                children: [
                                  Text(
                                    '${_settings.dailyGoal}ml por dia',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppTheme.primaryPink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Slider(
                                    value: _settings.dailyGoal.toDouble(),
                                    min: 1000,
                                    max: 4000,
                                    divisions: 30,
                                    activeColor: AppTheme.primaryPink,
                                    inactiveColor: AppTheme.lightPink,
                                    onChanged: (value) {
                                      setState(() {
                                        _settings = _settings.copyWith(
                                          dailyGoal: value.round(),
                                        );
                                      });
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('1L', style: TextStyle(color: AppTheme.textLight)),
                                      Text('4L', style: TextStyle(color: AppTheme.textLight)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Intervalo de lembretes
                            _SettingsCard(
                              title: 'Intervalo entre lembretes',
                              icon: Icons.schedule,
                              child: Column(
                                children: [
                                  Text(
                                    'A cada ${_settings.reminderInterval} minutos',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppTheme.primaryPink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Slider(
                                    value: _settings.reminderInterval.toDouble(),
                                    min: 15,
                                    max: 180,
                                    divisions: 11,
                                    activeColor: AppTheme.primaryPink,
                                    inactiveColor: AppTheme.lightPink,
                                    onChanged: (value) {
                                      setState(() {
                                        _settings = _settings.copyWith(
                                          reminderInterval: value.round(),
                                        );
                                      });
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('15min', style: TextStyle(color: AppTheme.textLight)),
                                      Text('3h', style: TextStyle(color: AppTheme.textLight)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Horário de funcionamento
                            _SettingsCard(
                              title: 'Horário de lembretes',
                              icon: Icons.access_time,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text('Início'),
                                        const SizedBox(height: 8),
                                        DropdownButton<int>(
                                          value: _settings.startHour,
                                          items: List.generate(24, (index) {
                                            return DropdownMenuItem(
                                              value: index,
                                              child: Text('${index.toString().padLeft(2, '0')}:00'),
                                            );
                                          }),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                _settings = _settings.copyWith(startHour: value);
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text('Fim'),
                                        const SizedBox(height: 8),
                                        DropdownButton<int>(
                                          value: _settings.endHour,
                                          items: List.generate(24, (index) {
                                            return DropdownMenuItem(
                                              value: index,
                                              child: Text('${index.toString().padLeft(2, '0')}:00'),
                                            );
                                          }),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                _settings = _settings.copyWith(endHour: value);
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Configurações de notificação
                            _SettingsCard(
                              title: 'Notificações',
                              icon: Icons.notifications,
                              child: Column(
                                children: [
                                  SwitchListTile(
                                    title: const Text('Lembretes ativados'),
                                    subtitle: const Text('Receber notificações de hidratação'),
                                    value: _settings.notificationsEnabled,
                                    activeColor: AppTheme.primaryPink,
                                    onChanged: (value) {
                                      setState(() {
                                        _settings = _settings.copyWith(
                                          notificationsEnabled: value,
                                        );
                                      });
                                    },
                                  ),
                                  SwitchListTile(
                                    title: const Text('Som'),
                                    subtitle: const Text('Tocar som nas notificações'),
                                    value: _settings.soundEnabled,
                                    activeColor: AppTheme.primaryPink,
                                    onChanged: (value) {
                                      setState(() {
                                        _settings = _settings.copyWith(soundEnabled: value);
                                      });
                                    },
                                  ),
                                  SwitchListTile(
                                    title: const Text('Vibração'),
                                    subtitle: const Text('Vibrar nas notificações'),
                                    value: _settings.vibrationEnabled,
                                    activeColor: AppTheme.primaryPink,
                                    onChanged: (value) {
                                      setState(() {
                                        _settings = _settings.copyWith(vibrationEnabled: value);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Mensagem personalizada
                            _SettingsCard(
                              title: 'Mensagem personalizada',
                              icon: Icons.message,
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Digite uma mensagem carinhosa...',
                                  prefixIcon: Icon(Icons.favorite),
                                ),
                                maxLines: 3,
                                onChanged: (value) {
                                  setState(() {
                                    _settings = _settings.copyWith(customMessage: value);
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Botão salvar
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _saveSettings,
                                child: const Text(
                                  'Salvar configurações 💕',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.3),

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
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SettingsCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.95),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryPink,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3);
  }
}

