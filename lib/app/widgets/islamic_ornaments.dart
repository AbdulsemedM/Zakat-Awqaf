import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Repeating khatam (eight-point star) lattice, the classic girih motif.
class IslamicPatternPainter extends CustomPainter {
  const IslamicPatternPainter({
    this.color = AppColors.warmGold,
    this.opacity = 0.14,
    this.cell = 44,
    this.strokeWidth = 0.8,
  });

  final Color color;
  final double opacity;
  final double cell;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final r = cell * 0.36;
    final rows = (size.height / cell).ceil() + 1;
    final cols = (size.width / cell).ceil() + 1;
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final c = Offset(col * cell, row * cell);
        _khatam(canvas, c, r, paint);
        // Diagonal links between neighbouring stars form the lattice.
        final half = cell / 2;
        canvas.drawLine(
          c + Offset(r * 0.7, r * 0.7),
          c + Offset(half, half),
          paint,
        );
        canvas.drawLine(
          c + Offset(-r * 0.7, r * 0.7),
          c + Offset(-half, half),
          paint,
        );
      }
    }
  }

  /// Two overlapping squares, one rotated 45 degrees.
  void _khatam(Canvas canvas, Offset c, double r, Paint paint) {
    for (final start in [0.0, math.pi / 4]) {
      final path = Path();
      for (var i = 0; i < 4; i++) {
        final a = start + i * math.pi / 2;
        final p = c + Offset(math.cos(a) * r, math.sin(a) * r);
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
    canvas.drawCircle(c, r * 0.28, paint);
  }

  @override
  bool shouldRepaint(covariant IslamicPatternPainter old) =>
      old.color != color ||
      old.opacity != opacity ||
      old.cell != cell ||
      old.strokeWidth != strokeWidth;
}

/// Full-bleed pattern layer that fades out toward [fadeTo], so text stays legible.
class IslamicPatternLayer extends StatelessWidget {
  const IslamicPatternLayer({
    super.key,
    this.color = AppColors.warmGold,
    this.opacity = 0.16,
    this.cell = 44,
    this.fadeTo = Alignment.bottomLeft,
  });

  final Color color;
  final double opacity;
  final double cell;
  final Alignment fadeTo;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: ClipRect(
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment(-fadeTo.x, -fadeTo.y),
              end: fadeTo,
              colors: const [Colors.white, Colors.transparent],
            ).createShader(rect),
            child: CustomPaint(
              painter: IslamicPatternPainter(
                color: color,
                opacity: opacity,
                cell: cell,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Thin gold rule with a centred diamond.
class GoldOrnamentDivider extends StatelessWidget {
  const GoldOrnamentDivider({super.key, this.width = 56, this.color});

  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.warmGold;
    Widget line() => Container(width: width / 2 - 6, height: 1, color: c);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        line(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(width: 5, height: 5, color: c),
          ),
        ),
        line(),
      ],
    );
  }
}

/// Playfair section title with a gold ornament and an optional action link.
class ZakatSectionHeader extends StatelessWidget {
  const ZakatSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.displayHeading(
                  fontSize: 19,
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const GoldOrnamentDivider(width: 44),
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              foregroundColor: AppColors.goldDeep,
            ),
            child: Text(
              actionLabel!,
              style: AppTypography.body(
                fontSize: 13,
                color: AppColors.goldDeep,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

/// Elevated surface card with a gold hairline border and a soft emerald shadow.
class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 20,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: dark
            ? null
            : const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 18,
                  spreadRadius: -4,
                  offset: Offset(0, 6),
                ),
              ],
      ),
      child: child,
    );
  }
}

/// Frosted panel for use on emerald hero surfaces.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 18,
    this.goldBorder = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool goldBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.14),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: goldBorder
              ? AppColors.goldLight.withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: child,
    );
  }
}

/// Gold crescent with a small star, drawn as a faint hero ornament.
class CrescentOrnament extends StatelessWidget {
  const CrescentOrnament({super.key, this.size = 140, this.opacity = 0.22});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.square(size),
        painter: _CrescentPainter(opacity),
      ),
    );
  }
}

class _CrescentPainter extends CustomPainter {
  const _CrescentPainter(this.opacity);

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final outer = Path()
      ..addOval(Rect.fromCircle(center: Offset(r, r), radius: r));
    final inner = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(r * 1.38, r * 0.82), radius: r * 0.84),
      );
    final crescent = Path.combine(PathOperation.difference, outer, inner);

    canvas.drawPath(
      crescent,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.goldLight.withValues(alpha: opacity),
            AppColors.warmGold.withValues(alpha: opacity * 0.4),
          ],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      crescent,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.goldLight.withValues(alpha: opacity * 1.6),
    );

    // Five-point star inside the crescent's opening.
    final star = Path();
    final c = Offset(r * 1.2, r * 0.62);
    final so = r * 0.14;
    final si = so * 0.42;
    for (var i = 0; i < 10; i++) {
      final rad = i.isEven ? so : si;
      final a = -math.pi / 2 + i * math.pi / 5;
      final p = c + Offset(rad * math.cos(a), rad * math.sin(a));
      i == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
    }
    star.close();
    canvas.drawPath(
      star,
      Paint()..color = AppColors.goldLight.withValues(alpha: opacity * 2.2),
    );
  }

  @override
  bool shouldRepaint(covariant _CrescentPainter old) => old.opacity != opacity;
}
