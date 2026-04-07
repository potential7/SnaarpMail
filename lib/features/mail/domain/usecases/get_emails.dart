import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/email.dart';
import '../repositories/mail_repository.dart';

class GetEmails implements UseCase<List<Email>, NoParams> {
  final MailRepository mailRepository;
  const GetEmails(this.mailRepository);

  @override
  Future<Either<Failure, List<Email>>> call(NoParams params) async {
    return await mailRepository.getEmails();
  }
}
