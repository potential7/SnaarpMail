import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../mail/data/datasources/mail_remote_data_source.dart';
import '../../../mail/presentation/pages/email_detail_page.dart';
import '../../../../core/utils/navigation.dart';
import '../bloc/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppPallete.greyColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchQueryChanged(query));
          },
          decoration: const InputDecoration(
            hintText: 'Search in mail',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppPallete.greyColor),
          ),
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: AppPallete.greyColor),
              onPressed: () {
                _searchController.clear();
                context.read<SearchBloc>().add(const SearchQueryChanged(''));
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppPallete.primaryRed),
                  );
                }
                if (state is SearchSuccess) {
                  if (state.emails.isEmpty) {
                    return _buildEmptyState(state.query);
                  }
                  return ListView.separated(
                    itemCount: state.emails.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: AppPallete.borderColor),
                    itemBuilder: (context, index) {
                      final email = state.emails[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppPallete.primaryRed.withValues(alpha: 0.1),
                          child: Text(
                            email.sender[0],
                            style: const TextStyle(
                                color: AppPallete.primaryRed,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(email.sender),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(email.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(email.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        onTap: () {
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
                }
                if (state is SearchEmpty) {
                  return _buildEmptyState(state.query);
                }
                if (state is SearchFailure) {
                  return Center(child: Text(state.message));
                }
                return const Center(
                  child: Text(
                    'Search for emails by sender, subject, or body',
                    style: TextStyle(color: AppPallete.greyColor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final currentFilter = state is SearchSuccess ? state.filter : EmailFilter.all;
        
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: EmailFilter.values.map((filter) {
              final isSelected = currentFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(filter.name.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<SearchBloc>().add(SearchFilterChanged(filter));
                    }
                  },
                  selectedColor: AppPallete.primaryRed.withValues(alpha: 0.1),
                  side: BorderSide.none,
                  labelStyle: TextStyle(
                    color: isSelected ? AppPallete.primaryRed : AppPallete.greyColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppPallete.greyColor),
          const SizedBox(height: 16),
          Text(
            'No results for "$query"',
            style: const TextStyle(fontSize: 18, color: AppPallete.greyColor),
          ),
        ],
      ),
    );
  }
}
