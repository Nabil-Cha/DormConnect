import 'activity_category.dart';

class Activity {
  final int              id;
  final String           title;
  final String           description;
  final DateTime         startDate;
  final DateTime?        endDate;
  final int?             maxParticipants;
  final String           location;
  final String?          image;
  final DateTime?        createdAt;
  final List<String>     participants;
  final String           community;
  final int              communityId;
  final String           category;
  final bool             isActive;

  static const String defaultImageUrl = 'assets/images/placeholder.png';

  int get participantCount => participants.length;

  String get imageUrl => image ?? defaultImageUrl;

  ActivityCategory? get categoryEnum => activityFromCategory(category);

  const Activity({
    required this.id,
    required this.title,
    this.description = '',
    required this.startDate,
    this.endDate,
    this.maxParticipants,
    required this.location,
    this.image,
    this.createdAt,
    this.participants = const [],
    required this.community,
    required this.communityId,
    required this.category,
    this.isActive = true,
  });

  factory Activity.forCreation({
    required String title,
    String description = '',
    required DateTime startDate,
    DateTime? endDate,
    int? maxParticipants,
    required String location,
    String? image,
    required String community,
    required int communityId,
    required String category,
  }) {
    return Activity(
      id: 0,
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      maxParticipants: maxParticipants,
      location: location,
      image: image,
      createdAt: null,
      participants: const [],
      community: community,
      communityId: communityId,
      category: category,
      isActive: true,
    );
  }

  factory Activity.fromMap(Map<String, dynamic> data) {
    return Activity(
      id: data['id'] is int
          ? data['id'] as int
          : int.parse(data['id'].toString()),
      title: data['title'] as String,
      description: (data['description'] ?? '') as String,
      startDate: data['start_date'] != null
          ? DateTime.parse(data['start_date'].toString())
          : throw ArgumentError('start_date is required but was null'),
      endDate: data['end_date'] != null
          ? DateTime.parse(data['end_date'].toString())
          : null,
      maxParticipants: data['max_participants'] as int?,
      location: data['location'] as String,
      image: data['image'] as String?,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'].toString())
          : null,
      participants: (data['participants'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? const [],
      community: data['community'] as String,
      communityId: data['community_id'] is int
          ? data['community_id'] as int
          : int.parse(data['community_id'].toString()),
      category: data['category'] as String,
      isActive: data['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    if (id != 0) 'id': id,
    'title': title,
    'description': description,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate?.toIso8601String(),
    'max_participants': maxParticipants,
    'location': location,
    'image': image,
    'created_at': createdAt?.toIso8601String(),
    'participants': participants,
    'community': community,
    'community_id': communityId,
    'category': category,
    'is_active': isActive,
  };

  Activity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? maxParticipants,
    String? location,
    String? image,
    DateTime? createdAt,
    List<String>? participants,
    String? community,
    int? communityId,
    String? category,
    bool? isActive,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      location: location ?? this.location,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      participants: participants ?? this.participants,
      community: community ?? this.community,
      communityId: communityId ?? this.communityId,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
    );
  }

  Activity addParticipant(String participantId) {
    if (participants.contains(participantId)) return this;
    return copyWith(participants: [...participants, participantId]);
  }

  Activity removeParticipant(String participantId) {
    return copyWith(participants: participants.where((p) => p != participantId).toList());
  }

  bool get isFull => maxParticipants != null && participantCount >= maxParticipants!;

  bool get hasStarted => DateTime.now().isAfter(startDate);

  bool get hasEnded => endDate != null && DateTime.now().isAfter(endDate!);

  @override
  String toString() {
    return 'Activity(id: $id, title: $title, participantCount: $participantCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Activity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}