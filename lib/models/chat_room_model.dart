class ChatRoomModel {
  final String id;
  final List<String> participants;
  final Map<String, String> participantNames;
  final Map<String, String?> participantAvatars;
  final String? lastMessage;
  final String? lastSenderName;
  final DateTime? lastMessageTime;
  final Map<String, int> unreadCount;
  final String? swapRequestId;
  final DateTime createdAt;

  ChatRoomModel({
    required this.id,
    required this.participants,
    this.participantNames = const {},
    this.participantAvatars = const {},
    this.lastMessage,
    this.lastSenderName,
    this.lastMessageTime,
    this.unreadCount = const {},
    this.swapRequestId,
    required this.createdAt,
  });

  static DateTime? _parseDT(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try { return (value as dynamic).toDate() as DateTime; } catch (_) {}
    try { return DateTime.fromMillisecondsSinceEpoch((value as dynamic).millisecondsSinceEpoch as int); } catch (_) {}
    return null;
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatRoomModel(
      id: docId,
      participants: List<String>.from(map['participants'] as List? ?? []),
      participantNames: Map<String, String>.from(map['participantNames'] as Map? ?? {}),
      participantAvatars: Map<String, String?>.from(map['participantAvatars'] as Map? ?? {}),
      lastMessage: map['lastMessage'] as String?,
      lastSenderName: map['lastSenderName'] as String?,
      lastMessageTime: _parseDT(map['lastMessageTime']),
      unreadCount: Map<String, int>.from(map['unreadCount'] as Map? ?? {}),
      swapRequestId: map['swapRequestId'] as String?,
      createdAt: _parseDT(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'participantNames': participantNames,
      'participantAvatars': participantAvatars,
      'lastMessage': lastMessage,
      'lastSenderName': lastSenderName,
      'lastMessageTime': lastMessageTime,
      'unreadCount': unreadCount,
      'swapRequestId': swapRequestId,
      'createdAt': createdAt,
    };
  }
}
