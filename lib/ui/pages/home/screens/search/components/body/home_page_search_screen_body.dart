import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_castor/data/controllers/favorites_controller.dart';
import 'package:spotify_castor/data/controllers/search_media_controller.dart';
import 'package:spotify_castor/data/controllers/session_controller.dart';
import 'package:spotify_castor/ui/global/animations/loader_animation.dart';
import 'package:spotify_castor/ui/pages/home/screens/search/components/body/sections/albums_search_results_section.dart';
import 'package:spotify_castor/ui/pages/home/screens/search/components/body/sections/artists_search_results_section.dart';
import 'package:spotify_castor/ui/pages/home/screens/search/components/body/sections/tracks_search_results_section.dart';

class HomePageSearchScreenBody extends StatelessWidget {
  final bool isRequestedSearchEmpty;

  const HomePageSearchScreenBody({
    super.key,
    required this.isRequestedSearchEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      SessionController,
      SearchMediaController,
      FavoritesController
    >(
      builder:
          (
            context,
            sessionController,
            searchMediaController,
            favoritesController,
            child,
          ) {
            if (isRequestedSearchEmpty) {
              return SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      right: 8,
                      bottom: 8,
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Search artists, albums and tracks",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (searchMediaController.isSearching) {
              return const SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: LoaderAnimation(),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView(
                padding: const EdgeInsets.only(top: 8, bottom: 56),
                children: [
                  if (searchMediaController.tracks.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: TracksSearchResultsSection(),
                    ),
                  if (searchMediaController.artists.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: ArtistsSearchResultsSection(),
                    ),
                  if (searchMediaController.albums.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: AlbumsSearchResultsSection(),
                    ),
                ],
              );
            }
          },
    );
  }
}
