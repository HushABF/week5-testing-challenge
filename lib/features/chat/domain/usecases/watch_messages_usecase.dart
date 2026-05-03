import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class WatchMessagesUseCase {
  final ChatRepository _repository;
  WatchMessagesUseCase(this._repository);

  // BUG 4:
  // This use case always passes an empty string to the repository
  // instead of the actual productId it receives.
  // Every chat room ends up watching the same empty-string collection,
  // meaning all products share one chat and product filtering is completely broken.
  Stream<List<Message>> call(String productId) {
    return _repository.watchMessages('');
  }
}
