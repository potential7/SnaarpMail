import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/datasources/mail_remote_data_source.dart';
import '../entities/email.dart';
import '../repositories/mail_repository.dart';

class SearchEmails implements UseCase<List<Email>, SearchEmailsParams> {
  final MailRepository repository;
  SearchEmails(this.repository);

  @override
  Future<Either<Failure, List<Email>>> call(SearchEmailsParams params) async {
    return await repository.searchEmails(params.query, params.filter);
  }
}

class SearchEmailsParams {
  final String query;
  final EmailFilter filter;

  SearchEmailsParams({
    required this.query,
    required this.filter,
  });
}
