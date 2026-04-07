part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchAllEmails extends SearchEvent {
  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object> get props => [query];
}

class SearchFilterChanged extends SearchEvent {
  final EmailFilter filter; // Using EmailFilter directly
  const SearchFilterChanged(this.filter);
  @override
  List<Object> get props => [filter];
}

class ClearSearch extends SearchEvent {
  @override
  List<Object> get props => [];
}
