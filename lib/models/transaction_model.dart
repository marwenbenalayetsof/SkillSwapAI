class TransactionModel {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String type; // swap_earn, swap_spend, bonus, gift
  final int amount;
  final String? swapRequestId;
  final String? description;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.type,
    required this.amount,
    this.swapRequestId,
    this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String docId) {
    return TransactionModel(
      id: docId,
      fromUserId: map['fromUserId'] as String? ?? '',
      toUserId: map['toUserId'] as String? ?? '',
      type: map['type'] as String? ?? 'swap_earn',
      amount: map['amount'] as int? ?? 0,
      swapRequestId: map['swapRequestId'] as String?,
      description: map['description'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['createdAt'] as dynamic).millisecondsSinceEpoch)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'type': type,
      'amount': amount,
      'swapRequestId': swapRequestId,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
