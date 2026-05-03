import '../entities/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> watchMessages(String productId);
  Future<void> sendMessage(String productId, String text, String senderUsername);
}
