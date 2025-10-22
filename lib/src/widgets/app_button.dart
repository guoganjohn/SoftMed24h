import 'package:flutter/material.dart';
import 'package:softmed24h/src/utils/app_colors.dart';

class AppButton extends StatelessWidget {
  // Add parameters to the constructor
  final String label;
  final double width;
  final double height;
  final double fontSize;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.label,
    this.width = 238, // Default width
    this.height = 47, // Default height
    this.fontSize = 25, // Default font size
    this.onPressed, // Expose onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Use the exposed onPressed callback
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: const StadiumBorder(),
        padding: EdgeInsets.zero,
        elevation: 4,
      ),
      child: SizedBox(
        // Use the passed-in width and height
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The positioned icon on the left
            Positioned(
              left: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right,
                  size: height - 5,
                  color: AppColors.primary,
                ),
              ),
            ),
            // The centered text, using the passed-in label
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
