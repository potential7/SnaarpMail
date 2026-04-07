import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/email.dart';
import '../../domain/usecases/get_emails.dart';
import '../../domain/usecases/get_sent_emails.dart';
import '../../domain/usecases/get_bin_emails.dart';
import '../../domain/usecases/mark_as_read.dart';
import '../../domain/usecases/mark_as_unread.dart';
import '../../domain/usecases/send_email.dart';
import '../../domain/usecases/delete_email.dart';

part 'mail_event.dart';
part 'mail_state.dart';

class MailBloc extends Bloc<MailEvent, MailState> {
  final GetEmails _getEmails;
  final GetSentEmails _getSentEmails;
  final GetBinEmails _getBinEmails;
  final SendEmail _sendEmail;
  final MarkAsRead _markAsRead;
  final MarkAsUnread _markAsUnread;
  final DeleteEmail _deleteEmail;
  List<Email> _cachedAllEmails = [];

  Map<String, int> get _unreadCounts => _computeUnreadCounts(_cachedAllEmails);

  Map<String, int> _computeUnreadCounts(List<Email> emails) {
    final counts = <String, int>{
      'Primary': 0,
      'Promotions': 0,
      'Social': 0,
      'Updates': 0,
    };
    for (var email in emails) {
      if (!email.isRead && counts.containsKey(email.category)) {
        counts[email.category] = (counts[email.category] ?? 0) + 1;
      }
    }
    return counts;
  }

  MailBloc({
    required GetEmails getEmails,
    required GetSentEmails getSentEmails,
    required GetBinEmails getBinEmails,
    required SendEmail sendEmail,
    required MarkAsRead markAsRead,
    required MarkAsUnread markAsUnread,
    required DeleteEmail deleteEmail,
  })  : _getEmails = getEmails,
        _getSentEmails = getSentEmails,
        _getBinEmails = getBinEmails,
        _sendEmail = sendEmail,
        _markAsRead = markAsRead,
        _markAsUnread = markAsUnread,
        _deleteEmail = deleteEmail,
        super(const MailState()) {
    on<MailFetchAllEmails>(_onFetchAllEmails);
    on<MailFetchSentEmails>(_onFetchSentEmails);
    on<MailFilterChanged>(_onFilterChanged);
    on<MailMarkAsRead>(_onMarkAsRead);
    on<MailMarkAsUnread>(_onMarkAsUnread);
    on<MailDeleteEmail>(_onDeleteEmail);
    on<MailSendEmail>(_onSendEmail);
  }

  void _onFetchAllEmails(MailFetchAllEmails event, Emitter<MailState> emit) async {
    emit(state.copyWithStatus(MailStatus.loading));
    final res = await _getEmails(NoParams());

    res.fold(
      (failure) => emit(state.copyWithStatus(MailStatus.failure, errorMessage: failure.message)),
      (emails) {
        _cachedAllEmails = emails;
        emit(state.copyWithStatus(
          MailStatus.success,
          emails: emails,
          unreadCounts: _unreadCounts,
        ));
      },
    );
  }

  void _onFetchSentEmails(MailFetchSentEmails event, Emitter<MailState> emit) async {
    emit(state.copyWithStatus(MailStatus.loading));
    final res = await _getSentEmails(NoParams());

    res.fold(
      (failure) => emit(state.copyWithStatus(MailStatus.failure, errorMessage: failure.message)),
      (emails) => emit(state.copyWithStatus(
        MailStatus.success,
        emails: emails,
        unreadCounts: _unreadCounts,
        selectedDrawerItem: 'Sent',
      )),
    );
  }

  void _onFilterChanged(MailFilterChanged event, Emitter<MailState> emit) async {
    emit(state.copyWithStatus(MailStatus.loading));
    
    // Fetch emails based on drawerItem
    late final Either<Failure, List<Email>> res;
    if (event.drawerItem == 'Sent') {
      res = await _getSentEmails(NoParams());
    } else if (event.drawerItem == 'Bin') {
      res = await _getBinEmails(NoParams());
    } else if (['Outbox', 'Drafts'].contains(event.drawerItem)) {
      res = Right([]);
    } else {
      res = await _getEmails(NoParams());
    }

    res.fold(
      (failure) => emit(state.copyWithStatus(MailStatus.failure, errorMessage: failure.message)),
      (allEmails) {
        if (!['Sent', 'Outbox', 'Drafts', 'Bin'].contains(event.drawerItem)) {
          _cachedAllEmails = allEmails;
        }
        var filteredEmails = allEmails;

        // Apply Drawer Filter logic
        if (event.drawerItem == 'Starred') {
          filteredEmails = filteredEmails.where((e) => e.isStarred).toList();
        } else if (event.drawerItem == 'Sent') {
          filteredEmails = filteredEmails.where((e) => e.category == 'Sent').toList();
        }

        // Apply Category Chip Filter
        if (event.category != 'All Inboxes' && !['Sent', 'Starred'].contains(event.drawerItem)) {
          filteredEmails = filteredEmails
              .where((e) => e.category == event.category)
              .toList();
        }

        emit(state.copyWithStatus(
          MailStatus.success,
          emails: filteredEmails,
          unreadCounts: _unreadCounts,
          selectedDrawerItem: event.drawerItem,
          selectedCategory: event.category,
        ));
      },
    );
  }

  void _onMarkAsRead(MailMarkAsRead event, Emitter<MailState> emit) async {
    final res = await _markAsRead(event.id);

    res.fold(
      (failure) => emit(state.copyWithStatus(MailStatus.failure, errorMessage: failure.message)),
      (email) {
        final updatedEmails = state.emails.map((e) {
          return e.id == email.id ? email : e;
        }).toList();

        _cachedAllEmails = _cachedAllEmails.map((e) {
          return e.id == email.id ? email : e;
        }).toList();

        emit(state.copyWithStatus(
          MailStatus.success,
          emails: updatedEmails, 
          unreadCounts: _unreadCounts,
        ));
      },
    );
  }

  void _onMarkAsUnread(MailMarkAsUnread event, Emitter<MailState> emit) async {
    final res = await _markAsUnread(event.id);

    res.fold(
      (failure) => emit(state.copyWithStatus(MailStatus.failure, errorMessage: failure.message)),
      (email) {
        final updatedEmails = state.emails.map((e) {
          return e.id == email.id ? email : e;
        }).toList();

        _cachedAllEmails = _cachedAllEmails.map((e) {
          return e.id == email.id ? email : e;
        }).toList();

        emit(state.copyWithStatus(
          MailStatus.success,
          emails: updatedEmails, 
          unreadCounts: _unreadCounts,
        ));
      },
    );
  }

  void _onSendEmail(MailSendEmail event, Emitter<MailState> emit) async {
    emit(state.copyWithStatus(MailStatus.loading));
    final res = await _sendEmail(
      SendEmailParams(
        recipient: event.recipient,
        subject: event.subject,
        body: event.body,
      ),
    );

    res.fold(
      (failure) => emit(state.copyWithStatus(MailStatus.failure, errorMessage: failure.message)),
      (_) {
        emit(state.copyWithStatus(MailStatus.sendSuccess));
      },
    );
  }

  void _onDeleteEmail(MailDeleteEmail event, Emitter<MailState> emit) async {
    final res = await _deleteEmail(event.id);

    res.fold(
      (failure) => emit(state.copyWithStatus(MailStatus.failure, errorMessage: failure.message)),
      (_) {
        _cachedAllEmails.removeWhere((e) => e.id == event.id);
        final updatedEmails = state.emails.where((e) => e.id != event.id).toList();

        emit(state.copyWithStatus(
          MailStatus.success,
          emails: updatedEmails, 
          unreadCounts: _unreadCounts,
        ));
      },
    );
  }
}
