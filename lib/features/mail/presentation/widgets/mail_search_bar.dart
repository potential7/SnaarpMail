import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/navigation.dart';
import '../../../search/presentation/pages/search_screen.dart';

class MailSearchBar extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const MailSearchBar({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          IconButton.filled(
            onPressed: onMenuPressed,
            icon: const Icon(Icons.menu),
            style: IconButton.styleFrom(
              backgroundColor: AppPallete.whiteColor,
              foregroundColor: AppPallete.greyColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    page: const SearchScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppPallete.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: AppPallete.greyColor),
                    SizedBox(width: 8),
                    Text(
                      'Search in mail',
                      style: TextStyle(color: AppPallete.greyColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppPallete.whiteColor,
              shape: BoxShape.circle,
            ),
            child: const Text(
              'D',
              style: TextStyle(
                color: AppPallete.primaryRed,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
