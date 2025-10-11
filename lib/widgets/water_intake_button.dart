import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaterIntakeButton extends StatefulWidget {
  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const WaterIntakeButton({
    super.key,
    required this.amount,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<WaterIntakeButton> createState() => _WaterIntakeButtonState();
}

class _WaterIntakeButtonState extends State<WaterIntakeButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _rippleController;
  late Animation<double> _pressAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _pressController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  void _onTap() {
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _pressAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pressAnimation.value,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: AppTheme.heartGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPink.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Efeito ripple
                  AnimatedBuilder(
                    animation: _rippleAnimation,
                    builder: (context, child) {
                      return Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppTheme.white.withValues(
                              alpha: 0.3 * (1 - _rippleAnimation.value),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Conteúdo do botão
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.icon,
                          color: AppTheme.white,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.amount == 0 ? widget.label : '${widget.amount}ml',
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (widget.amount > 0)
                          Text(
                            widget.label,
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
