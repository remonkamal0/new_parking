import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test888/core/widgets/custom_text_field.dart';
import 'package:test888/generated/l10n/app_localizations.dart';

class MapSearchBar extends StatelessWidget {
  const MapSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: CustomTextField(
        hintText: l10n.searchParking,
        prefixIcon: IconButton(
          icon: const Icon(Icons.menu, color: Colors.grey),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        suffixIcon: const Icon(Icons.filter_list, color: Colors.grey),
      ),
    );
  }
}
