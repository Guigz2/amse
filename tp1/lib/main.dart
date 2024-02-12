import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  var favorites = List<Film>.empty(growable: true);

  void toggleFavorite(Film currents){
    if (favorites.contains(currents)){
      favorites.remove(currents);
    } else {
      favorites.add(currents);
    }
    notifyListeners();
  }

  late List<Film> films;

  Future<void> readJson() async {
    try {
      final String response = await rootBundle.loadString('films.json');
      final jsonData = json.decode(response);
      // Récupérer la liste de films à partir du Map
      List<dynamic> filmsData = jsonData['films'];
      // Créer une liste d'objets Film à partir de la liste de données
      films = filmsData.map((filmData) => Film.fromJson(filmData)).toList();
      // Utiliser setState pour mettre à jour l'état du widget
    }
    catch (e) {
      print("Erreur lors de la lecture du fichier JSON : $e");
    }
    notifyListeners();
  }

  IconData favorite_icon(Film film){
    IconData icon;
    print(favorites);
    if (favorites.contains(film)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return icon;
  }

}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Film {
  final int id;
  final String titre;
  final String realisateur;
  final int annee;
  final String img;

  Film({required this.id, required this.titre, required this.realisateur, required this.annee, required this.img});

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'] as int? ?? 0, // Utilisation de 'as int?' pour indiquer que la valeur peut être null
      titre: json['titre'] as String? ?? 'null', // Utilisation de 'as String?' pour indiquer que la valeur peut être null
      realisateur: json['realisateur'] as String? ?? 'null', // Utilisation de 'as String?' pour indiquer que la valeur peut être null
      annee: json['annee'] as int? ?? 0, // Utilisation de 'as int?' pour indiquer que la valeur peut être null
      img: json['img'] as String? ?? 'null',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Film &&
        other.id == id &&
        other.titre == titre &&
        other.realisateur == realisateur &&
        other.annee == annee;
  }

  @override
  int get hashCode {
    return id.hashCode ^ titre.hashCode ^ realisateur.hashCode ^ annee.hashCode;
  }
}

class Series {
  final int id;
  final String titre;
  final String realisateur;
  final int annee;

  Series({required this.id, required this.titre, required this.realisateur, required this.annee});

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'] as int? ?? 0, // Utilisation de 'as int?' pour indiquer que la valeur peut être null
      titre: json['titre'] as String? ?? 'null', // Utilisation de 'as String?' pour indiquer que la valeur peut être null
      realisateur: json['realisateur'] as String? ?? 'null', // Utilisation de 'as String?' pour indiquer que la valeur peut être null
      annee: json['annee'] as int? ?? 0, // Utilisation de 'as int?' pour indiquer que la valeur peut être null
    );
  }
}

class Sports {
  final int id;
  final String titre;
  final String realisateur;
  final int annee;

  Sports({required this.id, required this.titre, required this.realisateur, required this.annee});

  factory Sports.fromJson(Map<String, dynamic> json) {
    return Sports(
      id: json['id'] as int? ?? 0, // Utilisation de 'as int?' pour indiquer que la valeur peut être null
      titre: json['titre'] as String? ?? 'null', // Utilisation de 'as String?' pour indiquer que la valeur peut être null
      realisateur: json['realisateur'] as String? ?? 'null', // Utilisation de 'as String?' pour indiquer que la valeur peut être null
      annee: json['annee'] as int? ?? 0, // Utilisation de 'as int?' pour indiquer que la valeur peut être null
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  
  var selectedIndex = 0;

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: ListView(
  //       children: [
  //         for(var film in films)
  //           ListTile( 
  //             title: Text('ID: ${film.id}: Nom: ${film.titre}'),
  //             subtitle: Text('Réalisateur: ${film.realisateur}: Année: ${film.annee}'),
  //           ),
  //       ],
  //     )
  //   );
  // }

  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorFilm();
        break;
      case 1:
        page = Placeholder();
        break;
      case 2:
        page = Placeholder();
        break;
      case 3:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context,contraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: contraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.movie),
                      label: Text('Films'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.live_tv),
                      label: Text('Séries'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.sports_handball),
                      label: Text('Sports'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorFilm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.readJson();
    List<Film> films = appState.films;

    if (films.isEmpty) {
      return Center(child: Text("No film yet"),
      );
    }

    IconData icon;
    if (appState.favorites.contains(films)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child : Text('You have '
                '${films.length} films:'),
        ),
        for (var film in films)
          ListTile(
            leading: Icon(Icons.fiber_manual_record_outlined),
            title: Row(
              children: [
                Expanded(
                  child: Text(film.titre), 
                ),
                Expanded(
                  child: Text('réalisateur : ${film.realisateur}'), 
                ),
                Expanded(
                  child: Text('date : ${film.annee}'), 
                ),
                Expanded(
                  child: Image.asset("${film.img}"), 
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite(film);
                  },
                  icon: Icon(appState.favorite_icon(film)),
                  label: Text('Like'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}


class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(child: Text("No favorites yet"),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child : Text('Vous avez '
                '${appState.favorites.length} favories:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Nom: ${pair.titre}'),
            subtitle: Text('Réalisateur: ${pair.realisateur} | Année: ${pair.annee} | ${pair.runtimeType}'),
            trailing: Image.asset("${pair.img}"),
          ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}