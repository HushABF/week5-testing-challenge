import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String username;

  const AppUser({
    required this.id,
    required this.email,
    required this.username,
  });

  @override
  List<Object> get props => [id, email, username];
}
