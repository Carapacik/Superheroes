import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: SuperheroesColors.blue,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SuperheroesColors.white),
        ),
      ),
    );
  }
}
