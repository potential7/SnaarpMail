import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_pallete.dart';
import '../bloc/mail_bloc.dart';
import 'compose_page.dart';
import 'email_detail_page.dart';
import '../widgets/category_chip.dart';
import '../widgets/mail_drawer.dart';
import '../widgets/email_list_tile.dart';
import '../widgets/mail_search_bar.dart';
import '../../../../core/utils/navigation.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<MailBloc>().add(MailFetchAllEmails());
  }

  void _onDrawerItemTap(String item) {
    String newCategory = 'All Inboxes';
    if (['All Inboxes', 'Primary', 'Promotions', 'Social', 'Updates'].contains(item)) {
      newCategory = item;
    }
    
    context.read<MailBloc>().add(MailFilterChanged(drawerItem: item, category: newCategory));
    Navigator.pop(context);
  }

  Widget _buildChip(String label, IconData icon, Color color, String currentCategory, String currentDrawerItem) {
    return CategoryChip(
      label: label,
      icon: icon,
      color: color,
      isSelected: currentCategory == label,
      onTap: () {
        context.read<MailBloc>().add(MailFilterChanged(
          drawerItem: label,
          category: label,
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mailState = context.watch<MailBloc>().state;
    final currentDrawerItem = mailState.selectedDrawerItem;
    final currentCategory = mailState.selectedCategory;

    return Scaffold(
      key: _scaffoldKey,
      drawer: MailDrawer(
        selectedDrawerItem: currentDrawerItem,
        onItemTap: _onDrawerItemTap,
      ),
      backgroundColor: AppPallete.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            MailSearchBar(
              onMenuPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            // Hide Category Chips if we're in specific folders that don't use them
            if (!['Sent', 'Outbox', 'Drafts', 'Bin', 'Starred'].contains(currentDrawerItem))
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    _buildChip('All Inboxes', Icons.all_inbox, AppPallete.primaryRed, currentCategory, currentDrawerItem),
                    _buildChip('Primary', Icons.inbox, AppPallete.primaryRed, currentCategory, currentDrawerItem),
                    _buildChip('Promotions', Icons.local_offer_outlined, AppPallete.greenColor, currentCategory, currentDrawerItem),
                    _buildChip('Social', Icons.people_alt_outlined, AppPallete.lightBlueTextColor, currentCategory, currentDrawerItem),
                    _buildChip('Updates', Icons.info_outline, AppPallete.orangeColor, currentCategory, currentDrawerItem),
                  ],
                ),
              ),
            Expanded(
              child: BlocConsumer<MailBloc, MailState>(
                listenWhen: (previous, current) => current.status == MailStatus.failure && current.errorMessage != null,
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
                  );
                },
                builder: (context, state) {
                  if (state.status == MailStatus.initial || (state.status == MailStatus.loading && state.emails.isEmpty)) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: AppPallete.primaryRed));
                  }

                  var filteredEmails = state.emails;

                  if (filteredEmails.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            currentDrawerItem == 'Sent' ? Icons.send_outlined : Icons.inbox_outlined, 
                            size: 48, 
                            color: AppPallete.greyColor.withOpacity(0.5)
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No emails in $currentDrawerItem${currentCategory != 'All Inboxes' ? ' ($currentCategory)' : ''}',
                            style: const TextStyle(color: AppPallete.greyColor),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredEmails.length,
                    separatorBuilder: (context, index) => const Divider(
                        height: 1, color: AppPallete.borderColor),
                    itemBuilder: (context, index) {
                      final email = filteredEmails[index];
                      return EmailListTile(
                        email: email,
                        onTap: () {
                          context
                              .read<MailBloc>()
                              .add(MailMarkAsRead(email.id));
                          Navigator.push(
                            context,
                            PageTransition(
                              page: EmailDetailPage(email: email),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppPallete.primaryRed,
        foregroundColor: AppPallete.whiteColor,
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              page: const ComposePage(),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text(
          'Compose',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
