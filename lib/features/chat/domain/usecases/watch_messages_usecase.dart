import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class WatchMessagesUseCase {
  final ChatRepository _repository;
  WatchMessagesUseCase(this._repository);

  //FIXED BUG 4:
  Stream<List<Message>> call(String productId) {
    return _repository.watchMessages(productId);
  }
}
