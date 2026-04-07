import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../domain/entities/email.dart';

class EmailListTile extends StatelessWidget {
  final Email email;
  final VoidCallback onTap;

  const EmailListTile({
    super.key,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSent = email.category == 'Sent';
    final avatarText = email.senderEmail.isNotEmpty ? email.senderEmail[0].toUpperCase() : '?';
    final titleText = isSent ? 'To: ${email.senderEmail}' : email.sender;

    return ListTile(
      tileColor: AppPallete.whiteColor,
      leading: CircleAvatar(
        backgroundColor: AppPallete.primaryRed.withValues(alpha: 0.1),
        child: Text(
          avatarText,
          style: const TextStyle(
              color: AppPallete.primaryRed,
              fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        titleText,
        style: TextStyle(
          color: Colors.black87,
          fontWeight: email.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            email.subject,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: email.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          Text(
            email.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppPallete.greyColor),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${email.timestamp.hour}:${email.timestamp.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 12, color: AppPallete.greyColor),
          ),
          const SizedBox(height: 4),
          Icon(
            email.isStarred ? Icons.star : Icons.star_border,
            size: 20,
            color: email.isStarred ? Colors.amber : AppPallete.greyColor,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
