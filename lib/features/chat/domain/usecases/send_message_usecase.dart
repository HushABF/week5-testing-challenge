import '../repositories/chat_repository.dart';

class MessageException implements Exception {
  final String message;
  const MessageException(this.message);
}

class SendMessageUseCase {
  final ChatRepository _repository;
  SendMessageUseCase(this._repository);

  // BUG 3:
  // This use case should throw a MessageException when the message text
  // is empty or contains only whitespace BEFORE calling the repository.
  // Currently it allows blank messages to be saved to Firestore,
  // creating empty chat bubbles that can never be deleted.
  Future<void> call(String productId, String text, String senderUsername) async {
    await _repository.sendMessage(productId, text, senderUsername);
  }
}
