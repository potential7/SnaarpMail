import '../../domain/entities/email.dart';

class EmailModel extends Email {
  EmailModel({
    required super.id,
    required super.sender,
    required super.senderEmail,
    required super.subject,
    required super.body,
    required super.category,
    required super.timestamp,
    super.isRead,
    super.isStarred,
    super.isDeleted,
  });

  factory EmailModel.fromJson(Map<String, dynamic> json) {
    return EmailModel(
      id: json['id'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      senderEmail: json['senderEmail'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      body: json['body'] as String? ?? '',
      category: json['category'] as String? ?? 'Primary',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String) 
          : DateTime.now(),
      isRead: json['isRead'] is bool ? json['isRead'] : (json['isRead'] == 1),
      isStarred: json['isStarred'] is bool ? json['isStarred'] : (json['isStarred'] == 1),
      isDeleted: json['isDeleted'] is bool ? json['isDeleted'] : (json['isDeleted'] == 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'senderEmail': senderEmail,
      'subject': subject,
      'body': body,
      'category': category,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead ? 1 : 0,
      'isStarred': isStarred ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
    };
  }

  @override
  EmailModel copyWith({
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
    return EmailModel(
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
}
