// TODO: Write your tests here for WatchMessagesUseCase
//
// Your test file must cover:
// 1. Calling with productId 'product-42' passes exactly 'product-42'
//    to the repository — NOT an empty string
// 2. The stream returned by the use case is the same stream
//    the repository returns (no transformation)
// 3. Calling with two different productIds calls the repository
//    with each respective id, not a shared hardcoded value
//
// Follow the TDD cycle:
//   Step 1 — Write the test
//   Step 2 — Run it and confirm it FAILS
//   Step 3 — Fix the bug in watch_messages_usecase.dart
//   Step 4 — Run again and confirm it PASSES

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week5_testing_challenge/features/chat/domain/entities/message.dart';
import 'package:week5_testing_challenge/features/chat/domain/repositories/chat_repository.dart';
import 'package:week5_testing_challenge/features/chat/domain/usecases/watch_messages_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepository;
  late WatchMessagesUseCase watchMessagesUseCase;

  setUp(() {
    mockRepository = MockChatRepository();
    watchMessagesUseCase = WatchMessagesUseCase(mockRepository);
  });

  // Write your tests below this line

// 1. Calling with productId 'product-42' passes exactly 'product-42'
//    to the repository — NOT an empty string
  test(
      "Calling with productId 'product-42' passes exactly 'product-42' to the repository",
      () {
    when(
      () => mockRepository.watchMessages('product-42'),
    ).thenAnswer((_) => Stream.value(<Message>[]));

    watchMessagesUseCase.call('product-42');

    verify(() => mockRepository.watchMessages('product-42')).called(1);
  });

// 2. The stream returned by the use case is the same stream
//    the repository returns (no transformation)

  test(
      'The stream returned by the use case is the same stream, the repository returns (no transformation)',
      () async {
    Stream<List<Message>> stream = Stream.value(<Message>[]);
    when(
      () => mockRepository.watchMessages('1'),
    ).thenAnswer((_) => stream);

    final result = watchMessagesUseCase.call('1');

    expect(result, same(stream));
  });

// 3. Calling with two different productIds calls the repository
//    with each respective id, not a shared hardcoded value

  test(
      'Calling with two different productIds calls the repository with each respective id, not a shared hardcoded value',
      () async {
    when(
      () => mockRepository.watchMessages('1'),
    ).thenAnswer((_) => Stream.value(<Message>[]));

    when(
      () => mockRepository.watchMessages('2'),
    ).thenAnswer((_) => Stream.value(<Message>[]));

    watchMessagesUseCase.call('1');
    watchMessagesUseCase.call('2');

    verify(
      () => mockRepository.watchMessages('1'),
    ).called(1);

    verify(
      () => mockRepository.watchMessages('2'),
    ).called(1);
  });
}
