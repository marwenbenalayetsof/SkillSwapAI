class ChatMessageModel {
  final String id;
  final String roomId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final String type; // text, image, swap_request, system
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    this.type = 'text',
    required this.createdAt,
  });

  static DateTime? _parseDT(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try { return (value as dynamic).toDate() as DateTime; } catch (_) {}
    try { return DateTime.fromMillisecondsSinceEpoch((value as dynamic).millisecondsSinceEpoch as int); } catch (_) {}
    return null;
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatMessageModel(
      id: docId,
      roomId: map['roomId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      senderAvatar: map['senderAvatar'] as String?,
      content: map['content'] as String? ?? '',
      type: map['type'] as String? ?? 'text',
      createdAt: _parseDT(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'type': type,
      'createdAt': createdAt,
    };
  }

  bool get isText => type == 'text';
  bool get isSystem => type == 'system';
}
