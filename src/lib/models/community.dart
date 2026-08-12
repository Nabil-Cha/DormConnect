import 'package:collection/collection.dart';

class Community {
  final int          id;
  final String       name;
  final String       location;
  final String?      image;
  final DateTime     createdOn;
  final List<String> members;
  final String       slug;
  final int          memberCount;

  const Community({
    required this.id,
    required this.name,
    required this.location,
    required this.createdOn,
    this.image,
    this.members = const [],
    this.slug = '',
    this.memberCount = 0,
  });

  factory Community.fromMap(Map<String, dynamic> row) {
    return Community(
      id          : row['id'] is int
          ? row['id'] as int
          : int.parse(row['id'].toString()),
      name        : row['name']          as String,
      location    : row['location']      as String,
      image       : row['image']         as String?,
      createdOn   : DateTime.parse(row['created_on'].toString()),
      members     : (row['members'] as List<dynamic>?)
          ?.map((e) => e.toString()).toList()
          ?? const [],
      slug        : row['slug']          as String? ?? '',
      memberCount : row['member_count']  as int?    ?? 0,
    );
  }

  Map<String, dynamic> toMap({bool forInsert = false}) {
    return {
      if (!forInsert) 'id' : id,
      'name'         : name,
      'location'     : location,
      'image'        : image,
      'created_on'   : createdOn.toIso8601String(),
      'members'      : members,
      if (!forInsert) 'slug'         : slug,
      if (!forInsert) 'member_count' : memberCount,
    };
  }

  Community copyWith({
    int?          id,
    String?       name,
    String?       location,
    String?       image,
    DateTime?     createdOn,
    List<String>? members,
    String?       slug,
    int?          memberCount,
  }) {
    return Community(
      id          : id          ?? this.id,
      name        : name        ?? this.name,
      location    : location    ?? this.location,
      image       : image       ?? this.image,
      createdOn   : createdOn   ?? this.createdOn,
      members     : members     ?? this.members,
      slug        : slug        ?? this.slug,
      memberCount : memberCount ?? this.memberCount,
    );
  }

  @override
  String toString() =>
      'Community(id:$id, name:$name, members:$memberCount)';

  @override
  bool operator ==(Object o) =>
      identical(this, o) ||
          o is Community &&
              id == o.id &&
              name == o.name &&
              location == o.location &&
              image == o.image &&
              createdOn == o.createdOn &&
              slug == o.slug &&
              memberCount == o.memberCount &&
              const ListEquality().equals(members, o.members);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      location.hashCode ^
      image.hashCode ^
      createdOn.hashCode ^
      slug.hashCode ^
      memberCount.hashCode ^
      members.hashCode;

  int get memberCountComputed => members.length;
}
