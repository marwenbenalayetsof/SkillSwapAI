import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';
import '../models/chat_room_model.dart';
import 'user_provider.dart';
import '../models/chat_message_model.dart';
import 'user_provider.dart';
import 'auth_provider.dart';
import 'user_provider.dart';

final chatRoomsProvider = StreamProvider<List<ChatRoomModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  return ref.read(firestoreRepositoryProvider).getChatRooms(user.uid);
});

final chatMessagesProvider = StreamProvider.family<List<ChatMessageModel>, String>((ref, roomId) {
  return ref.read(firestoreRepositoryProvider).getMessages(roomId);
});
