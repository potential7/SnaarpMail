import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/email.dart';
import '../repositories/mail_repository.dart';

class GetBinEmails implements UseCase<List<Email>, NoParams> {
  final MailRepository repository;
  GetBinEmails(this.repository);

  @override
  Future<Either<Failure, List<Email>>> call(NoParams params) async {
    return await repository.getBinEmails();
  }
}
