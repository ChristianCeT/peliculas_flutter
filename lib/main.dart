import 'package:flutter/material.dart';
import 'package:peliculas_flutter/provider/movies_provider.dart';
import 'package:peliculas_flutter/screens/screens.dart';
import 'package:provider/provider.dart';

//En vez de MyApp es AppState para inialicar el arbol de widgets
void main() => runApp(const AppState());

//Nuevo widget del estado del provider
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => MoviesProvider(),
        //Sirve para inializar rapido el widget y que no se ejecute de manera perezosa
        lazy: false,
      ),
    ],
    child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'details': (_) => const DetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(color: Colors.indigo),
      ),
    );
  }
}
