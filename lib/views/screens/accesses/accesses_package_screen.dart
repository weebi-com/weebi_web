import 'package:accesses_weebi/accesses_weebi.dart';
import 'package:auth_weebi/auth_weebi.dart' show PermissionProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protos_weebi/protos_weebi_io.dart' show UserPublic;
import 'package:web_admin/app_router.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

/// Accesses view using accesses_weebi package, embedded in the app's
/// PortalMasterLayout so global navigation remains available.
/// Uses a nested Navigator for AccessListWidget -> UserAccessWidget navigation.
class AccessesPackageScreen extends StatelessWidget {
  const AccessesPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionProvider = context.read<PermissionProvider>();
    final currentUserId = permissionProvider.userId;

    return PortalMasterLayout(
      selectedMenuUri: RouteUri.listAccess,
      body: Navigator(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == AccessRoutes.userAccess) {
            final args = settings.arguments;
            UserPublic? user;
            String? userId;
            if (args is UserPublic) {
              user = args;
            } else if (args is Map) {
              user = args['user'] as UserPublic?;
              userId = args['currentUserId'] as String?;
            }
            if (user != null) {
              return MaterialPageRoute<void>(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(
                      '${user!.firstname} ${user.lastname} - Access',
                    ),
                  ),
                  body: UserAccessWidget(
                    user: user,
                    currentUserId: userId,
                  ),
                ),
              );
            }
          }
          return MaterialPageRoute<void>(
            builder: (context) => _AccessListWithAppBar(
              currentUserId: currentUserId,
            ),
          );
        },
      ),
    );
  }
}

class _AccessListWithAppBar extends StatelessWidget {
  final String currentUserId;

  const _AccessListWithAppBar({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Access Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AccessProvider>().initialize();
            },
          ),
        ],
      ),
      body: AccessListWidget(currentUserId: currentUserId),
    );
  }
}
