import 'package:flutter/material.dart';
import 'package:superheroes/model/alignment.dart';

class AlignmentWidget extends StatelessWidget {
  const AlignmentWidget({
    required this.alignmentEnum,
    required this.borderRadius,
    super.key,
  });

  final AlignmentEnum alignmentEnum;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => RotatedBox(
        quarterTurns: 1,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 6),
          height: 24,
          width: 70,
          decoration: BoxDecoration(
            color: alignmentEnum.color,
            borderRadius: borderRadius,
          ),
          child: Text(
            alignmentEnum.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ),
      );
}
