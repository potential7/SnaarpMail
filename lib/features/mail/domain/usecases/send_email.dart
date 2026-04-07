import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/mail_repository.dart';

class SendEmail implements UseCase<Unit, SendEmailParams> {
  final MailRepository mailRepository;
  const SendEmail(this.mailRepository);

  @override
  Future<Either<Failure, Unit>> call(SendEmailParams params) async {
    return await mailRepository.sendEmail(
      recipient: params.recipient,
      subject: params.subject,
      body: params.body,
    );
  }
}

class SendEmailParams {
  final String recipient;
  final String subject;
  final String body;

  SendEmailParams({
    required this.recipient,
    required this.subject,
    required this.body,
  });
}
