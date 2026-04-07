import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/mail_repository.dart';

class DeleteEmail implements UseCase<Unit, String> {
  final MailRepository repository;
  DeleteEmail(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteEmail(id);
  }
}
