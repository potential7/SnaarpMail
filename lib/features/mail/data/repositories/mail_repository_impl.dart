import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/email.dart';
import '../../domain/repositories/mail_repository.dart';
import '../datasources/mail_remote_data_source.dart';

class MailRepositoryImpl implements MailRepository {
  final MailRemoteDataSource remoteDataSource;
  const MailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Email>>> getEmails() async {
    try {
      final emails = await remoteDataSource.getEmails();
      return right(emails);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Email>>> getSentEmails() async {
    try {
      final emails = await remoteDataSource.getSentEmails();
      return right(emails);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Email>>> getBinEmails() async {
    try {
      final emails = await remoteDataSource.getBinEmails();
      return right(emails);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Email>>> searchEmails(String query, EmailFilter filter) async {
    try {
      final emails = await remoteDataSource.searchEmails(query, filter);
      return right(emails);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Email>> markAsRead(String id) async {
    try {
      final email = await remoteDataSource.markAsRead(id);
      return right(email);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Email>> markAsUnread(String id) async {
    try {
      final email = await remoteDataSource.markAsUnread(id);
      return right(email);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendEmail({
    required String recipient,
    required String subject,
    required String body,
  }) async {
    try {
      await remoteDataSource.sendEmail(
        recipient: recipient,
        subject: subject,
        body: body,
      );
      return right(unit);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEmail(String id) async {
    try {
      await remoteDataSource.deleteEmail(id);
      return right(unit);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }}
