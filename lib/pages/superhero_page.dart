import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/superhero_bloc.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/colors.dart';
import 'package:superheroes/resources/images.dart';
import 'package:superheroes/widgets/alignment_widget.dart';
import 'package:superheroes/widgets/info_with_button.dart';

class SuperheroPage extends StatefulWidget {
  const SuperheroPage({
    required this.id,
    this.client,
    super.key,
  });

  final http.Client? client;
  final String id;

  @override
  _SuperheroPageState createState() => _SuperheroPageState();
}

class _SuperheroPageState extends State<SuperheroPage> {
  late SuperheroBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = SuperheroBloc(client: widget.client, id: widget.id);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Provider.value(
        value: bloc,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: const SuperheroContentPage(),
            ),
          ),
        ),
      );
}

class SuperheroContentPage extends StatelessWidget {
  const SuperheroContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<SuperheroPageState>(
      stream: bloc.observeSuperheroPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final state = snapshot.requireData;
        switch (state) {
          case SuperheroPageState.loading:
            return const SuperheroLoadingWidget();
          case SuperheroPageState.loaded:
            return const SuperheroLoadedWidget();
          case SuperheroPageState.error:
            return const SuperheroErrorWidget();
        }
      },
    );
  }
}

class SuperheroLoadingWidget extends StatelessWidget {
  const SuperheroLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          const SliverAppBar(backgroundColor: AppColors.background),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 60),
              alignment: Alignment.topCenter,
              height: 44,
              width: 44,
              child: const CircularProgressIndicator(color: AppColors.blue),
            ),
          ),
        ],
      );
}

class SuperheroErrorWidget extends StatelessWidget {
  const SuperheroErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return CustomScrollView(
      slivers: [
        const SliverAppBar(backgroundColor: AppColors.background),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(top: 60),
            alignment: Alignment.topCenter,
            child: InfoWithButton(
              title: 'Error happened',
              subtitle: 'Please, try again',
              buttonText: 'Retry',
              assetImage: AppImages.superman,
              imageHeight: 106,
              imageWidth: 126,
              imageTopPadding: 22,
              onTap: bloc.retry,
            ),
          ),
        ),
      ],
    );
  }
}

class SuperheroLoadedWidget extends StatelessWidget {
  const SuperheroLoadedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<Superhero>(
      stream: bloc.observeSuperhero(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final superhero = snapshot.requireData;
        return CustomScrollView(
          slivers: [
            SuperheroAppBar(superhero: superhero),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  if (superhero.powerstats.isNotNull())
                    PowerStatsWidget(powerStats: superhero.powerstats),
                  BiographyWidget(biography: superhero.biography),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SuperheroAppBar extends StatelessWidget {
  const SuperheroAppBar({required this.superhero, super.key});

  final Superhero superhero;

  @override
  Widget build(BuildContext context) => SliverAppBar(
        stretch: true,
        pinned: true,
        floating: true,
        expandedHeight: 348,
        actions: const [FavoriteButton()],
        backgroundColor: AppColors.background,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            superhero.name,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          background: CachedNetworkImage(
            imageUrl: superhero.image.url,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const ColoredBox(color: AppColors.indigo),
            errorWidget: (context, url, dynamic error) => Container(
              alignment: Alignment.center,
              color: AppColors.indigo,
              child: Image.asset(
                AppImages.unknownBig,
                height: 264,
                width: 85,
              ),
            ),
          ),
        ),
      );
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<bool>(
      stream: bloc.observeIsFavorite(),
      initialData: false,
      builder: (context, snapshot) {
        final favorite = !snapshot.hasData || snapshot.requireData;
        return GestureDetector(
          onTap: () =>
              favorite ? bloc.removeFromFavorites() : bloc.addToFavorite(),
          child: Container(
            height: 52,
            width: 52,
            alignment: Alignment.center,
            child: Image.asset(
              favorite ? AppImages.starFilled : AppImages.starEmpty,
              height: 32,
              width: 32,
            ),
          ),
        );
      },
    );
  }
}

class PowerStatsWidget extends StatelessWidget {
  const PowerStatsWidget({required this.powerStats, super.key});

  final Powerstats powerStats;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Powerstats'.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    name: 'Intelligence',
                    value: powerStats.intelligencePercent,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    name: 'Strength',
                    value: powerStats.strengthPercent,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    name: 'Speed',
                    value: powerStats.speedPercent,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    name: 'Durability',
                    value: powerStats.durabilityPercent,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    name: 'Power',
                    value: powerStats.powerPercent,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    name: 'Durability',
                    value: powerStats.durabilityPercent,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 36),
        ],
      );
}

class PowerstatWidget extends StatelessWidget {
  const PowerstatWidget({
    required this.name,
    required this.value,
    super.key,
  });

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.topCenter,
        children: [
          ArcWidget(value: value, color: calculateColorByValue()),
          Padding(
            padding: const EdgeInsets.only(top: 17),
            child: Text(
              (value * 100).toInt().toString(),
              style: TextStyle(
                color: calculateColorByValue(),
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 44),
            child: Text(
              name.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );

  Color calculateColorByValue() {
    if (value <= 0.5) {
      return Color.lerp(
        Colors.red,
        Colors.orangeAccent,
        value / 0.5,
      )!;
    } else {
      return Color.lerp(
        Colors.orangeAccent,
        Colors.green,
        (value - 0.5) / 0.5,
      )!;
    }
  }
}

class ArcWidget extends StatelessWidget {
  const ArcWidget({
    required this.value,
    required this.color,
    super.key,
  });

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: ArcCustomPainter(value, color),
        size: const Size(66, 33),
      );
}

class ArcCustomPainter extends CustomPainter {
  ArcCustomPainter(this.value, this.color);

  final double value;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final backgroundPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    canvas
      ..drawArc(rect, pi, pi, false, backgroundPaint)
      ..drawArc(rect, pi, pi * value, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ArcCustomPainter) {
      return oldDelegate.value != value && oldDelegate.color != color;
    }
    return true;
  }
}

class BiographyWidget extends StatelessWidget {
  const BiographyWidget({required this.biography, super.key});

  final Biography biography;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.indigo,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Bio'.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  BiographyField(
                    fieldName: 'Full name',
                    fieldValue: biography.fullName,
                  ),
                  const SizedBox(height: 20),
                  BiographyField(
                    fieldName: 'Aliases',
                    fieldValue: biography.aliases.join(', '),
                  ),
                  const SizedBox(height: 20),
                  BiographyField(
                    fieldName: 'Place of birth',
                    fieldValue: biography.placeOfBirth,
                  ),
                ],
              ),
            ),
            if (biography.alignmentInfo != null)
              Align(
                alignment: Alignment.topRight,
                child: AlignmentWidget(
                  alignmentInfo: biography.alignmentInfo!,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              )
          ],
        ),
      );
}

class BiographyField extends StatelessWidget {
  const BiographyField({
    required this.fieldName,
    required this.fieldValue,
    super.key,
  });

  final String fieldName;
  final String fieldValue;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            fieldName.toUpperCase(),
            style: const TextStyle(
              color: AppColors.secondaryGrey,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            fieldValue,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ],
      );
}
