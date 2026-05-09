import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  final PageController _pageController = PageController();
  int _step = 0;

  final List<({String title, String body, IconData icon})> _slides =
      <({String title, String body, IconData icon})>[
    (
      title: 'Your neighborhood, in one place.',
      body:
          'Discover local cafes, shops, and services around you - curated and up to date.',
      icon: Icons.map_outlined,
    ),
    (
      title: 'Two views, one tap apart.',
      body:
          'Browse a map of what is nearby, or switch to a list and sort by distance, rating, or price.',
      icon: Icons.view_carousel_outlined,
    ),
    (
      title: 'Find exactly what you need.',
      body: 'Search by name, filter by category, and see open hours at a glance.',
      icon: Icons.manage_search_rounded,
    ),
    (
      title: 'Save the spots you love.',
      body: 'Bookmark places, build lists, and share them with friends.',
      icon: Icons.bookmark_border_rounded,
    ),
  ];

  void _goNext() {
    if (_step == _slides.length - 1) {
      context.go('/map');
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.bg,
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 8),
                  child: _step == _slides.length - 1
                      ? const SizedBox.shrink()
                      : TextButton(
                          onPressed: () => context.go('/map'),
                          child: const Text('Skip'),
                        ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int i) => setState(() => _step = i),
                itemCount: _slides.length,
                itemBuilder: (BuildContext context, int index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border, width: 1.5),
                            ),
                            child: Icon(
                              slide.icon,
                              size: 86,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          slide.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          slide.body,
                          style: const TextStyle(
                            fontSize: 15.5,
                            color: AppColors.inkSoft,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      _slides.length,
                      (int i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _step == i ? 24 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _step == i ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goNext,
                      child: Text(
                        _step == _slides.length - 1 ? 'Get started' : 'Continue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
