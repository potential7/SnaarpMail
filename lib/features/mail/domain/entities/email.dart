import 'package:equatable/equatable.dart';

class Email extends Equatable {
  final String id;
  final String sender;
  final String senderEmail;
  final String subject;
  final String body;
  final String category;
  final DateTime timestamp;
  final bool isRead;
  final bool isStarred;
  final bool isDeleted;

  const Email({
    required this.id,
    required this.sender,
    required this.senderEmail,
    required this.subject,
    required this.body,
    required this.category,
    required this.timestamp,
    this.isRead = false,
    this.isStarred = false,
    this.isDeleted = false,
  });

  Email copyWith({
    String? id,
    String? sender,
    String? senderEmail,
    String? subject,
    String? body,
    String? category,
    DateTime? timestamp,
    bool? isRead,
    bool? isStarred,
    bool? isDeleted,
  }) {
    return Email(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      senderEmail: senderEmail ?? this.senderEmail,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sender,
        senderEmail,
        subject,
        body,
        category,
        timestamp,
        isRead,
        isStarred,
        isDeleted,
      ];
}
