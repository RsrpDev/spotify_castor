import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spotify_castor/data/controllers/session_controller.dart';
import 'package:app_links/app_links.dart';

class NavigatorController with ChangeNotifier {
  StreamSubscription? deepLinkNavigationListener;
  final AppLinks _appLinks = AppLinks();

  void initDeepLinkListener() {
    deepLinkNavigationListener = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        debugPrint("DeepLink uri: $uri");

        switch (uri.host) {
          case "":
            Navigator.of(
              Get.context!,
            ).pushNamedAndRemoveUntil("splash", (route) => false);
            break;
          case "sign":
            Provider.of<SessionController>(
              Get.context!,
              listen: false,
            ).processSignAuthCode(authCode: uri.queryParameters["code"]!);
            break;
          default:
            return;
        }
      }
    });
  }
}
