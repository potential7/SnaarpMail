part of 'mail_bloc.dart';

enum MailStatus { initial, loading, success, failure, sendSuccess }

class MailState {
  final MailStatus status;
  final List<Email> emails;
  final String? errorMessage;
  final String selectedDrawerItem;
  final String selectedCategory;
  final Map<String, int> unreadCounts;

  const MailState({
    this.status = MailStatus.initial,
    this.emails = const [],
    this.errorMessage,
    this.selectedDrawerItem = 'Primary',
    this.selectedCategory = 'All Inboxes',
    this.unreadCounts = const {},
  });

  MailState copyWith({
    MailStatus? status,
    List<Email>? emails,
    String? errorMessage,
    String? selectedDrawerItem,
    String? selectedCategory,
    Map<String, int>? unreadCounts,
  }) {
    return MailState(
      status: status ?? this.status,
      emails: emails ?? this.emails,
      errorMessage: errorMessage, // Overwrite if null intentionally? Actually, let's keep it exact or handle null explicitly.
      // Usually, when copyWith doesn't supply a value, we fall back to existing. 
      // If we want to clear the error, we might need a separate clearError method, but for simplicity we will just let the next valid state omit it.
      // Better yet, just pass null if not supplied? Wait, no. Dart doesn't distinguish between unset and null easily.
      // We will just do:
      selectedDrawerItem: selectedDrawerItem ?? this.selectedDrawerItem,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      unreadCounts: unreadCounts ?? this.unreadCounts,
    );
  }

  // A specific method to copy with clearing errors
  MailState copyWithStatus(MailStatus newStatus, {
    List<Email>? emails,
    String? errorMessage,
    String? selectedDrawerItem,
    String? selectedCategory,
    Map<String, int>? unreadCounts,
  }) {
    return MailState(
      status: newStatus,
      emails: emails ?? this.emails,
      errorMessage: errorMessage, // Will explicitly be null if not provided, clearing previous errors!
      selectedDrawerItem: selectedDrawerItem ?? this.selectedDrawerItem,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      unreadCounts: unreadCounts ?? this.unreadCounts,
    );
  }
}
