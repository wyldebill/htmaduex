import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sort = 'Distance';
  String _category = 'All';
  final Set<int> _saved = <int>{2, 5};

  static const List<Map<String, dynamic>> _items = <Map<String, dynamic>>[
    {
      'id': 1,
      'name': 'Driftwood Coffee',
      'rating': '4.8',
      'reviews': '312',
      'price': '\$\$',
      'dist': '0.2 mi',
      'cat': 'Cafes',
      'tags': <String>['Outdoor', 'Wi-Fi'],
      'emoji': '☕',
      'color': AppColors.primary,
    },
    {
      'id': 2,
      'name': 'Tokio Ramen Bar',
      'rating': '4.6',
      'reviews': '1204',
      'price': '\$\$',
      'dist': '0.6 mi',
      'cat': 'Food',
      'tags': <String>['Dine-in', 'Takeout'],
      'emoji': '🍜',
      'color': AppColors.tint4,
    },
    {
      'id': 3,
      'name': 'Pine & Palm Bookshop',
      'rating': '4.9',
      'reviews': '86',
      'price': '\$\$',
      'dist': '0.4 mi',
      'cat': 'Shops',
      'tags': <String>['Events', 'Local'],
      'emoji': '🛍',
      'color': AppColors.tint3,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String q = _searchController.text.trim().toLowerCase();
    final List<Map<String, dynamic>> filtered = _items.where((item) {
      final bool categoryOk = _category == 'All' || item['cat'] == _category;
      if (!categoryOk) return false;
      if (q.isEmpty) return true;
      final String name = (item['name'] as String).toLowerCase();
      final List<String> tags = (item['tags'] as List<String>)
          .map((String e) => e.toLowerCase())
          .toList();
      return name.contains(q) || tags.any((String t) => t.contains(q));
    }).toList();

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
                    '${filtered.length} places within 1.5 mi · Oakland, CA',
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
                      hintText: 'Search by name or tag',
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
                        onSelected: (String value) => setState(() => _sort = value),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border, width: 1.5),
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
                              const Icon(Icons.expand_more_rounded, size: 14),
                            ],
                          ),
                        ),
                        itemBuilder: (BuildContext context) => const <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(value: 'Distance', child: Text('Distance')),
                          PopupMenuItem<String>(value: 'Rating', child: Text('Rating')),
                          PopupMenuItem<String>(value: 'Name', child: Text('Name (A-Z)')),
                          PopupMenuItem<String>(value: 'Price', child: Text('Price')),
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
                      children: <String>['All', 'Cafes', 'Food', 'Shops', 'Services']
                          .map(
                            (String label) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(label),
                                selected: _category == label,
                                onSelected: (_) => setState(() => _category = label),
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
                  final item = filtered[index];
                  final int id = item['id'] as int;
                  final Color tint = item['color'] as Color;
                  final bool isSaved = _saved.contains(id);
                  return GestureDetector(
                    onTap: () => context.push('/business/$id'),
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
                              color: tint.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: tint.withValues(alpha: 0.22)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              item['emoji'] as String,
                              style: const TextStyle(fontSize: 26),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: <Widget>[
                                    const Icon(Icons.star_rounded,
                                        size: 12, color: AppColors.accent),
                                    const SizedBox(width: 3),
                                    Text(
                                      item['rating'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      ' (${item['reviews']}) · ${item['price']} · ${item['dist']}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.inkSoft,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: <Widget>[
                                    _tinyTag(
                                      item['cat'] as String,
                                      fg: tint,
                                      bg: tint.withValues(alpha: 0.14),
                                    ),
                                    ...(item['tags'] as List<String>).take(2).map(
                                          (String t) =>
                                              _tinyTag(t, fg: AppColors.inkSoft, bg: AppColors.chipBg),
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
                                  _saved.remove(id);
                                } else {
                                  _saved.add(id);
                                }
                              });
                            },
                            icon: Icon(
                              isSaved
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isSaved ? AppColors.primary : AppColors.inkFaint,
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
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.list_alt_rounded), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.bookmark_border_rounded), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
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
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
