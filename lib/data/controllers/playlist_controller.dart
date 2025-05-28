import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_castor/data/api/api_spotify.dart';
import 'package:spotify_castor/data/models/playlist_model.dart';

class PlaylistController extends Api with ChangeNotifier {
  final List<PlaylistModel> _playlists = [];
  List<PlaylistModel> get playlists => _playlists;

  bool _playlistsInitialized = false;
  bool get playlistsInitialized => _playlistsInitialized;

  void initializePlaylists({required String token, required String language}) {
    _playlistsInitialized = false;
    _playlists.clear();

    _getUserPlaylists(token: token, language: language);
  }

  void _getUserPlaylists({required String token, required String language}) {
    getQuery(
      route: Api.getUserPlaylistsRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {"limit": "20", "market": language},
      onSuccess: (data) {
        _setLocalPlaylists(data: data);
        _playlistsInitialized = true;
        notifyListeners();
      },
    );
  }

  void _setLocalPlaylists({required Map<String, dynamic> data}) {
    List<dynamic> items = data["items"] ?? [];
    List<PlaylistModel> generatedList = List<PlaylistModel>.generate(
      items.length,
      (index) => PlaylistModel.fromJson(data: items[index]),
    );

    for (var playlist in generatedList) {
      if (!_playlists.any((pl) => pl.id == playlist.id)) {
        _playlists.add(playlist);
      }
    }
  }

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
