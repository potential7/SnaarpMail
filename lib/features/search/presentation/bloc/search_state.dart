part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchSuccess extends SearchState {
  final List<Email> emails;
  final String query;
  final EmailFilter filter;

  const SearchSuccess({
    required this.emails,
    this.query = '',
    this.filter = EmailFilter.all,
  });

  @override
  List<Object?> get props => [emails, query, filter];
}

final class SearchFailure extends SearchState {
  final String message;
  const SearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty(this.query);
  @override
  List<Object?> get props => [query];
}
