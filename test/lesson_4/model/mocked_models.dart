import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';
import 'package:superheroes/model/superhero.dart';

import 'search_response.dart';
import 'superhero_response.dart';

final bio1 = Biography(
  alignment: 'good',
  aliases: ['Batman', 'Batmanische'],
  fullName: "Toby McGuire",
  placeOfBirth: "Moscow-city",
);

final bio2 = Biography(
  alignment: 'neutral',
  aliases: ['Batman', 'Batmanische', 'Bataman', 'Chelovek Letuchaya Mysh\''],
  fullName: "Toby McGuire",
  placeOfBirth: "Moscow-city",
);

final bio3 = Biography(
  alignment: 'bad',
  aliases: ['Batman', 'Batmanische'],
  fullName: "Toby McGuire",
  placeOfBirth: "11111111111111111111111111111111111111111111111111",
);

final powerstats1 = Powerstats(
  intelligence: "100",
  strength: "100",
  speed: "100",
  durability: "100",
  power: "100",
  combat: "100",
);

final superhero1 = Superhero(
  id: "70",
  name: "Batman",
  biography: bio1,
  image: ServerImage("https://www.superherodb.com/pictures2/portraits/10/100/639.jpg"),
  powerstats: powerstats1,
);

final superheroResponse1 = SuperheroResponse(
  response: "success",
  id: superhero1.id,
  name: superhero1.name,
  biography: superhero1.biography,
  image: superhero1.image,
  powerstats: superhero1.powerstats,
);

final superhero2 = Superhero(
  id: "80",
  name: "Ironman",
  biography: bio2,
  image: ServerImage("https://www.superherodb.com/pictures2/portraits/10/100/100.jpg"),
  powerstats: powerstats1,
);

final superheroResponse2 = SuperheroResponse(
  response: "success",
  id: superhero2.id,
  name: superhero2.name,
  biography: superhero2.biography,
  image: superhero2.image,
  powerstats: superhero2.powerstats,
);

final superhero3 = Superhero(
  id: "90",
  name: "Saloman",
  biography: bio3,
  image: ServerImage("https://www.superherodb.com/pictures2/portraits/10/100/89.jpg"),
  powerstats: powerstats1,
);

final superheroResponse3 = SuperheroResponse(
  response: "success",
  id: superhero3.id,
  name: superhero3.name,
  biography: superhero3.biography,
  image: superhero3.image,
  powerstats: superhero3.powerstats,
);

final superheroResponseWithError = SuperheroResponse(
  response: "error",
  error: "access denied",
);

final superhero4 = Superhero(
  id: "180",
  name: "Chelovek-Nauk",
  biography: bio2,
  image: ServerImage("https://www.superherodb.com/pictures2/portraits/10/100/200.jpg"),
  powerstats: powerstats1,
);

final superheroResponse4 = SuperheroResponse(
  response: "success",
  id: superhero4.id,
  name: superhero4.name,
  biography: superhero4.biography,
  image: superhero4.image,
  powerstats: superhero4.powerstats,
);

final superhero5 = Superhero(
  id: "222",
  name: "Chelovek Molekula",
  biography: bio3,
  image: ServerImage("https://www.superherodb.com/pictures2/portraits/10/100/222.jpg"),
  powerstats: powerstats1,
);

final superheroResponse5 = SuperheroResponse(
  response: "success",
  id: superhero5.id,
  name: superhero5.name,
  biography: superhero5.biography,
  image: superhero5.image,
  powerstats: superhero5.powerstats,
);

final searchResponse1 = SearchResponse(
  result: "success",
  results: [superhero1],
);
