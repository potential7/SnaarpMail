import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/email.dart';
import '../repositories/mail_repository.dart';

class MarkAsRead implements UseCase<Email, String> {
  final MailRepository mailRepository;
  const MarkAsRead(this.mailRepository);

  @override
  Future<Either<Failure, Email>> call(String id) async {
    return await mailRepository.markAsRead(id);
  }
}
