class CoverArt {
  String id;
  String filename;
  String description;
  String? volume;
  DateTime createdAt;
  DateTime updatedAt;
  int version;

  CoverArt({
    required this.id,
    required this.filename,
    required this.description,
    required this.volume,
    required this.createdAt,
    required this.updatedAt,
    required this.version
  });

  @override
  String toString() {
    return 'CoverArt{id: $id, filename: $filename, description: $description, volume: $volume, createdAt: $createdAt, updatedAt: $updatedAt, version: $version}';
  }
}
