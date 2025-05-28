import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Api {
  static const String clientId = '5a21d6153c6d40e3bcc3232853d70a0b';
  static const String clientSecret = '041898c541384f4ebfcffc95bdf8aa9d';
  static const String redirectUri = "spotifycastor://sign";
  static const String authDomain = "accounts.spotify.com";
  static const String scope =
      "user-read-private user-read-email user-library-read user-library-modify user-follow-read user-follow-modify user-top-read user-read-recently-played playlist-read-private playlist-modify-public playlist-modify-private";
  static Map<String, String> basicAuthScheme = {
    "content-type": "application/x-www-form-urlencoded",
    "Authorization":
        "Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}",
  };

  static Map<String, String> refreshAuthScheme = {
    "Content-Type": "application/x-www-form-urlencoded",
  };

  static const String _apiDomain = "api.spotify.com";

  static const String getTokenRoute = "/api/token";
  static const String refreshTokenRoute = "/api/token";

  static const String getUserRoute = "/v1/me";

  static const String getPlaylistDetailsRoute = "/v1/playlists";

  static const String searchMediaRoute = "/v1/search";

  static const String userFavoriteTracksRoute = "/v1/me/tracks";
  static const String userFavoriteArtistsRoute = "/v1/me/following";
  static const String userFavoriteAlbumsRoute = "/v1/me/albums";

  static const String checkFavoriteTrackRoute = "/v1/me/tracks/contains";
  static const String checkFavoriteArtistRoute = "v1/me/following/contains";
  static const String checkFavoriteAlbumRoute = "/v1/me/albums/contains";

  static const String getUserPlaylistsRoute = "/v1/me/playlists";

  void showProcessingDialog() {
    showDialog(
      context: Get.context!,
      barrierColor: Theme.of(
        Get.context!,
      ).scaffoldBackgroundColor.withValues(alpha: 0.8),
      builder: (context) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void closeProcessingDialog() {
    Navigator.of(Get.context!).pop();
  }

  void showErrorPage() {
    Navigator.of(
      Get.context!,
    ).pushNamedAndRemoveUntil("error", (route) => false);
  }

  Map<String, dynamic> _dataParser({required String body}) {
    Map<String, dynamic> data = {};

    if (body.isNotEmpty) {
      dynamic fetchedData = jsonDecode(body);

      if (fetchedData is Map<String, dynamic>) {
        data = fetchedData;
      } else {
        data = {"response": fetchedData};
      }
    } else {
      data = {"response": "Empty or null response "};
    }

    return data;
  }

  Future<void> getQuery({
    String? domain,
    required String route,
    Map<String, dynamic>? parameters,
    Map<String, String>? headers,
    Function? onStart,
    required Function(Map<String, dynamic> data) onSuccess,
    Function? onComplete,
  }) async {
    debugPrint("Get Route: $route");
    debugPrint("Parameters: $parameters");
    debugPrint("Headers: $headers");

    try {
      onStart?.call();

      await http
          .get(
            Uri.https(domain ?? _apiDomain, route, parameters),
            headers: headers,
          )
          .then((response) async {
            debugPrint("Get '$route' response status: ${response.statusCode}");
            debugPrint("Get '$route' response: ${response.body}");

            if (response.statusCode == 200 || response.statusCode == 204) {
              onSuccess(
                _dataParser(body: response.body.isEmpty ? "" : response.body),
              );
            } else {
              showErrorPage();
            }
          })
          .whenComplete(() {
            onComplete?.call();
          });
    } catch (e) {
      debugPrint(e.toString());
      showErrorPage();
    }
  }

  Future<void> postQuery({
    String? domain,
    required String route,
    Map<String, dynamic>? parameters,
    Map<String, String>? headers,
    Function? onStart,
    required Function(Map<String, dynamic> data) onSuccess,
    Function? onComplete,
  }) async {
    debugPrint("Post Route: $route");
    debugPrint("Parameters: $parameters");
    debugPrint("Headers: $headers");

    try {
      onStart?.call();

      await http
          .post(
            Uri.https(domain ?? _apiDomain, route, parameters),
            headers: headers,
          )
          .then((response) async {
            debugPrint("Post '$route' response status: ${response.statusCode}");
            debugPrint("Post '$route' response: ${response.body}");

            if (response.statusCode == 200 || response.statusCode == 204) {
              onSuccess(
                _dataParser(body: response.body.isEmpty ? "" : response.body),
              );
            } else {
              showErrorPage();
            }
          })
          .whenComplete(() {
            onComplete?.call();
          });
    } catch (e) {
      debugPrint(e.toString());
      showErrorPage();
    }
  }

  Future<void> putQuery({
    String? domain,
    required String route,
    Map<String, dynamic>? parameters,
    Map<String, String>? headers,
    Function? onStart,
    required Function(Map<String, dynamic> data) onSuccess,
    Function? onComplete,
  }) async {
    debugPrint("Post Route: $route");
    debugPrint("Parameters: $parameters");
    debugPrint("Headers: $headers");

    try {
      onStart?.call();

      await http
          .put(
            Uri.https(domain ?? _apiDomain, route, parameters),
            headers: headers,
          )
          .then((response) async {
            debugPrint("Post '$route' response status: ${response.statusCode}");
            debugPrint("Post '$route' response: ${response.body}");

            if (response.statusCode == 200 || response.statusCode == 204) {
              onSuccess(
                _dataParser(body: response.body.isEmpty ? "" : response.body),
              );
            } else {
              showErrorPage();
            }
          })
          .whenComplete(() {
            onComplete?.call();
          });
    } catch (e) {
      debugPrint(e.toString());
      showErrorPage();
    }
  }

  Future<void> deleteQuery({
    String? domain,
    required String route,
    Map<String, dynamic>? parameters,
    Map<String, String>? headers,
    Function? onStart,
    required Function(Map<String, dynamic> data) onSuccess,
    Function? onComplete,
  }) async {
    debugPrint("Delete Route: $route");
    debugPrint("Parameters: $parameters");
    debugPrint("Headers: $headers");

    try {
      onStart?.call();

      await http
          .delete(
            Uri.https(domain ?? _apiDomain, route, parameters),
            headers: headers,
          )
          .then((response) async {
            debugPrint(
              "Delete '$route' response status: ${response.statusCode}",
            );
            debugPrint("Delete '$route' response: ${response.body}");

            if (response.statusCode == 200 || response.statusCode == 204) {
              onSuccess(
                _dataParser(body: response.body.isEmpty ? "" : response.body),
              );
            } else {
              showErrorPage();
            }
          })
          .whenComplete(() {
            onComplete?.call();
          });
    } catch (e) {
      debugPrint(e.toString());
      showErrorPage();
    }
  }
}
