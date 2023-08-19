import 'package:flutter/material.dart';
import 'package:passman/app_theme.dart';

class PMAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showAppBar;

  const PMAppBar({super.key, required this.title, this.showAppBar = true});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (!showAppBar) {
      return const SizedBox.shrink();
    }

    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: AppTheme.primaryColor,
    );
  }
}
