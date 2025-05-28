import 'package:flutter/material.dart';
import 'package:spotify_castor/data/api/api_spotify.dart';
import 'package:spotify_castor/data/models/playlist_model.dart';
import 'package:spotify_castor/data/models/track_model.dart';
import 'package:spotify_castor/data/models/album_model.dart';
import 'package:spotify_castor/data/models/artist_model.dart';

class FavoritesController extends Api with ChangeNotifier {
  List<TrackModel> _favoriteTracks = [];
  int _totalAvailableFavoriteTracks = 0;

  List<TrackModel> get favoriteTracks => _favoriteTracks;
  int get totalAvailableFavoriteTracks => _totalAvailableFavoriteTracks;

  List<ArtistModel> _favoriteArtists = [];
  int _totalAvailableFavoriteArtists = 0;

  List<ArtistModel> get favoriteArtists => _favoriteArtists;
  int get totalAvailableFavoriteArtists => _totalAvailableFavoriteArtists;

  List<AlbumModel> _favoriteAlbums = [];
  int _totalAvailableFavoriteAlbums = 0;

  List<AlbumModel> get favoriteAlbums => _favoriteAlbums;
  int get totalAvailableFavoriteAlbums => _totalAvailableFavoriteAlbums;

  List<PlaylistModel> _favoritePlaylists = [];
  int _totalAvailableFavoritePlaylists = 0;

  List<PlaylistModel> get favoritePlaylists => _favoritePlaylists;
  int get totalAvailableFavoritePlaylists => _totalAvailableFavoritePlaylists;

  bool _favoritesInitialized = false;

  bool get favoritesInitialized => _favoritesInitialized;

  void initFavorites({required String token, required String language}) {
    _favoritesInitialized = true;

    getUserFavoriteTracks(token: token);
    getUserFavoriteArtists(token: token);
    getUserFavoriteAlbums(token: token);
  }

  void getUserFavoriteTracks({required String token, int? offset}) {
    getQuery(
      route: Api.userFavoriteTracksRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {
        "time_range": "medium_term",
        "limit": "20",
        "offset": "${offset ?? _favoriteTracks.length}",
      },
      onSuccess: (data) {
        _totalAvailableFavoriteTracks = data["total"];

        List<TrackModel> fetchedItems = List<TrackModel>.generate(
          data["items"].length,
          (index) {
            data["items"][index]["track"].addAll({"favorite": true});
            return TrackModel.fromJson(data: data["items"][index]["track"]);
          },
        );

        if (offset == null) {
          for (var item in fetchedItems) {
            if (!_favoriteTracks.any((artist) => artist.id == item.id)) {
              _favoriteTracks.add(item);
            }
          }
        } else {
          _favoriteTracks = fetchedItems;
        }

        notifyListeners();
      },
    );
  }

  void getUserFavoriteArtists({required String token, bool? empty}) {
    getQuery(
      route: Api.userFavoriteArtistsRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {
        "type": "artist",
        "limit": "20",
        if ((empty == null || !empty) && (_favoriteArtists.isNotEmpty))
          "after": _favoriteArtists.last.id,
      },
      onSuccess: (data) {
        _totalAvailableFavoriteArtists = data["artists"]["total"];

        List<ArtistModel> fetchedItems = List<ArtistModel>.generate(
          data["artists"]["items"].length,
          (index) {
            data["artists"]["items"][index].addAll({"favorite": true});
            return ArtistModel.fromJson(data: data["artists"]["items"][index]);
          },
        );

        if (empty == null) {
          for (var item in fetchedItems) {
            if (!_favoriteArtists.any((artist) => artist.id == item.id)) {
              _favoriteArtists.add(item);
            }
          }
        } else {
          _favoriteArtists = fetchedItems;
        }

        notifyListeners();
      },
    );
  }

  void getUserFavoriteAlbums({required String token, int? offset}) {
    getQuery(
      route: Api.userFavoriteAlbumsRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {
        "limit": "20",
        "offset": "${offset ?? _favoriteAlbums.length}",
      },
      onSuccess: (data) {
        _totalAvailableFavoriteAlbums = data["total"];

        List<AlbumModel> fetchedItems = List<AlbumModel>.generate(
          data["items"].length,
          (index) {
            data["items"][index]["album"].addAll({"favorite": true});
            return AlbumModel.fromJson(data: data["items"][index]["album"]);
          },
        );

        if (offset == null) {
          for (var item in fetchedItems) {
            if (!_favoriteAlbums.any((artist) => artist.id == item.id)) {
              _favoriteAlbums.add(item);
            }
          }
        } else {
          _favoriteAlbums = fetchedItems;
        }

        notifyListeners();
      },
    );
  }

  void addFavoriteTrack({
    required String token,
    required String trackId,
    required Function onSuccess,
  }) {
    putQuery(
      route: Api.userFavoriteTracksRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {"ids": trackId},
      onSuccess: (_) {
        onSuccess();
      },
    );
  }

  void addFavoriteArtist({
    required String token,
    required String artistId,
    required Function onSuccess,
  }) {
    putQuery(
      route: Api.userFavoriteArtistsRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {"type": "artist", "ids": artistId},
      onSuccess: (_) {
        onSuccess();
      },
    );
  }

  void addFavoriteAlbum({
    required String token,
    required String albumId,
    required Function onSuccess,
  }) {
    putQuery(
      route: Api.userFavoriteAlbumsRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {"ids": albumId},
      onSuccess: (_) {
        onSuccess();
      },
    );
  }

  void checkFavoriteTrack({
    required String token,
    required String trackId,
    required Function(bool isFavorite) onSuccess,
  }) {
    getQuery(
      route: Api.checkFavoriteTrackRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {"ids": trackId},
      onSuccess: (data) {
        onSuccess(data["response"].first);
      },
    );
  }

  void checkFavoriteArtist({
    required String token,
    required String artistId,
    required Function(bool isFavorite) onSuccess,
  }) {
    getQuery(
      route: Api.checkFavoriteArtistRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {"type": "artist", "ids": artistId},
      onSuccess: (data) {
        onSuccess(data["response"].first);
      },
    );
  }

  void checkFavoriteAlbum({
    required String token,
    required String albumId,
    required Function(bool isFavorite) onSuccess,
  }) {
    getQuery(
      route: Api.checkFavoriteAlbumRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {"ids": albumId},
      onSuccess: (data) {
        onSuccess(data["response"].first);
      },
    );
  }

  void removeFavoriteTrack({
    required String token,
    required String trackId,
    required Function onSuccess,
  }) {
    deleteQuery(
      route: Api.userFavoriteTracksRoute,
      headers: {"Authorization": "Bearer $token"},
      parameters: {"ids": trackId},
      onSuccess: (_) {
        if (_favoriteTracks.any((track) => track.id == trackId)) {
          _favoriteTracks.removeWhere((track) => track.id == trackId);

          notifyListeners();

          if (_favoriteTracks.length < 20 &&
              _favoriteTracks.length < _totalAvailableFavoriteTracks) {
            getUserFavoriteTracks(token: token);
          }
        }

        onSuccess();
      },
    );
  }

  void removeFavoriteArtist({
    required String token,
    required String artistId,
    required Function onSuccess,
  }) {
    deleteQuery(
      route: Api.userFavoriteArtistsRoute,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      parameters: {"type": "artist", "ids": artistId},
      onSuccess: (_) {
        if (_favoriteArtists.any((artist) => artist.id == artistId)) {
          _favoriteArtists.removeWhere((artist) => artist.id == artistId);

          notifyListeners();

          if (_favoriteArtists.length < 20 &&
              _favoriteArtists.length < _totalAvailableFavoriteArtists) {
            getUserFavoriteArtists(token: token);
          }
        }

        onSuccess();
      },
    );
  }

  void removeFavoriteAlbum({
    required String token,
    required String albumId,
    required Function onSuccess,
  }) {
    deleteQuery(
      route: Api.userFavoriteAlbumsRoute,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      parameters: {"ids": albumId},
      onSuccess: (_) {
        if (_favoriteAlbums.any((album) => album.id == albumId)) {
          _favoriteAlbums.removeWhere((album) => album.id == albumId);

          notifyListeners();

          if (_favoriteAlbums.length < 20 &&
              _favoriteAlbums.length < _totalAvailableFavoriteAlbums) {
            getUserFavoriteAlbums(token: token);
          }
        }

        onSuccess();
      },
    );
  }

  void checkFavoritePlaylist({
    required String token,
    required String playlistId,
    required Function(bool isFavorite) onSuccess,
  }) {
    // Se busca si la playlist con el ID proporcionado está en la lista de favoritas
    bool isFav = _favoritePlaylists.any(
      (playlist) => playlist.id == playlistId,
    );
    onSuccess(isFav);
  }

  void getUserFavoritePlaylists({required String token, int? offset}) {
    getQuery(
      route: Api.getUserPlaylistsRoute, // O la ruta correspondiente.
      headers: {"Authorization": "Bearer $token"},
      parameters: {
        "limit": "20",
        "offset": "${offset ?? _favoritePlaylists.length}",
      },
      onSuccess: (data) {
        _totalAvailableFavoritePlaylists = data["total"];
        List<PlaylistModel> fetchedItems = List<PlaylistModel>.generate(
          data["items"].length,
          (index) => PlaylistModel.fromJson(data: data["items"][index]),
        );
        // La lógica de actualización de la lista puede ser:
        if (offset == null) {
          for (var item in fetchedItems) {
            if (!_favoritePlaylists.any((playlist) => playlist.id == item.id)) {
              _favoritePlaylists.add(item);
            }
          }
        } else {
          _favoritePlaylists = fetchedItems;
        }
        notifyListeners();
      },
    );
  }

  void addFavoritePlaylist({
    required String token,
    required String playlistId,
    required PlaylistModel playlistData,
    required Function onSuccess,
  }) {
    putQuery(
      route: "/v1/playlists/$playlistId/followers",
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (_) {
        // Agregamos el modelo completo si aún no está en la lista.
        if (!_favoritePlaylists.any((playlist) => playlist.id == playlistId)) {
          _favoritePlaylists.add(playlistData);
        }
        notifyListeners();
        onSuccess();
      },
    );
  }

  void removeFavoritePlaylist({
    required String token,
    required String playlistId,
    required Function onSuccess,
  }) {
    deleteQuery(
      route: "/v1/playlists/$playlistId/followers",
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (_) {
        _favoritePlaylists.removeWhere((playlist) => playlist.id == playlistId);
        notifyListeners();
        onSuccess();
      },
    );
  }
}
