//lib/services/spotify_service.dart

//Clase encargada de manejar la comunicacion HTTP y autencitacion con la API de Spotify
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:music_aveo/models/song_model.dart';

class SpotifyService {
  //Cargo mis credenciales desde el archivo .env previamente inciicilizado
  final String _clientId = dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  final String _clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';

  //Variable para almacenar el token de acceso obtenido de la API de Spotify
  String? _accessToken;

  //Paso 1: Método para obtener el token de acceso de la API de Spotify
  Future<bool> authenticate() async {
    //Aquí iría la lógica para realizar la solicitud HTTP a la API de Spotify y obtener el token de acceso
    //Por ejemplo, usando la librería http para hacer un POST request con las credenciales
    //Luego, almacenar el token en _accessToken

    //Se codifica el cliente e id secreto en formato base64 para la autenticación básica
    final String credentials = base64Encode(utf8.encode('$_clientId:$_clientSecret'));

    //Se realiza la peticion POST a la API de Spotify para obtener el token de acceso
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    //Si la respuesta es exitoa (HTTP 200), se decodifica el JSON y se almacena el token de acceso
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      return true;
    }
    //Si la respuesta no es exitosa, se lanza una excepción con el mensaje de error
    return false;
  }
  
  //paso 2: Método para obtener la canción actual que se está reproduciendo en Spotify
  Future<SongModel?> getCurrentlyPlaying() async {
    //Si no hay token de acceso, se lanza una excepción
    if (_accessToken == null) return null;

    //Se realiza la peticion GET a la API de Spotify para obtener la canción actual
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/player/currently-playing'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    //Si la respuesta es exitosa (HTTP 200), se decodifica el JSON y se crea un objeto SongModel
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return SongModel.fromJson(data);
    } 
    //Si la respuesta no es exitosa, se retorna null
    return null;
  }
}