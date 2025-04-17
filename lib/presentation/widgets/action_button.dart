import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final IconData icon;

  const ActionButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      child: Icon(icon, color: Colors.white),
    );
  }
}
