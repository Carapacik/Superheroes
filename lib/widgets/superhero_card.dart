import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class SuperheroCard extends StatelessWidget {
  final String name;
  final String realName;
  final String imageUrl;

  const SuperheroCard(
      {Key? key,
      required this.name,
      required this.realName,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      color: SuperheroesColors.heroBackground,
      child: Row(
        children: [
          Image.network(
            imageUrl,
            height: 70,
            width: 70,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: SuperheroesColors.white,
                  ),
                ),
                Text(
                  realName,
                  style: TextStyle(
                    fontSize: 14,
                    color: SuperheroesColors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
