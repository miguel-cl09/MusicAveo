//lib/models/song_model.dart
class SongModel {
  //Atributos obligatorios para la información de la canción
  final String title;
  final String artist;
  final String album;
  final String rawImageUrl;

  //Constructor de la clase SongModel: exige las variables obligatorias al instanciar el objeto
  SongModel({
    required this.title,
    required this.artist,
    required this.album,
    required this.rawImageUrl,
  });

  //Constructor de tipo factory para crear una instancia de SongModel a partir de un mapa (por ejemplo, un JSON)
  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      //Uso el operador ?? para asignar un valor por defecto si la API devuelve un campo nulo
      title: json['item']['name'] ?? 'sin titulo',
      artist: json['item']['artists'][0]['name'] ?? 'Artista desconocido',
      album: json['item']['album']['name'] ?? 'Álbum desconocido',
      rawImageUrl: json['item']['album']['images'][0]['url'] ?? '',
    );
  }
}