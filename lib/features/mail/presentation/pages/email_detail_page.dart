import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../domain/entities/email.dart';
import '../bloc/mail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailDetailPage extends StatefulWidget {
  final Email email;
  const EmailDetailPage({super.key, required this.email});

  @override
  State<EmailDetailPage> createState() => _EmailDetailPageState();
}

class _EmailDetailPageState extends State<EmailDetailPage> {
  bool _isDetailsExpanded = false;
  late bool _isStarred;

  @override
  void initState() {
    super.initState();
    _isStarred = widget.email.isStarred;
  }

  @override
  Widget build(BuildContext context) {
    final isSent = widget.email.category == 'Sent';
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentEmail = currentUser?.email ?? 'me@gmail.com';
    final currentName = currentUser?.displayName ?? 'Me';

    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.archive_outlined),
          ),
          IconButton(
            onPressed: () {
              context.read<MailBloc>().add(MailDeleteEmail(widget.email.id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email deleted')),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            onPressed: () {
              context.read<MailBloc>().add(MailMarkAsUnread(widget.email.id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Marked as unread')),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.mark_as_unread_outlined),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Container(
        color: AppPallete.whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.email.subject,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isStarred = !_isStarred;
                      });
                    },
                    icon: Icon(
                      _isStarred ? Icons.star : Icons.star_border,
                      color: _isStarred ? Colors.amber : AppPallete.greyColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppPallete.primaryRed.withValues(alpha: 0.1),
                    child: Text(
                      (isSent ? currentEmail : widget.email.senderEmail).isNotEmpty 
                          ? (isSent ? currentEmail : widget.email.senderEmail)[0].toUpperCase() 
                          : 'U',
                      style: const TextStyle(
                          color: AppPallete.primaryRed,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              isSent ? 'me' : widget.email.sender,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                            const SizedBox(width: 8),
                            if (!isSent)
                              Text(
                                '${widget.email.timestamp.day} ${_getMonth(widget.email.timestamp.month)}',
                                style: const TextStyle(
                                    color: AppPallete.greyColor, fontSize: 12),
                              )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isDetailsExpanded = !_isDetailsExpanded;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                isSent ? 'to ${widget.email.senderEmail}' : 'to me',
                                style: const TextStyle(
                                    color: AppPallete.greyColor, fontSize: 12),
                              ),
                              if (isSent)
                                Icon(
                                  _isDetailsExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppPallete.greyColor,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isSent && _isDetailsExpanded) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppPallete.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppPallete.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            child: Text('From:', style: TextStyle(color: AppPallete.greyColor)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentName, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                Text(currentEmail, style: const TextStyle(color: AppPallete.greyColor, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            child: Text('To:', style: TextStyle(color: AppPallete.greyColor)),
                          ),
                          Expanded(
                            child: Text(widget.email.senderEmail, style: const TextStyle(color: Colors.black87)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            child: Text('Date:', style: TextStyle(color: AppPallete.greyColor)),
                          ),
                          Expanded(
                            child: Text(_formatFullDate(widget.email.timestamp), style: const TextStyle(color: Colors.black87)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 30),
              Text(
                widget.email.body,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    final day = date.day;
    final month = _getMonth(date.month);
    final year = date.year;
    
    // Time formatting manually instead of intl purely for simplicity if no intl package
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    
    return '$day $month $year, $hour:$minute $amPm';
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
