import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.businessId});

  final int businessId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme text = theme.textTheme;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      const _StoreHeroGraphic(),
                      Positioned(
                        top: 52,
                        left: 14,
                        child: _RoundIconButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/list');
                            }
                          },
                        ),
                      ),
                      Positioned(
                        top: 52,
                        right: 60,
                        child: _RoundIconButton(
                          icon: Icons.share_outlined,
                          onTap: () {},
                        ),
                      ),
                      Positioned(
                        top: 52,
                        right: 14,
                        child: _RoundIconButton(
                          icon: _saved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          filled: _saved,
                          onTap: () => setState(() => _saved = !_saved),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x73000000),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '1 / 24',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const <Widget>[
                            _Badge(
                              text: 'Cafe',
                              fg: AppColors.primary,
                              bg: Color(0x29F25D3A),
                            ),
                            _Badge(
                              text: 'Open',
                              fg: AppColors.openGreen,
                              bg: AppColors.openGreenBg,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Driftwood Coffee', style: text.displayLarge),
                        const SizedBox(height: 8),
                        Row(
                          children: const <Widget>[
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: 6),
                            Text('312 reviews'),
                            SizedBox(width: 6),
                            Text('·'),
                            SizedBox(width: 6),
                            Text('\$\$'),
                            SizedBox(width: 6),
                            Text('·'),
                            SizedBox(width: 6),
                            Text('0.2 mi'),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Neighborhood third-wave cafe with single-origin pours and sourdough toasts.',
                          style: text.bodyLarge?.copyWith(
                            color: AppColors.ink.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          crossAxisCount: 4,
                          childAspectRatio: 1.0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          children: const <Widget>[
                            _QuickAction(icon: Icons.route_rounded, label: 'Directions'),
                            _QuickAction(icon: Icons.call_outlined, label: 'Call'),
                            _QuickAction(icon: Icons.language_rounded, label: 'Website'),
                            _QuickAction(icon: Icons.share_outlined, label: 'Share'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            children: <Widget>[
                              _InfoRow(
                                icon: Icons.location_on_outlined,
                                title: '218 Elm St',
                                subtitle: 'Oakland, CA 94607',
                              ),
                              Divider(height: 1),
                              _InfoRow(
                                icon: Icons.access_time_rounded,
                                title: 'Open until 7:00 PM',
                                subtitle: 'Mon-Fri 7a-8p · Sat 8a-6p',
                              ),
                              Divider(height: 1),
                              _InfoRow(
                                icon: Icons.language_rounded,
                                title: 'driftwood.coffee',
                                subtitle: 'Website',
                                last: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _Section(
                          title: 'Photos',
                          action: 'See all',
                          child: _photoGrid(),
                        ),
                        const SizedBox(height: 24),
                        _Section(
                          title: 'Recent reviews',
                          action: 'All reviews',
                          child: Column(
                            children: const <Widget>[
                              _ReviewSummary(),
                              SizedBox(height: 10),
                              _ReviewCard(
                                name: 'Maya L.',
                                when: '2d ago',
                                rating: 5,
                                text:
                                    'Genuinely the best pour-over in the neighborhood. The sourdough toast with honey is unreal.',
                              ),
                              _ReviewCard(
                                name: 'Theo R.',
                                when: '1w ago',
                                rating: 4,
                                text:
                                    'Nice vibe, friendly staff, quick wifi. My go-to remote-work spot lately.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _Section(
                          title: 'Location',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.border),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: AppColors.primary,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '218 Elm St, Oakland, CA',
                                style: text.bodySmall?.copyWith(
                                  color: AppColors.inkSoft,
                                ),
                              ),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    AppColors.bg.withValues(alpha: 0),
                    AppColors.bg.withValues(alpha: 0.95),
                    AppColors.bg,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoGrid() {
    final List<Color> colors = <Color>[
      const Color(0xFFF1B599),
      const Color(0xFFD99273),
      const Color(0xFFE4B2A1),
      const Color(0xFFC88470),
      const Color(0xFFAA6E5D),
    ];
    return SizedBox(
      height: 186,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[colors[1], colors[2]],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[colors[2], colors[3]],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[colors[3], colors[4]],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors[4],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '+19',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreHeroGraphic extends StatelessWidget {
  const _StoreHeroGraphic();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFFF6EDE6), Color(0xFFEFE2D9)],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(height: 84, color: const Color(0xFFD8C8BC)),
          ),
          Positioned(
            left: 140,
            right: 140,
            bottom: 40,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFDF8F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCEB9A7), width: 2),
              ),
            ),
          ),
          Positioned(
            left: 126,
            right: 126,
            bottom: 146,
            child: Container(
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFB55A3D),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 18),
            ),
          ),
          Positioned(
            left: 172,
            right: 172,
            bottom: 40,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF9D5D46),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primary : Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 18,
            color: filled ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.fg, required this.bg});

  final String text;
  final Color fg;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.last = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.chipBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.inkFaint,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 16),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.action});

  final String title;
  final String? action;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            if (action != null)
              Text(
                action!,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _ReviewSummary extends StatelessWidget {
  const _ReviewSummary();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text(
          '4.8',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: List<Widget>.generate(
                5,
                (_) => const Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Based on 312 reviews',
              style: TextStyle(fontSize: 12, color: AppColors.inkSoft),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.name,
    required this.when,
    required this.rating,
    required this.text,
  });

  final String name;
  final String when;
  final int rating;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.accent.withValues(alpha: 0.18),
                child: Text(
                  name.substring(0, 1),
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 6),
              Text(
                '· $when',
                style: const TextStyle(fontSize: 12, color: AppColors.inkFaint),
              ),
              const Spacer(),
              Row(
                children: List<Widget>.generate(
                  rating,
                  (_) => const Icon(Icons.star_rounded, size: 11, color: AppColors.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                color: AppColors.ink.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
