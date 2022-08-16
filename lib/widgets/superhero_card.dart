import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/colors.dart';
import 'package:superheroes/resources/images.dart';
import 'package:superheroes/widgets/alignment_widget.dart';

class SuperheroCard extends StatelessWidget {
  const SuperheroCard({
    required this.superheroInfo,
    required this.onTap,
    super.key,
  });

  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.indigo,
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

class NameAndRealNameWidget extends StatelessWidget {
  const NameAndRealNameWidget({required this.superheroInfo, super.key});

  final SuperheroInfo superheroInfo;

  @override
  Widget build(BuildContext context) => Expanded(
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

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({required this.superheroInfo});

  final SuperheroInfo superheroInfo;

  @override
  Widget build(BuildContext context) => Container(
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
              color: AppColors.blue,
              value: progress.progress,
            ),
          ),
          errorWidget: (context, url, dynamic error) => Center(
            child: Image.asset(
              AppImages.unknown,
              width: 20,
              height: 62,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
