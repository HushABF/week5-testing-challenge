import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/entities/message.dart';
import '../domain/usecases/send_message_usecase.dart';
import '../domain/usecases/watch_messages_usecase.dart';

// ─── Events ────────────────────────────────────────────────────────────────
abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class WatchMessages extends ChatEvent {
  final String productId;
  WatchMessages(this.productId);

  @override
  List<Object> get props => [productId];
}

class SendMessage extends ChatEvent {
  final String productId;
  final String text;
  final String senderUsername;
  SendMessage(this.productId, this.text, this.senderUsername);

  @override
  List<Object> get props => [productId, text, senderUsername];
}

class _NewMessages extends ChatEvent {
  final List<Message> messages;
  _NewMessages(this.messages);

  @override
  List<Object> get props => [messages];
}

// ─── States ────────────────────────────────────────────────────────────────
abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  ChatLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── BLoC ──────────────────────────────────────────────────────────────────
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WatchMessagesUseCase _watchMessages;
  final SendMessageUseCase _sendMessage;
  StreamSubscription<List<Message>>? _subscription;

  ChatBloc({
    required WatchMessagesUseCase watchMessages,
    required SendMessageUseCase sendMessage,
  })  : _watchMessages = watchMessages,
        _sendMessage = sendMessage,
        super(ChatLoading()) {
    on<WatchMessages>(_onWatchMessages);
    on<SendMessage>(_onSendMessage);
    on<_NewMessages>(_onNewMessages);
  }

  void _onWatchMessages(WatchMessages event, Emitter<ChatState> emit) {
    _subscription?.cancel();
    _subscription = _watchMessages.call(event.productId).listen(
          (messages) => add(_NewMessages(messages)),
          onError: (_) => emit(ChatError('Failed to load messages')),
        );
  }

  void _onNewMessages(_NewMessages event, Emitter<ChatState> emit) {
    emit(ChatLoaded(event.messages));
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    try {
      await _sendMessage.call(
          event.productId, event.text, event.senderUsername);
    } on MessageException catch (e) {
      emit(ChatError(e.message));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
