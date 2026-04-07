import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/email.dart';
import '../repositories/mail_repository.dart';

class GetSentEmails implements UseCase<List<Email>, NoParams> {
  final MailRepository repository;
  GetSentEmails(this.repository);

  @override
  Future<Either<Failure, List<Email>>> call(NoParams params) async {
    return await repository.getSentEmails();
  }
}
