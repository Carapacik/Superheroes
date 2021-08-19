import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class SuperheroPage extends StatelessWidget {
  final String id;

  const SuperheroPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final superHero = Superhero(
      id: id,
      name: "Batman",
      biography: Biography(
        aliases: ["Lost", "Batmanovich"],
        alignment: "good",
        fullName: "Bruce",
        placeOfBirth: "Gotham",
      ),
      image: ServerImage("https://www.superherodb.com/pictures2/portraits/10/100/639.jpg"),
      powerstats: Powerstats(
        intelligence: "90",
        strength: "90",
        speed: "16",
        durability: "45",
        power: "100",
        combat: "0",
      ),
    );

    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: CustomScrollView(
        slivers: [
          SuperheroAppBar(superHero: superHero),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (superHero.powerstats.isNotNull()) PowerStatsWidget(powerstats: superHero.powerstats),
                BiographyWidget(biography: superHero.biography),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SuperheroAppBar extends StatelessWidget {
  const SuperheroAppBar({
    Key? key,
    required this.superHero,
  }) : super(key: key);

  final Superhero superHero;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      pinned: true,
      floating: true,
      expandedHeight: 348,
      backgroundColor: SuperheroesColors.background,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          superHero.name,
          style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        background: CachedNetworkImage(
          imageUrl: superHero.image.url,
          fit: BoxFit.cover,
        ),
      ),
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
    return Container(
      height: 350,
      alignment: Alignment.center,
      child: Text(
        powerstats.toJson().toString(),
        style: const TextStyle(color: Colors.white),
      ),
    );
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
    return Container(
      height: 350,
      alignment: Alignment.center,
      child: Text(
        biography.toJson().toString(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
