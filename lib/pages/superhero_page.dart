import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/superhero_bloc.dart';
import 'package:superheroes/model/alignment_info.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_icons.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class SuperheroPage extends StatefulWidget {
  const SuperheroPage({
    Key? key,
    this.client,
    required this.id,
  }) : super(key: key);

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
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: const Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SuperheroContentPage(),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class SuperheroContentPage extends StatelessWidget {
  const SuperheroContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<Superhero>(
      stream: bloc.observeSuperhero(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final superhero = snapshot.data!;
        return CustomScrollView(
          slivers: [
            SuperheroAppBar(superhero: superhero),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  if (superhero.powerstats.isNotNull()) PowerStatsWidget(powerstats: superhero.powerstats),
                  BiographyWidget(biography: superhero.biography),
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
  const SuperheroAppBar({
    Key? key,
    required this.superhero,
  }) : super(key: key);

  final Superhero superhero;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      pinned: true,
      floating: true,
      expandedHeight: 348,
      actions: const [FavoriteButton()],
      backgroundColor: SuperheroesColors.background,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          superhero.name,
          style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        background: CachedNetworkImage(
          imageUrl: superhero.image.url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: 360,
            color: SuperheroesColors.indigo,
          ),
          errorWidget: (context, url, error) => ColoredBox(
            color: SuperheroesColors.indigo,
            child: Center(
              child: Image.asset(
                SuperheroesImages.unknownBig,
                height: 264,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<bool>(
      stream: bloc.observeIsFavorite(),
      initialData: false,
      builder: (context, snapshot) {
        final favorite = !snapshot.hasData || snapshot.data == null || snapshot.data!;
        return GestureDetector(
          onTap: () => favorite ? bloc.removeFromFavorites() : bloc.addToFavorite(),
          child: Container(
            height: 52,
            width: 52,
            alignment: Alignment.center,
            child: Image.asset(
              favorite ? SuperheroesIcons.starFilled : SuperheroesIcons.starEmpty,
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
  const PowerStatsWidget({
    Key? key,
    required this.powerstats,
  }) : super(key: key);

  final Powerstats powerstats;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            "Powerstats".toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: "Intelligence",
                  value: powerstats.intelligencePercent,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: "Strength",
                  value: powerstats.strengthPercent,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: "Speed",
                  value: powerstats.speedPercent,
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
                  name: "Durability",
                  value: powerstats.durabilityPercent,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: "Power",
                  value: powerstats.powerPercent,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: "Durability",
                  value: powerstats.durabilityPercent,
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
}

class PowerstatWidget extends StatelessWidget {
  const PowerstatWidget({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ArcWidget(value: value, color: calculateColorByValue()),
        Padding(
          padding: const EdgeInsets.only(top: 17),
          child: Text(
            (value * 100).toInt().toString(),
            style: TextStyle(color: calculateColorByValue(), fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 44),
          child: Text(
            name.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Color calculateColorByValue() {
    if (value <= 0.5) {
      return Color.lerp(Colors.red, Colors.orangeAccent, value / 0.5)!;
    } else {
      return Color.lerp(Colors.orangeAccent, Colors.green, (value - 0.5) / 0.5)!;
    }
  }
}

class ArcWidget extends StatelessWidget {
  const ArcWidget({
    Key? key,
    required this.value,
    required this.color,
  }) : super(key: key);

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ArcCustomPainter(value, color),
      size: const Size(66, 33),
    );
  }
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
    canvas.drawArc(rect, pi, pi, false, backgroundPaint);
    canvas.drawArc(rect, pi, pi * value, false, paint);
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
  const BiographyWidget({
    Key? key,
    required this.biography,
  }) : super(key: key);

  final Biography biography;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 24),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: SuperheroesColors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "BIO",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Full name".toUpperCase(),
                  style: const TextStyle(color: SuperheroesColors.ultraGrey, fontWeight: FontWeight.w700, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  biography.fullName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  "Aliases".toUpperCase(),
                  style: const TextStyle(color: SuperheroesColors.ultraGrey, fontWeight: FontWeight.w700, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  biography.aliases.join(","),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  "Place of birth".toUpperCase(),
                  style: const TextStyle(color: SuperheroesColors.ultraGrey, fontWeight: FontWeight.w700, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  biography.placeOfBirth,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 70,
              width: 24,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
              child: AlignmentWidget(alignmentInfo: AlignmentInfo.fromAlignment(biography.alignment)!),
            ),
          )
        ],
      ),
    );
  }
}
