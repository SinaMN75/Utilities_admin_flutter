import 'package:flutter/material.dart';
import 'package:utilities_admin_flutter/responsive.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard/components/header.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard/components/my_files.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard/components/recent_files.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard/components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(final BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              const Header(),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        const MyFiles(),
                        const SizedBox(height: 16),
                        const RecentFiles(),
                        if (Responsive.isMobile(context)) const SizedBox(height: 16),
                        if (Responsive.isMobile(context)) const StorageDetails(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) const SizedBox(width: 16),
                  // On Mobile means if the screen is less than 850 we don't want to show it
                  if (!Responsive.isMobile(context))
                    const Expanded(
                      flex: 2,
                      child: StorageDetails(),
                    ),
                ],
              )
            ],
          ),
        ),
      );
}
