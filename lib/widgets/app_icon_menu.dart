import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';

class AppIconMenuItem {
  final IconData icon;

  /// Not shown; used for screen readers.
  final String label;
  final VoidCallback onTap;

  const AppIconMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// ⋮ app-bar button that opens a narrow, icon-only menu.
class AppIconMenu extends StatelessWidget {
  final List<AppIconMenuItem> items;

  const AppIconMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'Options',
      icon: const Icon(AppIcons.more),
      position: PopupMenuPosition.under,
      constraints: const BoxConstraints(minWidth: 56, maxWidth: 56),
      onSelected: (i) => items[i].onTap(),
      itemBuilder: (_) => [
        for (var i = 0; i < items.length; i++)
          PopupMenuItem(
            value: i,
            height: AppSpacing.xxxl,
            child: Center(
              child: Icon(
                items[i].icon,
                size: 20,
                color: AppColors.textPrimary,
                semanticLabel: items[i].label,
              ),
            ),
          ),
      ],
    );
  }
}
