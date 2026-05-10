// TODO: Write your tests here for SendMessageUseCase
//
// Your test file must cover:
// 1. Calling with valid text calls the repository exactly once with correct args
// 2. Calling with an empty string throws a MessageException
//    AND the repository is never called
// 3. Calling with whitespace-only text (e.g. '   ') throws a MessageException
//    AND the repository is never called
//
// Follow the TDD cycle:
//   Step 1 — Write the test
//   Step 2 — Run it and confirm it FAILS
//   Step 3 — Fix the bug in send_message_usecase.dart
//   Step 4 — Run again and confirm it PASSES

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week5_testing_challenge/features/chat/domain/repositories/chat_repository.dart';
import 'package:week5_testing_challenge/features/chat/domain/usecases/send_message_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepository;
  late SendMessageUseCase sendMessageUseCase;

  setUp(() {
    mockRepository = MockChatRepository();
    sendMessageUseCase = SendMessageUseCase(mockRepository);
  });

  // Write your tests below this line

// 1. Calling with valid text calls the repository exactly once with correct args
  test(
      'Calling with valid text calls the repository exactly once with correct args',
      () async {
    when(
      () => mockRepository.sendMessage('1', 'test message', 'ahmed'),
    ).thenAnswer((_) async {});

    await sendMessageUseCase.call('1', 'test message', 'ahmed');

    verify(
      () => mockRepository.sendMessage('1', 'test message', 'ahmed'),
    ).called(1);
  });

// 2. Calling with an empty string throws a MessageException
//    AND the repository is never called

  test(
      'Calling with an empty string throws a MessageException AND the repository is never called',
      () async {
    await expectLater(
        () async => await sendMessageUseCase.call('1', '', 'ahmed'),
        throwsA(isA<MessageException>()));

    verifyNever(
      () => mockRepository.sendMessage(any(), any(), any()),
    );
  });

// 3. Calling with whitespace-only text (e.g. '   ') throws a MessageException
//    AND the repository is never called

  test(
      'Calling with whitespace-only text (e.g. "   ") throws a MessageException AND the repository is never called',
      () async {
    await expectLater(
        () async => await sendMessageUseCase.call('1', '     ', 'ahmed'),
        throwsA(isA<MessageException>()));

    verifyNever(
      () => mockRepository.sendMessage(any(), any(), any()),
    );
  });
}
