import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_castor/data/controllers/favorites_controller.dart';
import 'package:spotify_castor/data/controllers/playlist_controller.dart';
import 'package:spotify_castor/data/controllers/session_controller.dart';
import 'package:spotify_castor/data/models/playlist_model.dart';
import 'package:spotify_castor/ui/global/items/playlist_item.dart';
import 'package:spotify_castor/utils/render_utils.dart';

class PlaylistGridSection extends StatelessWidget {
  const PlaylistGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      SessionController,
      PlaylistController,
      FavoritesController
    >(
      builder:
          (
            context,
            sessionController,
            playlistController,
            favoritesController,
            child,
          ) {
            final List<PlaylistModel> playlists = playlistController.playlists;
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                // Título de la sección.
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Text(
                          "Your Playlists",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: RenderUtils().groupCountedWidgetsByRow(
                      widgets: List<PlaylistItem>.generate(
                        playlists.length,
                        (index) => PlaylistItem(
                          playlist: playlists[index],
                          onFavoriteInitialized: (playlistId, isFavorite) {
                            playlistController.changePlaylistFavoriteStatus(
                              playlistId: playlistId,
                              isFavorite: isFavorite,
                            );
                          },
                          onFavoriteChanged: (playlistId) {
                            final currentFav =
                                playlists[index].favorite ?? false;
                            playlistController.changePlaylistFavoriteStatus(
                              playlistId: playlistId,
                              isFavorite: !currentFav,
                            );
                            favoritesController.getUserFavoritePlaylists(
                              token: sessionController.token,
                              offset: 0,
                            );
                          },
                        ),
                      ),
                      widgetsPerRow: 2,
                    ),
                  ),
                ),
              ],
            );
          },
    );
  }
}
