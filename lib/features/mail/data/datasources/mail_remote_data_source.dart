import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/database/db_helper.dart';
import '../models/email_model.dart';

enum EmailFilter {
  all,
  unread,
  starred,
}

abstract interface class MailRemoteDataSource {
  Future<List<EmailModel>> getEmails();
  Future<List<EmailModel>> getSentEmails();
  Future<List<EmailModel>> getBinEmails();
  Future<List<EmailModel>> searchEmails(String query, EmailFilter filter);
  Future<void> sendEmail({
    required String recipient,
    required String subject,
    required String body,
  });
  Future<void> deleteEmail(String id);
  Future<EmailModel> markAsRead(String id);
  Future<EmailModel> markAsUnread(String id);
}

class MailRemoteDataSourceImpl implements MailRemoteDataSource {
  final DbHelper _dbHelper = DbHelper();
  
  final List<EmailModel> _mockEmails = [
    EmailModel(
      id: '1',
      sender: 'Flutter Team',
      senderEmail: 'noreply@flutter.dev',
      subject: 'Welcome to Flutter!',
      body: 'Flutter is Google’s UI toolkit for building beautiful applications.',
      category: 'Primary',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      isStarred: true,
      isDeleted: false,
    ),
    EmailModel(
      id: '2',
      sender: 'Apple',
      senderEmail: 'ai@snaarp.com',
      subject: 'New Feature Release',
      body: 'Your iPhone 15 Pro Max has been shipped',
      category: 'Updates',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      isStarred: false,
      isDeleted: false,
    ),
    EmailModel(
      id: '3',
      sender: 'LinkedIn',
      senderEmail: 'messages-noreply@linkedin.com',
      subject: 'You have a new connection request',
      body: 'Alex Johnson has requested to connect with you. View their profile to accept or decline.',
      category: 'Social',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      isRead: false,
      isStarred: false,
      isDeleted: false,
    ),
    EmailModel(
      id: '4',
      sender: 'Amazon',
      senderEmail: 'promotions@amazon.com',
      subject: 'Flash Sale: Up to 50% Off Electronics!',
      body: 'Don\'t miss out on our biggest electronics sale of the season. Grab the latest gadgets at half the price.',
      category: 'Promotions',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
      isStarred: true,
      isDeleted: false,
    ),
    EmailModel(
      id: '5',
      sender: 'Sarah Designer',
      senderEmail: 'sarah.design@example.com',
      subject: 'Figma mockups for the new landing page',
      body: 'Hey! I just finished the new landing page designs. Let me know what you think of the new hero section layout.',
      category: 'Primary',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      isRead: true,
      isStarred: true,
      isDeleted: false,
    ),
    EmailModel(
      id: '6',
      sender: 'Twitter',
      senderEmail: 'info@twitter.com',
      subject: 'Trending heavily: #FlutterDev',
      body: 'See what everyone is talking about in the Flutter community right now.',
      category: 'Social',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      isStarred: false,
      isDeleted: false,
    ),
    EmailModel(
      id: '7',
      sender: 'Uber Eats',
      senderEmail: 'eats@uber.com',
      subject: 'Craving pizza? Here is \$10 off!',
      body: 'Treat yourself to your favorite meal this weekend with a \$10 discount on orders over \$25.',
      category: 'Promotions',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: false,
      isStarred: false,
      isDeleted: false,
    ),
  ];

  @override
  Future<List<EmailModel>> getEmails() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockEmails.where((e) => !e.isDeleted).toList();
  }

  @override
  Future<List<EmailModel>> getSentEmails() async {
    return await _dbHelper.getEmailsByFolder('Sent');
  }

  @override
  Future<List<EmailModel>> getBinEmails() async {
    return await _dbHelper.getEmailsByFolder('Bin');
  }

  @override
  Future<List<EmailModel>> searchEmails(String query, EmailFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final sentEmails = await _dbHelper.getEmailsByFolder('Sent');
    final binEmails = await _dbHelper.getEmailsByFolder('Bin');
    final all = [..._mockEmails, ...sentEmails, ...binEmails];
    
    if (query.isEmpty) {
      return _applyFilter(all, filter);
    }

    final lowercaseQuery = query.toLowerCase();
    final results = all.where((email) {
      return email.sender.toLowerCase().contains(lowercaseQuery) ||
             email.senderEmail.toLowerCase().contains(lowercaseQuery) ||
             email.subject.toLowerCase().contains(lowercaseQuery) ||
             email.body.toLowerCase().contains(lowercaseQuery);
    }).toList();

    return _applyFilter(results, filter);
  }

  List<EmailModel> _applyFilter(List<EmailModel> emails, EmailFilter filter) {
    switch (filter) {
      case EmailFilter.unread:
        return emails.where((e) => !e.isRead).toList();
      case EmailFilter.starred:
        return emails.where((e) => e.isStarred).toList();
      default:
        return emails;
    }
  }

  @override
  Future<void> sendEmail({
    required String recipient,
    required String subject,
    required String body,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final currentUser = FirebaseAuth.instance.currentUser;
    
    final newEmail = EmailModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: currentUser?.displayName ?? 'Me',
      senderEmail: recipient,
      subject: subject.isEmpty ? '(No Subject)' : subject,
      body: body,
      category: 'Sent',
      timestamp: DateTime.now(),
      isRead: true,
      isStarred: false,
      isDeleted: false,
    );
    
    await _dbHelper.insertEmail(newEmail);
  }

  @override
  Future<void> deleteEmail(String id) async {
    // Check if it's a mock email first
    final index = _mockEmails.indexWhere((e) => e.id == id);
    if (index != -1) {
      final email = _mockEmails[index].copyWith(isDeleted: true);
      _mockEmails.removeAt(index);
      await _dbHelper.insertEmail(email);
      return;
    }
    
    // Otherwise it's in the DB
    await _dbHelper.markAsDeleted(id);
  }

  @override
  Future<EmailModel> markAsRead(String id) async {
    return _updateReadStatus(id, true);
  }

  @override
  Future<EmailModel> markAsUnread(String id) async {
    return _updateReadStatus(id, false);
  }

  Future<EmailModel> _updateReadStatus(String id, bool isRead) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Try mock first
    final index = _mockEmails.indexWhere((e) => e.id == id);
    if (index != -1) {
      _mockEmails[index] = _mockEmails[index].copyWith(isRead: isRead);
      return _mockEmails[index];
    }

    // Try DB
    final email = await _dbHelper.getEmailById(id);
    if (email != null) {
      final updated = email.copyWith(isRead: isRead);
      await _dbHelper.updateEmailReadStatus(id, isRead);
      return updated;
    }

    throw Exception('Email not found');
  }
}
