import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/email.dart';
import '../repositories/mail_repository.dart';

class MarkAsUnread implements UseCase<Email, String> {
  final MailRepository repository;

  MarkAsUnread(this.repository);

  @override
  Future<Either<Failure, Email>> call(String id) async {
    return await repository.markAsUnread(id);
  }
}
