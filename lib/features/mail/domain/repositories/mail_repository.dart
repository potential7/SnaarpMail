import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/mail_remote_data_source.dart';
import '../entities/email.dart';

abstract interface class MailRepository {
  Future<Either<Failure, List<Email>>> getEmails();
  Future<Either<Failure, List<Email>>> getSentEmails();
  Future<Either<Failure, List<Email>>> getBinEmails();
  Future<Either<Failure, List<Email>>> searchEmails(String query, EmailFilter filter);
  Future<Either<Failure, Unit>> sendEmail({
    required String recipient,
    required String subject,
    required String body,
  });
  Future<Either<Failure, Email>> markAsRead(String id);
  Future<Either<Failure, Email>> markAsUnread(String id);
  Future<Either<Failure, Unit>> deleteEmail(String id);
}
