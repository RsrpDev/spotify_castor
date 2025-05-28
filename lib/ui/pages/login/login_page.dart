import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spotify_castor/data/controllers/session_controller.dart';
import 'package:spotify_castor/ui/global/buttons/primary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x77555555), Color(0xff121212), Color(0xff121212)],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "lib/assets/svg/common/spotify_icon_no_fill.svg",
                    width: 120,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 120),
                    child: Text(
                      "Spotify Castor",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Consumer<SessionController>(
                          builder: (context, sessionController, child) =>
                              PrimaryButton(
                                onPressed: () {
                                  sessionController.signIn();
                                },
                                icon: SvgPicture.asset(
                                  "lib/assets/svg/common/spotify_icon_no_fill.svg",
                                  width: 120,
                                ),
                                label: "Login to Spotify-Castor",
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
