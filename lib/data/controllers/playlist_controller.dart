import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_castor/data/api/api_spotify.dart';
import 'package:spotify_castor/data/models/playlist_model.dart';

class PlaylistController extends Api with ChangeNotifier {
  // Lista privada de playlists
  final List<PlaylistModel> _playlists = [];
  List<PlaylistModel> get playlists => _playlists;

  // Estado de inicialización de las playlists
  bool _playlistsInitialized = false;
  bool get playlistsInitialized => _playlistsInitialized;

  /// Inicializa la carga de playlists del usuario.
  /// Se utiliza el token de acceso y el market (language) para realizar la consulta.
  void initializePlaylists({required String token, required String language}) {
    _playlistsInitialized = false;
    _playlists.clear();

    _getUserPlaylists(token: token, language: language);
  }

  /// Realiza la consulta a la API para obtener las playlists del usuario
  void _getUserPlaylists({required String token, required String language}) {
    getQuery(
      route: Api
          .getUserPlaylistsRoute, // Ruta definida en la API: "/v1/me/playlists"
      headers: {"Authorization": "Bearer $token"},
      parameters: {
        "limit": "20", // Límite configurable de playlists a recuperar
        "market": language,
      },
      onSuccess: (data) {
        _setLocalPlaylists(data: data);
        _playlistsInitialized = true;
        notifyListeners();
      },
    );
  }

  /// Procesa la respuesta de la API y mapea los datos en instancias de [PlaylistModel]
  void _setLocalPlaylists({required Map<String, dynamic> data}) {
    // Se espera que la respuesta tenga la propiedad "items" conteniendo la lista de playlists
    List<dynamic> items = data["items"] ?? [];
    List<PlaylistModel> generatedList = List<PlaylistModel>.generate(
      items.length,
      (index) => PlaylistModel.fromJson(data: items[index]),
    );

    // Se añade cada playlist a la lista, evitando duplicados
    for (var playlist in generatedList) {
      if (!_playlists.any((pl) => pl.id == playlist.id)) {
        _playlists.add(playlist);
      }
    }
  }

  /// Cambia el estado de favorito de una playlist dada por su [playlistId]
  void changePlaylistFavoriteStatus({
    required String playlistId,
    required bool isFavorite,
  }) {
    final playlist = _playlists.firstWhereOrNull((pl) => pl.id == playlistId);
    if (playlist != null) {
      playlist.favorite = isFavorite;
      notifyListeners();
    }
  }
}
