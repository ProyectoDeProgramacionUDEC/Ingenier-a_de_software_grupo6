import 'package:flutter/material.dart';
import 'package:programa/Styles/Text.dart';
import 'package:programa/Styles/app_colors.dart';

class UdecAppBarRightLogo extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String logoAsset; // e.g. 'assets/images/LogoUdec.png'
  final bool centerTitle;

  const UdecAppBarRightLogo({
    super.key,
    required this.title,
    this.logoAsset = 'assets/images/LogoUdec.png',
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primay,
      foregroundColor: AppColors.secondary,
      centerTitle: centerTitle,
      title: Text(title, style: TextStyles.sansTitle),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Image.asset(
            logoAsset,
            height: 60,
            width: 150,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
