import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snaarp_mail/features/mail/data/datasources/mail_remote_data_source.dart';
import 'package:snaarp_mail/features/mail/domain/entities/email.dart';
import 'package:snaarp_mail/features/mail/domain/usecases/search_emails.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchEmails _searchEmails;

  SearchBloc({required SearchEmails searchEmails})
      : _searchEmails = searchEmails,
        super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchFilterChanged>(_onSearchFilterChanged);
    on<ClearSearch>(_onClearSearch);
    on<SearchAllEmails>(_onSearchAllEmails);
  }

  void _onSearchAllEmails(
      SearchAllEmails event, Emitter<SearchState> emit) async {
    await _performSearch(emit, query: '');
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    await _performSearch(emit, query: event.query);
  }

  void _onSearchFilterChanged(
      SearchFilterChanged event, Emitter<SearchState> emit) async {
    await _performSearch(emit, filter: event.filter);
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(const SearchSuccess(emails: [], query: '', filter: EmailFilter.all));
  }

  Future<void> _performSearch(
    Emitter<SearchState> emit, {
    String? query,
    EmailFilter? filter,
  }) async {
    emit(SearchLoading());

    final currentQuery = query ??
        (state is SearchSuccess ? (state as SearchSuccess).query : '');
    
    final EmailFilter currentFilter = filter ??
        (state is SearchSuccess 
            ? (state as SearchSuccess).filter 
            : EmailFilter.all);

    final res = await _searchEmails(SearchEmailsParams(
      query: currentQuery,
      filter: currentFilter,
    ));

    res.fold(
      (failure) => emit(SearchFailure(failure.message)),
      (emails) {
        if (emails.isEmpty && currentQuery.isNotEmpty) {
           emit(SearchEmpty(currentQuery));
        } else {
          emit(SearchSuccess(
            emails: emails,
            query: currentQuery,
            filter: currentFilter,
          ));
        }
      },
    );
  }
}
