import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_castor/data/controllers/favorites_controller.dart';
import 'package:spotify_castor/data/controllers/playlist_controller.dart';
import 'package:spotify_castor/data/controllers/session_controller.dart';
import 'package:spotify_castor/data/controllers/user_controller.dart';
import 'package:spotify_castor/ui/global/animations/loader_animation.dart';
import 'package:spotify_castor/ui/global/media/image_loader.dart';
import 'package:spotify_castor/ui/pages/home/screens/home/body/sections/album_grid_section.dart';
import 'package:spotify_castor/ui/pages/home/screens/home/body/sections/artist_grid_section.dart';
import 'package:spotify_castor/ui/pages/home/screens/home/body/sections/playlist_grid_section.dart';
import 'package:spotify_castor/ui/pages/home/screens/home/body/sections/track_grid_section.dart';

class HomePageHomeScreenBody extends StatefulWidget {
  const HomePageHomeScreenBody({super.key});

  @override
  State<HomePageHomeScreenBody> createState() => _HomePageHomeScreenBodyState();
}

class _HomePageHomeScreenBodyState extends State<HomePageHomeScreenBody> {
  bool initialized = false;
  bool hasFavoritesContent = false;
  bool hasPlaylistsContent = false;

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      SessionController,
      FavoritesController,
      PlaylistController
    >(
      builder:
          (
            context,
            sessionController,
            favoritesController,
            playlistController,
            child,
          ) {
            // Inicializamos los favoritos si aún no se han cargado
            if (!favoritesController.favoritesInitialized) {
              favoritesController.initFavorites(
                token: sessionController.token,
                language: sessionController.language,
              );
            }

            if (!hasFavoritesContent &&
                (favoritesController.favoriteTracks.isNotEmpty ||
                    favoritesController.favoriteArtists.isNotEmpty ||
                    favoritesController.favoriteAlbums.isNotEmpty)) {
              hasFavoritesContent = true;
            }

            // Una vez cargados los favoritos, se inicializan las playlists
            if (hasFavoritesContent && !initialized) {
              initialized = true;
              playlistController.initializePlaylists(
                token: sessionController.token,
                language: sessionController.language,
              );
            }

            // Se marca que ya hay playlists listos
            if (playlistController.playlistsInitialized &&
                (!hasPlaylistsContent &&
                    playlistController.playlists.isNotEmpty)) {
              hasPlaylistsContent = true;
            }

            return Column(
              children: [
                Consumer<UserController>(
                  builder: (context, userController, child) => Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 4,
                      right: 12,
                      bottom: 4,
                      left: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff727272),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Consumer<UserController>(
                              builder: (context, userController, child) =>
                                  ImageLoader(
                                    imageUrl:
                                        userController.currentUser!.avatarUrl,
                                  ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: EdgeInsets.only(
                              top: hasPlaylistsContent ? 12 : 128,
                              right: hasPlaylistsContent ? 12 : 48,
                              bottom: hasPlaylistsContent ? 12 : 120,
                              left: hasPlaylistsContent ? 12 : 0,
                            ),
                            alignment: hasPlaylistsContent
                                ? Alignment.centerLeft
                                : Alignment.center,
                            child: Text(
                              userController.currentUser!.displayName,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Muestra un loader hasta que las playlists se hayan inicializado
                !playlistController.playlistsInitialized
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: LoaderAnimation(),
                        ),
                      )
                    : Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(top: 8, bottom: 64),
                          children: hasPlaylistsContent
                              ? [
                                  // Se usan ambas secciones para mostrar las playlists en distintos formatos
                                  PlaylistGridSection(),
                                  FavoriteAlbumGridSection(),
                                  FavoriteArtistGridSection(),
                                  FavoriteTrackGridSection(),
                                ]
                              : [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      "We have no playlists for you, try creating one or add some to your library.",
                                      maxLines: 4,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(height: 1.6),
                                    ),
                                  ),
                                ],
                        ),
                      ),
              ],
            );
          },
    );
  }
}
