class ImageTag {
  final String id;
  final String name;
  final String description;
  final bool deleted;

  ImageTag({
    required this.id, 
    required this.name, 
    required this.description,
    required this.deleted,
  });

  ImageTag copyWith({
    String? id,
    String? name,
    String? description,
    bool? deleted,
  }) {
    return ImageTag(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      deleted: deleted ?? this.deleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'deleted': deleted,
    };
  }

  factory ImageTag.fromMap({
    
    required String id,
    required Map<String, dynamic> map
  }) {
    return ImageTag(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String,
      deleted: map['deleted'] as bool,
    );
  }
}
