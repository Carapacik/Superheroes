import 'package:flutter/material.dart';
import 'package:superheroes/model/alignment_info.dart';

class AlignmentWidget extends StatelessWidget {
  const AlignmentWidget({
    required this.alignmentInfo,
    required this.borderRadius,
    super.key,
  });

  final AlignmentInfo alignmentInfo;
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
            color: alignmentInfo.color,
            borderRadius: borderRadius,
          ),
          child: Text(
            alignmentInfo.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ),
      );
}
