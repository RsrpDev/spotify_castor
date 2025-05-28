import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_castor/data/controllers/favorites_controller.dart';
import 'package:spotify_castor/data/controllers/session_controller.dart';
import 'package:spotify_castor/data/models/album_model.dart';
import 'package:spotify_castor/ui/global/media/image_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class AlbumItem extends StatefulWidget {
  final AlbumModel album;
  final Function(String albumId, bool isFavorite) onFavoriteInitialized;
  final Function(String albumId) onFavoriteChanged;

  const AlbumItem({
    super.key,
    required this.album,
    required this.onFavoriteInitialized,
    required this.onFavoriteChanged,
  });

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("Launching Uri: ${widget.album.spotifyUri}");

        launchUrl(Uri.parse(widget.album.spotifyUri));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ...List.generate(
                3,
                (index) => AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: index * 8,
                      right: 16 - index * 8,
                      bottom: 16 - index * 8,
                      left: index * 8,
                    ),
                    child: Material(
                      color: const Color(0xff1e1e1e),
                      borderRadius: BorderRadius.circular(8),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Transform.scale(
                            scale: 1 + (index * 2),
                            child: widget.album.coverUrl != null
                                ? ImageLoader(imageUrl: widget.album.coverUrl!)
                                : index == 0
                                ? const Icon(
                                    Icons.image_not_supported_rounded,
                                    size: 56,
                                    color: Colors.white12,
                                  )
                                : null,
                          ),
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).reversed,
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

                              if (widget.album.favorite == null) {
                                favoritesController.checkFavoriteAlbum(
                                  token: sessionController.token,
                                  albumId: widget.album.id,
                                  onSuccess: (isFavorite) {
                                    widget.onFavoriteInitialized(
                                      widget.album.id,
                                      isFavorite,
                                    );
                                  },
                                );
                              }
                            }

                            return IconButton(
                              onPressed: widget.album.favorite != null
                                  ? () {
                                      if (widget.album.favorite!) {
                                        favoritesController.removeFavoriteAlbum(
                                          token: sessionController.token,
                                          albumId: widget.album.id,
                                          onSuccess: () {
                                            widget.onFavoriteChanged(
                                              widget.album.id,
                                            );
                                          },
                                        );
                                      } else {
                                        favoritesController.addFavoriteAlbum(
                                          token: sessionController.token,
                                          albumId: widget.album.id,
                                          onSuccess: () {
                                            widget.onFavoriteChanged(
                                              widget.album.id,
                                            );
                                          },
                                        );
                                      }
                                    }
                                  : null,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                maxWidth: 40,
                                maxHeight: 40,
                              ),
                              icon: Icon(
                                color: widget.album.favorite != null
                                    ? widget.album.favorite!
                                          ? Colors.green
                                          : Colors.grey
                                    : const Color(0xff606060),
                                widget.album.favorite != null
                                    ? widget.album.favorite!
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_outline_rounded
                                    : Icons.favorite_rounded,
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
              widget.album.name,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Text(
            widget.album.artists.join(", "),
            maxLines: 1,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.album.releaseYear ?? "",
              maxLines: 1,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
