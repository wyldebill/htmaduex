import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/business_repository.dart';
import '../models/business.dart';
import '../theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final Future<List<Business>> _businessesFuture =
      BusinessRepository.loadBusinesses();
  int _selectedId = 1;
  String _category = 'All';
  final Set<int> _saved = <int>{2, 5};

  @override
  Widget build(BuildContext context) {
    final bool mapSupported =
        kIsWeb ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
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
                'Unable to load map data.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        final List<Business> items = snapshot.data ?? <Business>[];
        final List<Business> filtered = _category == 'All'
            ? items
            : items
                  .where((Business item) => item.categoryLabel == _category)
                  .toList();
        final Business? selected = filtered.isEmpty
            ? null
            : filtered.firstWhere(
                (Business item) => item.id == _selectedId,
                orElse: () => filtered.first,
              );
        final Business mapCenter = selected ?? items.first;

        return Scaffold(
          body: Stack(
            children: <Widget>[
              if (mapSupported)
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(mapCenter.latitude, mapCenter.longitude),
                    zoom: 14.2,
                  ),
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  markers: filtered.map((Business item) {
                    return Marker(
                      markerId: MarkerId('biz-${item.id}'),
                      position: LatLng(item.latitude, item.longitude),
                      onTap: () => setState(() => _selectedId = item.id),
                    );
                  }).toSet(),
                )
              else
                Container(
                  color: AppColors.primarySoft,
                  alignment: Alignment.center,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Map preview unavailable on this platform.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSoft,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 14,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.search_rounded, size: 18),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Downtown Buffalo, MN',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.primary,
                              child: const Text(
                                'AM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
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
              ),
              Positioned(
                top: 190,
                right: 14,
                child: Column(
                  children: <Widget>[
                    _mapButton(
                      icon: Icons.layers_outlined,
                      onTap: () {},
                      accent: false,
                    ),
                    const SizedBox(height: 10),
                    _mapButton(
                      icon: Icons.my_location_rounded,
                      onTap: () {},
                      accent: true,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 228,
                child: Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () => context.go('/list'),
                    icon: const Icon(Icons.list_rounded, size: 16),
                    label: const Text('List view'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 24,
                        offset: Offset(0, -8),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            if (selected != null)
                              Container(
                                width: 64,
                                height: 64,
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
                                  color: AppColors.primary,
                                ),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: selected == null
                                  ? const Text(
                                      'No places match this category.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.inkSoft,
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          selected.categoryLabel,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.openGreen,
                                          ),
                                        ),
                                        Text(
                                          selected.name,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        Text(
                                          selected.address,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.inkSoft,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            if (selected != null)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_saved.contains(selected.id)) {
                                      _saved.remove(selected.id);
                                    } else {
                                      _saved.add(selected.id);
                                    }
                                  });
                                },
                                icon: Icon(
                                  _saved.contains(selected.id)
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: _saved.contains(selected.id)
                                      ? AppColors.primary
                                      : AppColors.inkSoft,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _actionButton(
                                icon: Icons.route_rounded,
                                label: 'Directions',
                                filled: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _actionButton(
                                icon: Icons.call_outlined,
                                label: 'Call',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _actionButton(
                                icon: Icons.share_outlined,
                                label: 'Share',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: selected == null
                              ? null
                              : () => context.push('/business/${selected.id}'),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('View details'),
                              SizedBox(width: 6),
                              Icon(Icons.chevron_right_rounded, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: 0,
            onDestinationSelected: (int i) {
              if (i == 0) context.go('/map');
              if (i == 1) context.go('/list');
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

  Widget _actionButton({
    required IconData icon,
    required String label,
    bool filled = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : AppColors.chipBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          foregroundColor: filled ? Colors.white : AppColors.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 18),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool accent,
  }) {
    return Material(
      color: accent ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: accent ? Colors.white : AppColors.ink),
        ),
      ),
    );
  }
}
