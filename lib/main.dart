import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:music_aveo/views/home_view.dart';

Future<void> main() async { 

  //Se asegura que los bindings de Flutter estén inicializados antes de cargar las variables de entorno
  WidgetsFlutterBinding.ensureInitialized();

  //Carga las variables de entorno desde el archivo .env
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'MusicAveo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const HomeView(),
    );
  }
}





