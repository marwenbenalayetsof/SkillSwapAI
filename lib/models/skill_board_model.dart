class SkillBoardModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String type; // 'offer' or 'request'
  final String skill;
  final String? description;
  final List<String> tags;
  final int responseCount;
  final DateTime createdAt;

  SkillBoardModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.type,
    required this.skill,
    this.description,
    this.tags = const [],
    this.responseCount = 0,
    required this.createdAt,
  });

  static DateTime? _parseDT(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try { return (value as dynamic).toDate() as DateTime; } catch (_) {}
    try { return DateTime.fromMillisecondsSinceEpoch((value as dynamic).millisecondsSinceEpoch as int); } catch (_) {}
    return null;
  }

  factory SkillBoardModel.fromMap(Map<String, dynamic> map, String docId) {
    return SkillBoardModel(
      id: docId,
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? '',
      userAvatar: map['userAvatar'] as String?,
      type: map['type'] as String? ?? 'offer',
      skill: map['skill'] as String? ?? '',
      description: map['description'] as String?,
      tags: List<String>.from(map['tags'] as List? ?? []),
      responseCount: map['responseCount'] as int? ?? 0,
      createdAt: _parseDT(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'type': type,
      'skill': skill,
      'description': description,
      'tags': tags,
      'responseCount': responseCount,
      'createdAt': createdAt,
    };
  }
}
