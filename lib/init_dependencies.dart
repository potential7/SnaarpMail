import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/user_login.dart';
import 'features/auth/domain/usecases/user_sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/mail/data/datasources/mail_remote_data_source.dart';
import 'features/mail/data/repositories/mail_repository_impl.dart';
import 'features/mail/domain/repositories/mail_repository.dart';
import 'features/mail/domain/usecases/get_bin_emails.dart';
import 'features/mail/domain/usecases/get_emails.dart';
import 'features/mail/domain/usecases/get_sent_emails.dart';
import 'features/mail/domain/usecases/mark_as_read.dart';
import 'features/mail/domain/usecases/mark_as_unread.dart';
import 'features/mail/domain/usecases/delete_email.dart';
import 'features/mail/domain/usecases/send_email.dart';
import 'features/mail/presentation/bloc/mail_bloc.dart';

import 'features/mail/domain/usecases/search_emails.dart';
import 'features/search/presentation/bloc/search_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initMail();
  _initSearch();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    ..registerFactory(
      () => UserSignUp(serviceLocator()),
    )
    ..registerFactory(
      () => UserLogin(serviceLocator()),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
      ),
    );
}

void _initMail() {
  serviceLocator
    ..registerFactory<MailRemoteDataSource>(
      () => MailRemoteDataSourceImpl(),
    )
    ..registerFactory<MailRepository>(
      () => MailRepositoryImpl(serviceLocator()),
    )
    ..registerFactory(
      () => GetEmails(serviceLocator()),
    )
    ..registerFactory(
      () => GetSentEmails(serviceLocator()),
    )
    ..registerFactory(
      () => SendEmail(serviceLocator()),
    )
    ..registerFactory(
      () => MarkAsRead(serviceLocator()),
    )
    ..registerFactory(() => MarkAsUnread(serviceLocator()))
    ..registerFactory(() => DeleteEmail(serviceLocator()))
    ..registerFactory(() => GetBinEmails(serviceLocator()))
    ..registerLazySingleton(
      () => MailBloc(
        getEmails: serviceLocator(),
        getSentEmails: serviceLocator(),
        getBinEmails: serviceLocator(),
        sendEmail: serviceLocator(),
        markAsRead: serviceLocator(),
        markAsUnread: serviceLocator(),
        deleteEmail: serviceLocator(),
      ),
    );
}

void _initSearch() {
  serviceLocator
    ..registerFactory(
      () => SearchEmails(serviceLocator()),
    )
    ..registerLazySingleton(
      () => SearchBloc(
        searchEmails: serviceLocator(),
      ),
    );
}
