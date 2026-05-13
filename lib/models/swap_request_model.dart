class SwapRequestModel {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String? fromUserAvatar;
  final String toUserId;
  final String toUserName;
  final String? toUserAvatar;
  final String skillOffered;
  final String skillRequested;
  final String status;
  final int timeCredits;
  final String? message;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  SwapRequestModel({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    this.fromUserAvatar,
    required this.toUserId,
    required this.toUserName,
    this.toUserAvatar,
    required this.skillOffered,
    required this.skillRequested,
    this.status = 'pending',
    this.timeCredits = 1,
    this.message,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory SwapRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return SwapRequestModel(
      id: docId,
      fromUserId: map['fromUserId'] as String? ?? '',
      fromUserName: map['fromUserName'] as String? ?? '',
      fromUserAvatar: map['fromUserAvatar'] as String?,
      toUserId: map['toUserId'] as String? ?? '',
      toUserName: map['toUserName'] as String? ?? '',
      toUserAvatar: map['toUserAvatar'] as String?,
      skillOffered: map['skillOffered'] as String? ?? '',
      skillRequested: map['skillRequested'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      timeCredits: map['timeCredits'] as int? ?? 1,
      message: map['message'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['createdAt'] as dynamic).millisecondsSinceEpoch)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['updatedAt'] as dynamic).millisecondsSinceEpoch)
          : null,
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['completedAt'] as dynamic).millisecondsSinceEpoch)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,
      'fromUserAvatar': fromUserAvatar,
      'toUserId': toUserId,
      'toUserName': toUserName,
      'toUserAvatar': toUserAvatar,
      'skillOffered': skillOffered,
      'skillRequested': skillRequested,
      'status': status,
      'timeCredits': timeCredits,
      'message': message,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'completedAt': completedAt,
    };
  }

  SwapRequestModel copyWith({
    String? id, String? fromUserId, String? fromUserName, String? fromUserAvatar,
    String? toUserId, String? toUserName, String? toUserAvatar,
    String? skillOffered, String? skillRequested, String? status,
    int? timeCredits, String? message,
    DateTime? createdAt, DateTime? updatedAt, DateTime? completedAt,
  }) {
    return SwapRequestModel(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      fromUserName: fromUserName ?? this.fromUserName,
      fromUserAvatar: fromUserAvatar ?? this.fromUserAvatar,
      toUserId: toUserId ?? this.toUserId,
      toUserName: toUserName ?? this.toUserName,
      toUserAvatar: toUserAvatar ?? this.toUserAvatar,
      skillOffered: skillOffered ?? this.skillOffered,
      skillRequested: skillRequested ?? this.skillRequested,
      status: status ?? this.status,
      timeCredits: timeCredits ?? this.timeCredits,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isCompleted => status == 'completed';
  bool get isRejected => status == 'rejected';
}
