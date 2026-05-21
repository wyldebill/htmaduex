import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/business_repository.dart';
import '../models/business.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.businessId});

  final int businessId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _saved = false;
  late final Future<List<Business>> _businessesFuture =
      BusinessRepository.loadBusinesses();

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
        if (snapshot.hasError || (snapshot.data ?? <Business>[]).isEmpty) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () =>
                    context.canPop() ? context.pop() : context.go('/list'),
              ),
            ),
            body: const Center(child: Text('Unable to load business details.')),
          );
        }

        final List<Business> businesses = snapshot.data!;
        final Business business = businesses.firstWhere(
          (Business b) => b.id == widget.businessId,
          orElse: () => businesses.first,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(business.name),
            leading: BackButton(
              onPressed: () =>
                  context.canPop() ? context.pop() : context.go('/list'),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () => setState(() => _saved = !_saved),
                icon: Icon(
                  _saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  business.storefrontImage.isEmpty
                      ? business.storefrontFallback
                      : business.storefrontImage,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) => Container(
                        height: 180,
                        color: AppColors.primarySoft,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.storefront_rounded,
                          color: AppColors.primary,
                          size: 56,
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _ChipTag(label: business.categoryLabel),
                  if ((business.hours ?? '').isNotEmpty)
                    const _ChipTag(label: 'Hours listed'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                business.name,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 10),
              Text(
                business.address,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.inkSoft),
              ),
              const SizedBox(height: 18),
              _InfoCard(
                title: 'Contact',
                rows: <_InfoRowData>[
                  _InfoRowData(
                    icon: Icons.phone_outlined,
                    label: business.phone ?? 'Not provided',
                  ),
                  _InfoRowData(
                    icon: Icons.language_rounded,
                    label: business.website ?? 'Not provided',
                  ),
                  _InfoRowData(
                    icon: Icons.access_time_rounded,
                    label: business.hours ?? 'Not provided',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _InfoCard(
                title: 'Store info',
                rows: <_InfoRowData>[
                  _InfoRowData(
                    icon: Icons.person_outline_rounded,
                    label: business.owner ?? 'Owner not listed',
                  ),
                  _InfoRowData(
                    icon: Icons.location_on_outlined,
                    label:
                        '${business.latitude.toStringAsFixed(6)}, ${business.longitude.toStringAsFixed(6)}',
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 8, 20, 18),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Book a table'),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 54,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ink,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {},
                    child: const Icon(Icons.route_rounded),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.rows});

  final String title;
  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...rows.map(
            (_InfoRowData row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: <Widget>[
                  Icon(row.icon, size: 18, color: AppColors.inkSoft),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      row.label,
                      style: const TextStyle(color: AppColors.inkSoft),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRowData {
  const _InfoRowData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _ChipTag extends StatelessWidget {
  const _ChipTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
