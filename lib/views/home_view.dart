// lib/views/home_view.dart

import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../services/spotify_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Instancia del servicio para consumir la API de Spotify
  final SpotifyService _spotifyService = SpotifyService();
  
  // Objeto para almacenar la información de la canción obtenida
  SongModel? _currentSong;
  
  // Banderas de estado para el loader y la reproducción
  bool _isLoading = false;
  bool _isPlaying = false;

  // ID de pista de prueba para validar con Client Credentials Flow
  final String _sampleTrackId = '3n3Ppam7vgaVa1iaRUc9Lp'; // "Mr. Brightside" de The Killers

  // Método para consultar los metadatos de la canción y actualizar la interfaz
  Future<void> _fetchTrackInfo() async {
    setState(() => _isLoading = true);

    // Llamada al método que consulta la canción por su ID
    final song = await _spotifyService.getSampleTrack(_sampleTrackId);

    // Actualizamos el estado con la canción obtenida
    setState(() {
      _currentSong = song;
      _isLoading = false;
      if (song != null) _isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('MusicAveo'),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Contenedor dinámico de la carátula del álbum
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withAlpha(50),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      )
                    : _currentSong != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              _currentSong!.rawImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.music_note,
                                size: 100,
                                color: Colors.white38,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.music_note,
                            size: 100,
                            color: Colors.white38,
                          ),
              ),

              // Información del título y artista de la pista
              Column(
                children: [
                  Text(
                    _currentSong?.title ?? 'Sin reproducción',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentSong?.artist ?? 'Presiona Sincronizar para cargar datos',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              // Controles del reproductor (Diseñados en tamaño grande para conducción)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 48,
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    iconSize: 64,
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() => _isPlaying = !_isPlaying);
                    },
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    iconSize: 48,
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),

              // Botón manual para consultar metadatos a la API
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: _fetchTrackInfo,
                icon: const Icon(Icons.sync, color: Colors.green),
                label: const Text(
                  'Sincronizar Metadata',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}