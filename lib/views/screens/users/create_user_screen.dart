import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:users_weebi/users_weebi.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

/// Create-user flow embedded in the admin shell (GoRouter — not [Navigator.pushNamed]).
class CreateUserScreen extends StatelessWidget {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PortalMasterLayout(
      selectedMenuUri: RouteUri.listUser,
      body: UserCreateView(
        showFloatingActionButton: false,
        onUserCreated: (ctx, _) {
          GoRouter.of(ctx).go(RouteUri.listAccess);
        },
      ),
    );
  }
}
