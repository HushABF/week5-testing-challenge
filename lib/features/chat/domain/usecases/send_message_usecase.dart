import '../repositories/chat_repository.dart';

class MessageException implements Exception {
  final String message;
  const MessageException(this.message);
}

class SendMessageUseCase {
  final ChatRepository _repository;
  SendMessageUseCase(this._repository);

  // FIX: Was allowing empty/whitespace messages to reach Firestore,
  // creating empty chat bubbles that could never be deleted.
  Future<void> call(
      String productId, String text, String senderUsername) async {
    if (text.trim().isEmpty) {
      throw MessageException('Message can not be empty');
    }
    await _repository.sendMessage(productId, text, senderUsername);
  }
}
