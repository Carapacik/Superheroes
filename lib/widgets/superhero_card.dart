import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/alignment_widget.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  const SuperheroCard({
    Key? key,
    required this.superheroInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: SuperheroesColors.indigo,
        ),
        height: 70,
        child: Row(
          children: [
            _AvatarWidget(superheroInfo: superheroInfo),
            const SizedBox(width: 12),
            NameAndRealNameWidget(superheroInfo: superheroInfo),
            if (superheroInfo.alignmentInfo != null)
              AlignmentWidget(
                alignmentInfo: superheroInfo.alignmentInfo!,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NameAndRealNameWidget extends StatelessWidget {
  const NameAndRealNameWidget({
    Key? key,
    required this.superheroInfo,
  }) : super(key: key);

  final SuperheroInfo superheroInfo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            superheroInfo.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            superheroInfo.realName,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({
    Key? key,
    required this.superheroInfo,
  }) : super(key: key);

  final SuperheroInfo superheroInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white24,
      height: 70,
      width: 70,
      child: CachedNetworkImage(
        imageUrl: superheroInfo.imageUrl,
        height: 70,
        width: 70,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) => Container(
          alignment: Alignment.center,
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: SuperheroesColors.blue,
            value: progress.progress,
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: Image.asset(
            SuperheroesImages.unknown,
            width: 20,
            height: 62,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
