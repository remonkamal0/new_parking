import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test888/config/routes/app_routes.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/core/providers/app_language_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageProvider = context.watch<AppLanguageProvider>();
    final isArabic = languageProvider.isArabic;

    return Drawer(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.profileDetails);
            },
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
              accountName: Text(
                "Noname",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                "+201020349207",
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                child: Text(
                  "N",
                  style: TextStyle(fontSize: 24.sp, color: theme.primaryColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: theme.primaryColor),
                  title: Text(l10n.home),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.home);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.palette_outlined, color: theme.primaryColor),
                  title: Text(l10n.themeSettings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.themeSettings);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.devices, color: theme.primaryColor),
                  title: Text(l10n.devices),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.devices);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag_outlined, color: theme.primaryColor),
                  title: Text(l10n.shop),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.language, color: theme.primaryColor),
                  title: Text(l10n.language),
                  trailing: ToggleButtons(
                    isSelected: [!isArabic, isArabic],
                    onPressed: (index) {
                      final next = index == 0 ? const Locale('en') : const Locale('ar');
                      context.read<AppLanguageProvider>().setLocale(next);
                    },
                    constraints: BoxConstraints(minWidth: 44.w, minHeight: 32.h),
                    borderRadius: BorderRadius.circular(8.r),
                    children: const [
                      Text('EN'),
                      Text('AR'),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.support_agent, color: theme.primaryColor),
                  title: Text(l10n.support),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.support);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.signOut, style: const TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
