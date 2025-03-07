import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color backgroundColor;
  final String assetPath; // Шлях до іконки
  final VoidCallback onPressed;

  RoundedButton({
    required this.backgroundColor,
    required this.assetPath,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    // Отримуємо розміри екрану
    final double screenWidth = MediaQuery.of(context).size.width;

    // Розраховуємо ширину та висоту кнопки залежно від ширини екрану
    final double buttonWidth = screenWidth * 0.25; // 20% ширини екрану
    final double buttonHeight = buttonWidth * 0.5; // Пропорційна висота
    final double iconSize = buttonHeight * 0.4; // Іконка займає 50% висоти кнопки

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(buttonHeight / 2), // Округлені краї (повністю круглі з боків)
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            width: iconSize, // Динамічний розмір іконки
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}