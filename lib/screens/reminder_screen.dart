import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _waterController;
  late AnimationController _pulseController;
  late Animation<double> _heartAnimation;
  late Animation<double> _waterAnimation;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _waterController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _heartAnimation = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );

    _waterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waterController, curve: Curves.easeInOut),
    );

    _startAnimations();
    _playNotificationSound();
  }

  void _startAnimations() {
    _heartController.repeat(reverse: true);
    _waterController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _playNotificationSound() {
    // Vibração suave usando HapticFeedback
    HapticFeedback.mediumImpact();

    // Repetir vibração a cada 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        HapticFeedback.lightImpact();
        _playNotificationSound();
      }
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    _waterController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.romanticGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),

                // Animação de coração pulsante
                AnimatedBuilder(
                  animation: _heartAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _heartAnimation.value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryPink.withAlpha(3),
                              AppTheme.primaryPink.withAlpha(1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 120,
                          color: AppTheme.primaryPink,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Título principal
                Text(
                  'Hora de se hidratar! 💧',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 500.ms, duration: 800.ms),

                const SizedBox(height: 20),

                // Mensagem romântica
                Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withAlpha(9),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPink.withAlpha(3),
                            blurRadius: 25,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            AppTheme.notificationMessages[0],
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.textDark,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          // Animação de gotas de água
                          AnimatedBuilder(
                            animation: _waterAnimation,
                            builder: (context, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Transform.translate(
                                      offset: Offset(
                                        0,
                                        -20 * _waterAnimation.value,
                                      ),
                                      child: Opacity(
                                        opacity: _waterAnimation.value,
                                        child: Icon(
                                          Icons.water_drop,
                                          size: 30 + (index * 5),
                                          color: AppTheme.lightBlue,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 1000.ms, duration: 800.ms)
                    .slideY(begin: 0.3),

                const Spacer(),

                // Botões de ação
                Column(
                  children: [
                    // Botão principal
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Aqui você pode adicionar lógica para registrar o consumo
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPink,
                          foregroundColor: AppTheme.white,
                          elevation: 8,
                          shadowColor: AppTheme.primaryPink.withAlpha(4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: const Text(
                          'Já bebi água! 💕',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 1500.ms, duration: 800.ms).scale(),

                    const SizedBox(height: 20),

                    // Botão secundário
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Lembrar mais tarde',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 16,
                        ),
                      ),
                    ).animate().fadeIn(delay: 2000.ms, duration: 800.ms),

                    const SizedBox(height: 20),

                    // Dica romântica
                    Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.white.withAlpha(8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lightbulb,
                                color: AppTheme.primaryPink,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Dica: Beba um copo de água agora e seu corpo vai agradecer! 💖',
                                  style: TextStyle(
                                    color: AppTheme.textDark,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 2500.ms, duration: 800.ms)
                        .slideY(begin: 0.3),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
