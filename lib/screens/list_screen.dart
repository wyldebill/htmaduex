import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/business_repository.dart';
import '../models/business.dart';
import '../theme/app_theme.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final Future<List<Business>> _businessesFuture =
      BusinessRepository.loadBusinesses();
  String _sort = 'Distance';
  String _category = 'All';
  final Set<int> _saved = <int>{2, 5};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Business>>(
      future: _businessesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Business>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Unable to load business data.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        final List<Business> items = snapshot.data ?? <Business>[];
        final String q = _searchController.text.trim().toLowerCase();
        final List<Business> filtered = items.where((Business item) {
          final bool categoryOk =
              _category == 'All' || item.categoryLabel == _category;
          if (!categoryOk) return false;
          if (q.isEmpty) return true;
          return item.name.toLowerCase().contains(q) ||
              item.category.toLowerCase().contains(q) ||
              item.address.toLowerCase().contains(q);
        }).toList();
        if (_sort == 'Name') {
          filtered.sort(
            (Business a, Business b) =>
                a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Nearby you',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => context.go('/map'),
                            icon: const Icon(Icons.map_outlined, size: 16),
                            label: const Text('Map'),
                          ),
                        ],
                      ),
                      Text(
                        '${filtered.length} places near downtown Buffalo, MN',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search by name, category, or address',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: q.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          PopupMenuButton<String>(
                            initialValue: _sort,
                            onSelected: (String value) =>
                                setState(() => _sort = value),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(Icons.sort_rounded, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    _sort,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.expand_more_rounded,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (BuildContext context) =>
                                const <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'Distance',
                                    child: Text('Distance'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Name',
                                    child: Text('Name (A-Z)'),
                                  ),
                                ],
                          ),
                          const Spacer(),
                          Text(
                            '${filtered.length} results',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.inkFaint,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              <String>[
                                    'All',
                                    'Cafes',
                                    'Food',
                                    'Shops',
                                    'Services',
                                  ]
                                  .map(
                                    (String label) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ChoiceChip(
                                        label: Text(label),
                                        selected: _category == label,
                                        onSelected: (_) =>
                                            setState(() => _category = label),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Business item = filtered[index];
                      final bool isSaved = _saved.contains(item.id);
                      return GestureDetector(
                        onTap: () => context.push('/business/${item.id}'),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.22,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.storefront_rounded,
                                  size: 28,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.address,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.inkSoft,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: <Widget>[
                                        _tinyTag(
                                          item.categoryLabel,
                                          fg: AppColors.primary,
                                          bg: AppColors.primarySoft,
                                        ),
                                        if ((item.hours ?? '').isNotEmpty)
                                          _tinyTag(
                                            'Hours listed',
                                            fg: AppColors.inkSoft,
                                            bg: AppColors.chipBg,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (isSaved) {
                                      _saved.remove(item.id);
                                    } else {
                                      _saved.add(item.id);
                                    }
                                  });
                                },
                                icon: Icon(
                                  isSaved
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: isSaved
                                      ? AppColors.primary
                                      : AppColors.inkFaint,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: 1,
            onDestinationSelected: (int i) {
              if (i == 0) context.go('/map');
              if (i == 1) context.go('/list');
              if (i == 3) context.go('/profile');
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.map_outlined),
                label: 'Map',
              ),
              NavigationDestination(
                icon: Icon(Icons.list_alt_rounded),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border_rounded),
                label: 'Saved',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tinyTag(String label, {required Color fg, required Color bg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
