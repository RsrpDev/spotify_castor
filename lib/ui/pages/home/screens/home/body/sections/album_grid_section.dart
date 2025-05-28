import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_castor/data/controllers/favorites_controller.dart';
import 'package:spotify_castor/data/controllers/session_controller.dart';
import 'package:spotify_castor/data/models/album_model.dart';
import 'package:spotify_castor/ui/global/items/album_item.dart';
import 'package:spotify_castor/utils/render_utils.dart';

class FavoriteAlbumGridSection extends StatelessWidget {
  const FavoriteAlbumGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionController, FavoritesController>(
      builder: (context, sessionController, favoritesController, child) {
        final List<AlbumModel> albums = favoritesController.favoriteAlbums;
        // Limitar a 4 elementos
        final limitedAlbums = albums.take(4).toList();

        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            // Título de la sección
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Favorite Albums",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: RenderUtils().groupCountedWidgetsByRow(
                  widgets: List<AlbumItem>.generate(
                    limitedAlbums.length,
                    (index) => AlbumItem(
                      album: limitedAlbums[index],
                      onFavoriteInitialized: (albumId, isFavorite) {
                        // Lógica opcional de inicialización
                      },
                      onFavoriteChanged: (albumId) {
                        final currentFav =
                            limitedAlbums[index].favorite ?? false;
                        if (currentFav) {
                          favoritesController.removeFavoriteAlbum(
                            token: sessionController.token,
                            albumId: albumId,
                            onSuccess: () {},
                          );
                        } else {
                          favoritesController.addFavoriteAlbum(
                            token: sessionController.token,
                            albumId: albumId,
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
