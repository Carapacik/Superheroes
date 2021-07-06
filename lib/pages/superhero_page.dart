import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class SuperheroPage extends StatelessWidget {
  final String heroName;

  const SuperheroPage({
    Key? key,
    required this.heroName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 297),
              Text(
                heroName,
                style: TextStyle(
                  fontSize: 20,
                  color: SuperheroesColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 231),
              ActionButton(
                  text: "Back", onTap: () => Navigator.of(context).pop())
            ],
          ),
        ),
      ),
    );
  }
}
