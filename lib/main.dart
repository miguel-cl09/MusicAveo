import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:music_aveo/services/spotify_service.dart';

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
        home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MusicAveo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            //Aquí iría la lógica para autenticar y obtener la canción actual
            //Instanciar SpotifyService y llamar a sus métodos
            final spotifyService = SpotifyService();
            bool success = await spotifyService.authenticate();

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'Autenticación exitosa'
                      : 'Error en la autenticación'),
                ),
              );
            }
          },
          child: const Text('Obtener canción actual'),
        ),
      ),
    );
  }
}



