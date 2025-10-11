import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _waterController;
  late Animation<double> _heartAnimation;
  late Animation<double> _waterAnimation;

  @override
  void initState() {
    super.initState();
    
    _heartController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _waterController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _heartAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));

    _waterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waterController,
      curve: Curves.easeInOut,
    ));

    _heartController.repeat(reverse: true);
    _waterController.forward();
  }

  @override
  void dispose() {
    _heartController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.romanticGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),
                
                // Ícone de coração animado
                AnimatedBuilder(
                  animation: _heartAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _heartAnimation.value,
                      child: const Icon(
                        Icons.favorite,
                        size: 120,
                        color: AppTheme.primaryPink,
                      ),
                    );
                  },
                ).animate().fadeIn(duration: 800.ms).scale(),

                const SizedBox(height: 32),

                // Título principal
                Text(
                  'Bem-vinda, meu amor! 💕',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 500.ms, duration: 800.ms),

                const SizedBox(height: 16),

                // Subtítulo
                Text(
                  'Vou te ajudar a lembrar de beber água\ncom muito carinho e amor',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textLight,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 1000.ms, duration: 800.ms),

                const SizedBox(height: 48),

                // Animação de gotas de água
                AnimatedBuilder(
                  animation: _waterAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _waterAnimation.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.water_drop,
                              size: 20 + (index * 5),
                              color: AppTheme.lightBlue.withValues(alpha: 0.7),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ).animate().fadeIn(delay: 1500.ms, duration: 1000.ms),

                const SizedBox(height: 48),

                // Frase romântica
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryPink.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Text(
                    AppTheme.romanticPhrases[0],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textDark,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(delay: 2000.ms, duration: 800.ms).slideY(begin: 0.3),

                const Spacer(),

                // Botões de ação
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          await StorageService.setFirstTimeCompleted();
                          if (mounted) {
                            final navigator = Navigator.of(context);
                            navigator.pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Começar nossa jornada 💖',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 2500.ms, duration: 800.ms).slideY(begin: 0.3),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Configurar primeiro',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 16,
                        ),
                      ),
                    ).animate().fadeIn(delay: 3000.ms, duration: 800.ms),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
