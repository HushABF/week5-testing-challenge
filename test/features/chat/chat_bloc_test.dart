// TODO: Write your BLoC tests here for ChatBloc
//
// Your test file must cover:
// 1. WatchMessages event emits ChatLoaded when the stream emits messages
// 2. WatchMessages event emits ChatError when the stream emits an error
// 3. SendMessage with valid text calls the use case and emits no extra state
// 4. SendMessage with empty text emits ChatError (after the use case fix)
// 5. After close() is called, no further states are emitted when
//    the stream emits new messages (subscription is cancelled)

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week5_testing_challenge/features/chat/domain/entities/message.dart';
import 'package:week5_testing_challenge/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:week5_testing_challenge/features/chat/domain/usecases/watch_messages_usecase.dart';
import 'package:week5_testing_challenge/features/chat/presentation/bloc/chat_bloc.dart';

class MockWatchMessagesUseCase extends Mock implements WatchMessagesUseCase {}

class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}

void main() {
  late MockWatchMessagesUseCase mockWatchMessages;
  late MockSendMessageUseCase mockSendMessage;
  late ChatBloc chatBloc;
  late StreamController<List<Message>> controller;

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
    mockWatchMessages = MockWatchMessagesUseCase();
    mockSendMessage = MockSendMessageUseCase();
    chatBloc = ChatBloc(
      watchMessages: mockWatchMessages,
      sendMessage: mockSendMessage,
    );
  });

  // Write your tests below this line

// 1. WatchMessages event emits ChatLoaded when the stream emits messages

  blocTest(
    'WatchMessages event emits ChatLoaded when the stream emits messages',
    setUp: () {
      when(
        () => mockWatchMessages.call('1'),
      ).thenAnswer((_) => Stream.value(fakeMessages));
    },
    build: () => chatBloc,
    act: (bloc) => bloc.add(WatchMessages('1')),
    expect: () => [ChatLoaded(fakeMessages)],
  );

// 2. WatchMessages event emits ChatError when the stream emits an error

  blocTest(
    'WatchMessages event emits ChatError when the stream emits an error',
    setUp: () {
      when(
        () => mockWatchMessages.call(any()),
      ).thenAnswer((_) => Stream.error(Exception('Something wrong happened')));
    },
    build: () => chatBloc,
    act: (bloc) => bloc.add(WatchMessages('1')),
    expect: () => [isA<ChatError>()],
  );

// 3. SendMessage with valid text calls the use case and emits no extra state
  blocTest(
    'SendMessage with valid text calls the use case and emits no extra state',
    setUp: () {
      when(
        () => mockSendMessage.call(
            'product-42', 'Is this available?', 'User_1234'),
      ).thenAnswer((_) async {});
    },
    build: () => chatBloc,
    act: (bloc) =>
        bloc.add(SendMessage('product-42', 'Is this available?', 'User_1234')),
    expect: () => [],
  );

// 4. SendMessage with empty text emits ChatError

  blocTest(
    'SendMessage with empty text emits ChatError',
    setUp: () {
      when(
        () => mockSendMessage.call('product-42', '', 'User_1234'),
      ).thenThrow(MessageException('Something wrong happened'));
    },
    build: () => chatBloc,
    act: (bloc) => bloc.add(SendMessage('product-42', '', 'User_1234')),
    expect: () => [isA<ChatError>()],
  );

// 5. After close() is called, no further states are emitted when
//    the stream emits new messages (subscription is cancelled)

  blocTest<ChatBloc, ChatState>(
    'verify no further states are emitted after close',
    setUp: () {
      controller = StreamController<List<Message>>();
      when(
        () => mockWatchMessages.call(any()),
      ).thenAnswer((_) => controller.stream);
    },
    build: () => chatBloc,
    act: (bloc) async {
      bloc.add(
        WatchMessages('1'),
      );
      //emit once before close
      await Future.delayed(Duration(milliseconds: 50));
      controller.add([]);

      await Future.delayed(Duration(milliseconds: 50));
      await bloc.close();

      // emit after close — this should be ignored
      controller.add(fakeMessages);
    },
    expect: () => [ChatLoaded([])],
  );
}
