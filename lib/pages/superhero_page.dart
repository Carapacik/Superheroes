import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class SuperheroPage extends StatelessWidget {
  const SuperheroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Hero name",
              style: TextStyle(
                fontSize: 20,
                color: SuperheroesColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            ActionButton(text: "Back", onTap: () {})
          ],
        ),
      ),
    );
  }
}
