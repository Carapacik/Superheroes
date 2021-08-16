import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class InfoWithButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String assetImage;
  final double imageHeight;
  final double imageWidth;
  final double imageTopPadding;
  final VoidCallback onTap;

  const InfoWithButton({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.assetImage,
    required this.imageHeight,
    required this.imageWidth,
    required this.imageTopPadding,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 108,
              height: 108,
              decoration: const BoxDecoration(
                color: SuperheroesColors.blue,
                shape: BoxShape.circle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: imageTopPadding),
              child: Image.asset(
                assetImage,
                height: imageHeight,
                width: imageWidth,
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          subtitle.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
        ActionButton(text: buttonText, onTap: onTap)
      ],
    );
  }
}
