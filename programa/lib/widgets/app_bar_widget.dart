import 'package:flutter/material.dart';
import 'package:programa/Styles/Text.dart';
import 'package:programa/Styles/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogoutButton;
  final VoidCallback? onLogout;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showLogoutButton = false,
    this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primay,
      foregroundColor: AppColors.secondary,
      centerTitle: true,
      leadingWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: SizedBox(
          width: 100,
          height: 48,
          child: Image.asset(
            'assets/images/LogoUdec.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(title, style: TextStyles.sansTitle),
      actions: showLogoutButton
          ? [
              IconButton(
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
                tooltip: 'Cerrar sesión',
              ),
              const SizedBox(width: 8),
            ]
          : null,
    );
  }
}