class ReviewModel {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String? fromUserAvatar;
  final String toUserId;
  final String toUserName;
  final String swapRequestId;
  final int rating; // 1-5
  final String? comment;
  final List<String> tags; // e.g., ['patient', 'knowledgeable', 'on_time']
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    this.fromUserAvatar,
    required this.toUserId,
    required this.toUserName,
    required this.swapRequestId,
    required this.rating,
    this.comment,
    this.tags = const [],
    required this.createdAt,
  });

  static DateTime? _parseDT(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try { return (value as dynamic).toDate() as DateTime; } catch (_) {}
    try { return DateTime.fromMillisecondsSinceEpoch((value as dynamic).millisecondsSinceEpoch as int); } catch (_) {}
    return null;
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReviewModel(
      id: docId,
      fromUserId: map['fromUserId'] as String? ?? '',
      fromUserName: map['fromUserName'] as String? ?? '',
      fromUserAvatar: map['fromUserAvatar'] as String?,
      toUserId: map['toUserId'] as String? ?? '',
      toUserName: map['toUserName'] as String? ?? '',
      swapRequestId: map['swapRequestId'] as String? ?? '',
      rating: map['rating'] as int? ?? 5,
      comment: map['comment'] as String?,
      tags: List<String>.from(map['tags'] as List? ?? []),
      createdAt: _parseDT(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,
      'fromUserAvatar': fromUserAvatar,
      'toUserId': toUserId,
      'toUserName': toUserName,
      'swapRequestId': swapRequestId,
      'rating': rating,
      'comment': comment,
      'tags': tags,
      'createdAt': createdAt,
    };
  }
}
