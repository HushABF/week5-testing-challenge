import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String productId;
  final String senderUsername;
  final String text;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.productId,
    required this.senderUsername,
    required this.text,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, productId, senderUsername, text, createdAt];
}
