part of 'mail_bloc.dart';

sealed class MailEvent {}

final class MailFetchAllEmails extends MailEvent {}

final class MailFetchSentEmails extends MailEvent {}

final class MailFilterChanged extends MailEvent {
  final String drawerItem;
  final String category;

  MailFilterChanged({
    required this.drawerItem,
    required this.category,
  });
}

final class MailMarkAsRead extends MailEvent {
  final String id;
  MailMarkAsRead(this.id);
}

final class MailMarkAsUnread extends MailEvent {
  final String id;
  MailMarkAsUnread(this.id);
}

final class MailDeleteEmail extends MailEvent {
  final String id;
  MailDeleteEmail(this.id);
}

final class MailSendEmail extends MailEvent {
  final String recipient;
  final String subject;
  final String body;

  MailSendEmail({
    required this.recipient,
    required this.subject,
    required this.body,
  });
}
