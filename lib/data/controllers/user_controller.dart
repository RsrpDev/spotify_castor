import 'package:flutter/material.dart';
import 'package:spotify_castor/data/api/api_spotify.dart';
import 'package:spotify_castor/data/models/user_model.dart';

class UserController extends Api with ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  void initUser({required String token, required Function onSuccess}) {
    _getCurrentUser(
      token: token,
      onSuccess: (data) {
        _setCurrentUser(data: data);
        onSuccess();
      },
    );
  }

  void _getCurrentUser({
    required String token,
    required Function(Map<String, dynamic> data) onSuccess,
  }) {
    getQuery(
      route: Api.getUserRoute,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (data) {
        onSuccess(data);
      },
    );
  }

  void _setCurrentUser({required Map<String, dynamic> data}) {
    _currentUser = UserModel.fromJson(data: data);
    notifyListeners();
  }
}
