import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_pallete.dart';
import '../bloc/mail_bloc.dart';
import 'mail_badge.dart';

class MailDrawer extends StatelessWidget {
  final String selectedDrawerItem;
  final Function(String) onItemTap;

  const MailDrawer({
    super.key,
    required this.selectedDrawerItem,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final mailState = context.watch<MailBloc>().state;
    final unreadCounts = mailState.unreadCounts;

    final primaryCount = unreadCounts['Primary'] ?? 0;
    final promotionsCount = unreadCounts['Promotions'] ?? 0;
    final socialCount = unreadCounts['Social'] ?? 0;
    final updatesCount = unreadCounts['Updates'] ?? 0;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 15, top: 20, bottom: 5),
            decoration: const BoxDecoration(
              color: AppPallete.primaryRed,
            ),
            alignment: Alignment.bottomLeft,
            child: const Text(
              "SnaarpMail",
              style: TextStyle(
                fontSize: 28,
                color: AppPallete.whiteColor,
                fontWeight: FontWeight.bold,
                letterSpacing: -2,
              ),
            ),
          ),
          _buildDrawerTile(Icons.all_inbox, 'All Inboxes', context),
          const Divider(height: 1),
          _buildDrawerTile(Icons.inbox, 'Primary', context, trailing: primaryCount > 0 ? Text(
            primaryCount > 99 ? '99+' : primaryCount.toString(),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ) : null),
          _buildDrawerTile(Icons.local_offer_outlined, 'Promotions', context, trailing: promotionsCount > 0 ? MailBadge(
            text: '$promotionsCount new',
            backgroundColor: AppPallete.greenColor,
            textColor: AppPallete.greenTextColor,
          ) : null),
          _buildDrawerTile(Icons.people_alt_outlined, 'Social', context, trailing: socialCount > 0 ? MailBadge(
            text: '$socialCount new',
            backgroundColor: AppPallete.lightBlueColor,
            textColor: AppPallete.lightBlueTextColor,
          ) : null),
          _buildDrawerTile(Icons.info_outline, 'Updates', context, trailing: updatesCount > 0 ? MailBadge(
            text: '$updatesCount new',
            backgroundColor: AppPallete.orangeColor,
            textColor: AppPallete.orangeTextColor,
          ) : null),
          const Divider(height: 1),

          _buildDrawerTile(Icons.star_border, 'Starred', context),
          _buildDrawerTile(Icons.send_outlined, 'Sent', context),
          _buildDrawerTile(Icons.outbox_outlined, 'Outbox', context),

          _buildDrawerTile(Icons.drafts_outlined, 'Drafts', context),
          _buildDrawerTile(Icons.delete_outline, 'Bin', context),

          _buildDrawerTile(Icons.settings, 'Settings', context, isAction: true),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, BuildContext context, {Widget? trailing, bool isAction = false}) {
    final bool isSelected = selectedDrawerItem == title;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppPallete.primaryRed : null),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppPallete.primaryRed : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      trailing: trailing,
      selected: isSelected,
      selectedTileColor: AppPallete.primaryRed.withOpacity(0.05),
      onTap: () {
        if (!isAction) {
          onItemTap(title);
        } else {
          Navigator.pop(context);
          // Handle specific actions like Settings here
        }
      },
    );
  }
}
