import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class WatchMessagesUseCase {
  final ChatRepository _repository;
  WatchMessagesUseCase(this._repository);

  // FIX: Was hardcoding an empty string instead of passing the actual productId,
  // causing all chat rooms to share one stream and breaking product filtering.
  Stream<List<Message>> call(String productId) {
    return _repository.watchMessages(productId);
  }
}
