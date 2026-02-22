import 'package:auth_weebi/auth_weebi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_weebi/users_weebi.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

/// Users view using users_weebi package, embedded in the app's
/// PortalMasterLayout so global navigation (back to home, sidebar) remains available.
class UsersPackageScreen extends StatelessWidget {
  const UsersPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionProvider = context.read<PermissionProvider>();
    final currentUserId = permissionProvider.userId;
    return PortalMasterLayout(
      selectedMenuUri: RouteUri.listUser,
      body: UserRoutes.buildUserListWithCustomScaffold(
        currentUserId: currentUserId,
        appBar: null, // PortalMasterLayout provides the AppBar
        drawer: null,
        endDrawer: null,
      ),
    );
  }
}
