class GroupSessionModel {
  final String id;
  final String hostId;
  final String hostName;
  final String? hostAvatar;
  final String title;
  final String? description;
  final String skill;
  final int maxParticipants;
  final List<String> participantIds;
  final List<String> participantNames;
  final int creditsPerParticipant;
  final DateTime scheduledAt;
  final int durationMinutes;
  final String status; // upcoming, live, completed, cancelled
  final DateTime createdAt;

  GroupSessionModel({
    required this.id,
    required this.hostId,
    required this.hostName,
    this.hostAvatar,
    required this.title,
    this.description,
    required this.skill,
    this.maxParticipants = 5,
    this.participantIds = const [],
    this.participantNames = const [],
    this.creditsPerParticipant = 1,
    required this.scheduledAt,
    this.durationMinutes = 60,
    this.status = 'upcoming',
    required this.createdAt,
  });

  static DateTime? _parseDT(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try { return (value as dynamic).toDate() as DateTime; } catch (_) {}
    try { return DateTime.fromMillisecondsSinceEpoch((value as dynamic).millisecondsSinceEpoch as int); } catch (_) {}
    return null;
  }

  factory GroupSessionModel.fromMap(Map<String, dynamic> map, String docId) {
    return GroupSessionModel(
      id: docId,
      hostId: map['hostId'] as String? ?? '',
      hostName: map['hostName'] as String? ?? '',
      hostAvatar: map['hostAvatar'] as String?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      skill: map['skill'] as String? ?? '',
      maxParticipants: map['maxParticipants'] as int? ?? 5,
      participantIds: List<String>.from(map['participantIds'] as List? ?? []),
      participantNames: List<String>.from(map['participantNames'] as List? ?? []),
      creditsPerParticipant: map['creditsPerParticipant'] as int? ?? 1,
      scheduledAt: _parseDT(map['scheduledAt']) ?? DateTime.now(),
      durationMinutes: map['durationMinutes'] as int? ?? 60,
      status: map['status'] as String? ?? 'upcoming',
      createdAt: _parseDT(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hostId': hostId,
      'hostName': hostName,
      'hostAvatar': hostAvatar,
      'title': title,
      'description': description,
      'skill': skill,
      'maxParticipants': maxParticipants,
      'participantIds': participantIds,
      'participantNames': participantNames,
      'creditsPerParticipant': creditsPerParticipant,
      'scheduledAt': scheduledAt,
      'durationMinutes': durationMinutes,
      'status': status,
      'createdAt': createdAt,
    };
  }

  int get spotsLeft => maxParticipants - participantIds.length;
  bool get isFull => spotsLeft <= 0;
  bool get isUpcoming => status == 'upcoming';
}
