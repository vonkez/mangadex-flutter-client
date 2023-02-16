class Author {
  String id;
  String name;
  String? imageUrl;
  String? biography;
  DateTime createdAt;
  DateTime updatedAt;
  int version;

  Author({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.biography,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  @override
  String toString() {
    return 'Author{id: $id, name: $name, imageUrl: $imageUrl, biography: $biography, createdAt: $createdAt, updatedAt: $updatedAt, version: $version}';
  }
}
