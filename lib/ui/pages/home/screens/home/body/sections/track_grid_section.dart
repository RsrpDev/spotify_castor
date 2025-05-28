import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_castor/data/controllers/favorites_controller.dart';
import 'package:spotify_castor/data/controllers/session_controller.dart';
import 'package:spotify_castor/data/models/track_model.dart';
import 'package:spotify_castor/ui/global/items/track_item.dart';
import 'package:spotify_castor/utils/render_utils.dart';

class FavoriteTrackGridSection extends StatelessWidget {
  const FavoriteTrackGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionController, FavoritesController>(
      builder: (context, sessionController, favoritesController, child) {
        final List<TrackModel> tracks = favoritesController.favoriteTracks;

        final limitedTracks = tracks.take(4).toList();

        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Favorite Tracks",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: RenderUtils().groupCountedWidgetsByRow(
                  widgets: List<TrackItem>.generate(
                    limitedTracks.length,
                    (index) => TrackItem(
                      track: limitedTracks[index],
                      onFavoriteInitialized: (trackId, isFavorite) {},
                      onFavoriteChanged: (trackId) {
                        final currentFav =
                            limitedTracks[index].favorite ?? false;
                        if (currentFav) {
                          favoritesController.removeFavoriteTrack(
                            token: sessionController.token,
                            trackId: trackId,
                            onSuccess: () {},
                          );
                        } else {
                          favoritesController.addFavoriteTrack(
                            token: sessionController.token,
                            trackId: trackId,
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
