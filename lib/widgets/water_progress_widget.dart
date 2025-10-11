import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/water_intake.dart';

class WaterProgressWidget extends StatefulWidget {
  final DailyProgress progress;
  final VoidCallback? onGoalReached;

  const WaterProgressWidget({
    super.key,
    required this.progress,
    this.onGoalReached,
  });

  @override
  State<WaterProgressWidget> createState() => _WaterProgressWidgetState();
}

class _WaterProgressWidgetState extends State<WaterProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _fillController;
  late AnimationController _heartController;
  late Animation<double> _fillAnimation;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    
    _fillController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _heartController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress.progressPercentage,
    ).animate(CurvedAnimation(
      parent: _fillController,
      curve: Curves.easeInOut,
    ));

    _heartAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));

    _fillController.forward();
    
    if (widget.progress.isGoalReached) {
      _heartController.repeat(reverse: true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onGoalReached?.call();
      });
    }
  }

  @override
  void didUpdateWidget(WaterProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress.progressPercentage != widget.progress.progressPercentage) {
      _fillAnimation = Tween<double>(
        begin: oldWidget.progress.progressPercentage,
        end: widget.progress.progressPercentage,
      ).animate(CurvedAnimation(
        parent: _fillController,
        curve: Curves.easeInOut,
      ));
      _fillController.reset();
      _fillController.forward();
      
      if (widget.progress.isGoalReached && !oldWidget.progress.isGoalReached) {
        _heartController.repeat(reverse: true);
        widget.onGoalReached?.call();
      }
    }
  }

  @override
  void dispose() {
    _fillController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPink.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título
          Text(
            'Seu progresso hoje 💧',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 24),

          // Garrafa de água animada
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Garrafa
                Container(
                  width: 100,
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightPink,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(57),
                    child: AnimatedBuilder(
                      animation: _fillAnimation,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            // Água preenchida
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 140 * _fillAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppTheme.lightBlue,
                                      AppTheme.primaryPink,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(57),
                                ),
                              ),
                            ),
                            // Corações flutuantes quando meta é atingida
                            if (widget.progress.isGoalReached)
                              ...List.generate(3, (index) {
                                return Positioned(
                                  top: 20 + (index * 30),
                                  left: 10 + (index * 15),
                                  child: AnimatedBuilder(
                                    animation: _heartAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _heartAnimation.value,
                                        child: const Icon(
                                          Icons.favorite,
                                          color: AppTheme.primaryPink,
                                          size: 16,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // Tampinha
                Positioned(
                  top: 0,
                  child: Container(
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppTheme.lightPink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Informações de progresso
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '${widget.progress.totalIntake}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.primaryPink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ml bebidos',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${widget.progress.goal}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ml meta',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${(widget.progress.progressPercentage * 100).toInt()}%',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: widget.progress.isGoalReached 
                          ? AppTheme.primaryPink 
                          : AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'progresso',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barra de progresso
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
            child: AnimatedBuilder(
              animation: _fillAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _fillAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.heartGradient,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),

          if (widget.progress.isGoalReached) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPink.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
              child: const Text(
                '🎉 Meta atingida! Você é incrível! 🎉',
                style: TextStyle(
                  color: AppTheme.primaryPink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
