import 'package:flutter/material.dart';
import 'package:techysquad/utils/colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // SVG background
        Positioned.fill(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,

                  image: DecorationImage(
                    image: AssetImage('assets/images/BG.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Child content
        child,
      ],
    );
  }
}

class CustomCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Calculate scaling factors
    final double scaleX = size.width / 367; // Original width in SVG
    final double scaleY = size.height / 204; // Original height in SVG

    // Apply scaling to all coordinates

    // Start at top left corner with rounded edge
    path.moveTo(21 * scaleX, 1 * scaleY);

    // Line to where the top-left notch curve begins
    path.lineTo(48.5035 * scaleX, 1 * scaleY);

    // Create a smooth curve for the left side of the notch
    path.cubicTo(
      55.0274 * scaleX,
      1 * scaleY,
      61.1413 * scaleX,
      4.18189 * scaleY,
      64.8843 * scaleX,
      9.52517 * scaleY,
    );

    // Continue the smooth curve for the left slope of the notch
    path.cubicTo(
      70.5 * scaleX,
      20 * scaleY,
      76.5 * scaleX,
      30 * scaleY,
      83.5136 * scaleX,
      36.1192 * scaleY,
    );

    // Create a smooth transition to the flat bottom of the notch
    path.cubicTo(
      90.0639 * scaleX,
      45.47 * scaleY,
      100.763 * scaleX,
      51.0383 * scaleY,
      112.18 * scaleX,
      51.0383 * scaleY,
    );

    // Draw the flat horizontal bottom of the notch
    path.lineTo(257.514 * scaleX, 51.0383 * scaleY);

    // Create a smooth transition from the flat bottom to the right slope
    path.cubicTo(
      268.561 * scaleX,
      51.0383 * scaleY,
      278.959 * scaleX,
      45.8233 * scaleY,
      285.565 * scaleX,
      36.9699 * scaleY,
    );

    // Continue the smooth curve for the right slope of the notch
    path.cubicTo(
      292 * scaleX,
      28 * scaleY,
      300 * scaleX,
      18 * scaleY,
      306.407 * scaleX,
      9.03909 * scaleY,
    );

    // Complete the right side of the notch with a smooth curve
    path.cubicTo(
      310.182 * scaleX,
      3.98 * scaleY,
      316.124 * scaleX,
      1 * scaleY,
      322.436 * scaleX,
      1 * scaleY,
    );

    // Line to the right corner starting point
    path.lineTo((size.width - 21 * scaleX), 1 * scaleY);

    // Top right corner curve
    path.quadraticBezierTo(size.width, 1 * scaleY, size.width, 21 * scaleY);

    // Right side
    path.lineTo(size.width, (size.height - 21 * scaleY));

    // Bottom right corner curve
    path.quadraticBezierTo(
      size.width,
      size.height,
      (size.width - 21 * scaleX),
      size.height,
    );

    // Bottom side
    path.lineTo(21 * scaleX, size.height);

    // Bottom left corner curve
    path.quadraticBezierTo(0, size.height, 0, (size.height - 21 * scaleY));

    // Left side
    path.lineTo(0, 21 * scaleY);

    // Top left corner curve
    path.quadraticBezierTo(0, 0, 21 * scaleX, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
