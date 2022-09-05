import 'package:flutter/material.dart';
import 'package:superheroes/resources/colors.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({required this.text, this.onTap, super.key});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: const BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      );
}
