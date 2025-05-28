import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_castor/data/controllers/favorites_controller.dart';
import 'package:spotify_castor/data/controllers/session_controller.dart';
import 'package:spotify_castor/data/models/artist_model.dart';
import 'package:spotify_castor/ui/global/items/artist_item.dart';
import 'package:spotify_castor/utils/render_utils.dart';

class FavoriteArtistGridSection extends StatelessWidget {
  const FavoriteArtistGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionController, FavoritesController>(
      builder: (context, sessionController, favoritesController, child) {
        final List<ArtistModel> artists = favoritesController.favoriteArtists;
        // Limitar a 4 elementos
        final limitedArtists = artists.take(4).toList();

        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            // Título de la sección
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Favorite Artists",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: RenderUtils().groupCountedWidgetsByRow(
                  widgets: List<ArtistItem>.generate(
                    limitedArtists.length,
                    (index) => ArtistItem(
                      artist: limitedArtists[index],
                      onFavoriteInitialized: (artistId, isFavorite) {
                        // Lógica de inicialización si es necesario
                      },
                      onFavoriteChanged: (artistId) {
                        final currentFav =
                            limitedArtists[index].favorite ?? false;
                        if (currentFav) {
                          favoritesController.removeFavoriteArtist(
                            token: sessionController.token,
                            artistId: artistId,
                            onSuccess: () {},
                          );
                        } else {
                          favoritesController.addFavoriteArtist(
                            token: sessionController.token,
                            artistId: artistId,
                            onSuccess: () {},
                          );
                        }
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
