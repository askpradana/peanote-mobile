import 'package:flutter/material.dart';
import 'package:peanote/constant/pea_theme.dart';

class PeaButton extends StatelessWidget {
  final ButtonType? type;
  final String title;
  final VoidCallback? onPressed;
  final bool? secondaryButton;
  final IconData? icon;

  const PeaButton({
    super.key,
    this.type,
    required this.title,
    required this.onPressed,
    this.secondaryButton = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.outlinedButton:
        return _outlinedButton();
      case ButtonType.textButton:
        return _textButton();
      default:
        return _defaultButton();
    }
  }

  Widget _defaultButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: secondaryButton == true
            ? ElevatedButton.styleFrom(
                foregroundColor: PeaTheme.purpleColor,
                backgroundColor: PeaTheme.pinkColor,
              )
            : null,
        onPressed: onPressed,
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(icon),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              )
            : Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
      ),
    );
  }

  Widget _outlinedButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _textButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

enum ButtonType {
  outlinedButton,
  textButton,
}
