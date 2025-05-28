import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_castor/data/controllers/favorites_controller.dart';
import 'package:spotify_castor/data/controllers/session_controller.dart';
import 'package:spotify_castor/data/models/playlist_model.dart';
import 'package:spotify_castor/ui/global/media/image_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaylistItem extends StatefulWidget {
  final PlaylistModel playlist;
  final Function(String playlistId, bool isFavorite) onFavoriteInitialized;
  final Function(String playlistId) onFavoriteChanged;

  const PlaylistItem({
    super.key,
    required this.playlist,
    required this.onFavoriteInitialized,
    required this.onFavoriteChanged,
  });

  @override
  State<PlaylistItem> createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<PlaylistItem> {
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.playlist.spotifyUri.isNotEmpty) {
          debugPrint("Launching Uri: ${widget.playlist.spotifyUri}");
          launchUrl(Uri.parse(widget.playlist.spotifyUri));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Material(
                  color: const Color(0xff1e1e1e),
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias,
                  child: widget.playlist.images.isNotEmpty
                      ? ImageLoader(imageUrl: widget.playlist.images.first)
                      : const Icon(
                          Icons.image_not_supported_rounded,
                          size: 56,
                          color: Colors.white12,
                        ),
                ),
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: Material(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xff2A2A2A),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Consumer2<SessionController, FavoritesController>(
                      builder:
                          (
                            context,
                            sessionController,
                            favoritesController,
                            child,
                          ) {
                            if (!initialized) {
                              initialized = true;

                              if (widget.playlist.favorite == null) {
                                favoritesController.checkFavoritePlaylist(
                                  token: sessionController.token,
                                  playlistId: widget.playlist.id,
                                  onSuccess: (bool isFavorite) {
                                    widget.onFavoriteInitialized(
                                      widget.playlist.id,
                                      isFavorite,
                                    );
                                  },
                                );
                              }
                            }

                            final isFav = widget.playlist.favorite ?? false;
                            return IconButton(
                              onPressed: () {
                                if (isFav) {
                                  favoritesController.removeFavoritePlaylist(
                                    token: sessionController.token,
                                    playlistId: widget.playlist.id,
                                    onSuccess: () {
                                      widget.onFavoriteChanged(
                                        widget.playlist.id,
                                      );
                                    },
                                  );
                                } else {
                                  favoritesController.addFavoritePlaylist(
                                    token: sessionController.token,
                                    playlistId: widget.playlist.id,
                                    playlistData: widget.playlist,
                                    onSuccess: () {
                                      widget.onFavoriteChanged(
                                        widget.playlist.id,
                                      );
                                    },
                                  );
                                }
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                maxWidth: 40,
                                maxHeight: 40,
                              ),
                              icon: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline_rounded,
                                color: isFav ? Colors.green : Colors.grey,
                              ),
                            );
                          },
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 3),
            child: Text(
              widget.playlist.name,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Text(
            widget.playlist.description,
            maxLines: 1,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
