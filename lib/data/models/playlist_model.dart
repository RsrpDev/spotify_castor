class PlaylistModel {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  bool? favorite;
  final String spotifyUri;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    this.favorite,
    required this.spotifyUri,
  });

  factory PlaylistModel.fromJson({required Map<String, dynamic> data}) {
    String uri = "";
    if (data.containsKey('external_urls') && data['external_urls'] != null) {
      uri = data['external_urls']['spotify'] ?? "";
    }
    return PlaylistModel(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String? ?? "",
      images: (data['images'] as List<dynamic>)
          .map((img) => img['url'] as String)
          .toList(),
      favorite: null, // No inicializado
      spotifyUri: uri,
    );
  }
}
