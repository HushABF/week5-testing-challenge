// TODO: Write your BLoC tests here for ChatBloc
//
// Your test file must cover:
// 1. WatchMessages event emits ChatLoaded when the stream emits messages
// 2. WatchMessages event emits ChatError when the stream emits an error
// 3. SendMessage with valid text calls the use case and emits no extra state
// 4. SendMessage with empty text emits ChatError (after the use case fix)
// 5. After close() is called, no further states are emitted when
//    the stream emits new messages (subscription is cancelled)

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week5_testing_challenge/features/chat/domain/entities/message.dart';
import 'package:week5_testing_challenge/features/chat/domain/repositories/chat_repository.dart';
import 'package:week5_testing_challenge/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:week5_testing_challenge/features/chat/domain/usecases/watch_messages_usecase.dart';
import 'package:week5_testing_challenge/features/chat/presentation/bloc/chat_bloc.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepository;
  late WatchMessagesUseCase watchMessagesUseCase;
  late SendMessageUseCase sendMessageUseCase;

  final fakeMessages = [
    Message(
      id: 'msg-1',
      productId: 'product-42',
      senderUsername: 'User_1234',
      text: 'Is this available?',
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  setUp(() {
    mockRepository = MockChatRepository();
    watchMessagesUseCase = WatchMessagesUseCase(mockRepository);
    sendMessageUseCase = SendMessageUseCase(mockRepository);
  });

  // Write your tests below this line
}
