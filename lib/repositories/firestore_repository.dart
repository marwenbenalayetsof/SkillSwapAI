import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/swap_request_model.dart';
import '../models/chat_room_model.dart';
import '../models/chat_message_model.dart';
import '../models/review_model.dart';
import '../models/transaction_model.dart';
import '../models/skill_board_model.dart';
import '../models/group_session_model.dart';

class FirestoreRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static bool _isAvailable = true;
  static bool get isAvailable => _isAvailable;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).set({...user.toMap(), 'createdAt': FieldValue.serverTimestamp()});
    } catch (e) { _isAvailable = false; rethrow; }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.exists ? UserModel.fromMap(doc.data()!) : null;
    } catch (e) { _isAvailable = false; return null; }
  }

  Future<void> updateUser(UserModel user) async {
    try { await _db.collection('users').doc(user.uid).update(user.toMap()); }
    catch (e) { _isAvailable = false; }
  }

  Stream<List<UserModel>> getAllUsers() {
    return _db.collection('users').snapshots().map((s) => s.docs.map((d) => UserModel.fromMap(d.data())).toList()).handleError((_) { _isAvailable = false; });
  }

  Stream<UserModel?> getUserStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((d) => d.exists ? UserModel.fromMap(d.data()!) : null).handleError((_) { _isAvailable = false; });
  }

  Future<String> createSwapRequest(SwapRequestModel request) async {
    try {
      final ref = await _db.collection('swap_requests').add({...request.toMap(), 'createdAt': FieldValue.serverTimestamp()});
      return ref.id;
    } catch (e) { _isAvailable = false; rethrow; }
  }

  Future<void> updateSwapStatus(String requestId, String status) async {
    try {
      final data = {'status': status, 'updatedAt': FieldValue.serverTimestamp()};
      if (status == 'completed') data['completedAt'] = FieldValue.serverTimestamp();
      await _db.collection('swap_requests').doc(requestId).update(data);
    } catch (e) { _isAvailable = false; }
  }

  Stream<List<SwapRequestModel>> getSwapRequests(String userId) {
    return _db.collection('swap_requests')
        .where(Filter.or(Filter('fromUserId', isEqualTo: userId), Filter('toUserId', isEqualTo: userId)))
        .orderBy('createdAt', descending: true)
        .snapshots().map((s) => s.docs.map((d) => SwapRequestModel.fromMap(d.data(), d.id)).toList()).handleError((_) { _isAvailable = false; });
  }

  Future<String> createChatRoom(ChatRoomModel room) async {
    try {
      final ref = await _db.collection('chat_rooms').add({...room.toMap(), 'createdAt': FieldValue.serverTimestamp()});
      return ref.id;
    } catch (e) { _isAvailable = false; rethrow; }
  }

  Stream<List<ChatRoomModel>> getChatRooms(String userId) {
    return _db.collection('chat_rooms').where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots().map((s) => s.docs.map((d) => ChatRoomModel.fromMap(d.data(), d.id)).toList()).handleError((_) { _isAvailable = false; });
  }

  Future<void> sendMessage(ChatMessageModel message) async {
    try {
      await _db.collection('chat_rooms').doc(message.roomId).collection('messages').add({...message.toMap(), 'createdAt': FieldValue.serverTimestamp()});
      await _db.collection('chat_rooms').doc(message.roomId).update({'lastMessage': message.content, 'lastSenderName': message.senderName, 'lastMessageTime': FieldValue.serverTimestamp()});
    } catch (e) { _isAvailable = false; }
  }

  Stream<List<ChatMessageModel>> getMessages(String roomId) {
    return _db.collection('chat_rooms').doc(roomId).collection('messages')
        .orderBy('createdAt', descending: false).limitToLast(100)
        .snapshots().map((s) => s.docs.map((d) => ChatMessageModel.fromMap(d.data(), d.id)).toList()).handleError((_) { _isAvailable = false; });
  }

  Future<void> createReview(ReviewModel review) async {
    try {
      await _db.collection('reviews').add({...review.toMap(), 'createdAt': FieldValue.serverTimestamp()});
      final reviews = await _db.collection('reviews').where('toUserId', isEqualTo: review.toUserId).get();
      if (reviews.docs.isNotEmpty) {
        double avg = reviews.docs.map((d) => (d.data()['rating'] as num).toDouble()).reduce((a, b) => a + b) / reviews.size;
        await _db.collection('users').doc(review.toUserId).update({'rating': avg, 'reviewCount': reviews.size});
      }
    } catch (e) { _isAvailable = false; }
  }

  Stream<List<ReviewModel>> getUserReviews(String userId) {
    return _db.collection('reviews').where('toUserId', isEqualTo: userId).orderBy('createdAt', descending: true)
        .snapshots().map((s) => s.docs.map((d) => ReviewModel.fromMap(d.data(), d.id)).toList()).handleError((_) { _isAvailable = false; });
  }

  Future<void> createTransaction(TransactionModel tx) async {
    try { await _db.collection('transactions').add({...tx.toMap(), 'createdAt': FieldValue.serverTimestamp()}); }
    catch (e) { _isAvailable = false; }
  }

  Stream<List<TransactionModel>> getUserTransactions(String userId) {
    return _db.collection('transactions')
        .where(Filter.or(Filter('fromUserId', isEqualTo: userId), Filter('toUserId', isEqualTo: userId)))
        .orderBy('createdAt', descending: true).limit(50)
        .snapshots().map((s) => s.docs.map((d) => TransactionModel.fromMap(d.data(), d.id)).toList()).handleError((_) { _isAvailable = false; });
  }

  Future<void> createBoardPost(SkillBoardModel post) async {
    try { await _db.collection('skill_boards').add({...post.toMap(), 'createdAt': FieldValue.serverTimestamp()}); }
    catch (e) { _isAvailable = false; }
  }

  Stream<List<SkillBoardModel>> getBoardPosts() {
    return _db.collection('skill_boards').orderBy('createdAt', descending: true).limit(50)
        .snapshots().map((s) => s.docs.map((d) => SkillBoardModel.fromMap(d.data(), d.id)).toList()).handleError((_) { _isAvailable = false; });
  }

  Future<String> createGroupSession(GroupSessionModel session) async {
    try {
      final ref = await _db.collection('group_sessions').add({...session.toMap(), 'createdAt': FieldValue.serverTimestamp()});
      return ref.id;
    } catch (e) { _isAvailable = false; rethrow; }
  }

  Stream<List<GroupSessionModel>> getGroupSessions() {
    return _db.collection('group_sessions').orderBy('scheduledAt', descending: false)
        .snapshots().map((s) => s.docs.map((d) => GroupSessionModel.fromMap(d.data(), d.id)).toList()).handleError((_) { _isAvailable = false; });
  }

  Future<void> joinGroupSession(String sessionId, String userId, String userName) async {
    try {
      await _db.collection('group_sessions').doc(sessionId).update({
        'participantIds': FieldValue.arrayUnion([userId]),
        'participantNames': FieldValue.arrayUnion([userName]),
      });
    } catch (e) { _isAvailable = false; }
  }

  Future<bool> checkAvailability() async {
    try { await _db.collection('users').limit(1).get(); _isAvailable = true; return true; }
    catch (e) { _isAvailable = false; return false; }
  }
}
