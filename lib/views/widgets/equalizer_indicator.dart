import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

// Indicador visual de ondas de som (equalizador) animado
class EqualizerIndicator extends StatefulWidget {
  final bool isPlaying;

  const EqualizerIndicator({super.key, this.isPlaying = true});

  @override
  State<EqualizerIndicator> createState() => _EqualizerIndicatorState();
}

class _EqualizerIndicatorState extends State<EqualizerIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(EqualizerIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isPlaying && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBar(4 + (12 * _controller.value), AppColors.tertiary),
          const SizedBox(width: 2),
          _buildBar(14 - (8 * _controller.value), AppColors.primaryContainer),
          const SizedBox(width: 2),
          _buildBar(6 + (10 * _controller.value), AppColors.tertiary),
        ],
      ),
    );
  }

  // Constrói uma barra individual do equalizador
  Widget _buildBar(double height, Color color) {
    return Container(
      width: 3.5,
      height: height.clamp(4.0, 18.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

