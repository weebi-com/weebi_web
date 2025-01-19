import 'package:go_router/go_router.dart';
import 'package:protos_weebi/protos_weebi_io.dart';
import 'package:provider/provider.dart';
import 'package:web_admin/contacts/view/contacts_page.dart';
import 'package:web_admin/providers/user_data_provider.dart';
import 'package:web_admin/views/screens/buttons_screen.dart';
import 'package:web_admin/views/screens/boutiques/create_chain_screen.dart';
import 'package:web_admin/views/screens/boutiques/detail_chain_screen.dart';
import 'package:web_admin/views/screens/boutiques/list_chains_screen.dart';
import 'package:web_admin/views/screens/colors_screen.dart';
import 'package:web_admin/views/screens/crud_detail_screen.dart';
import 'package:web_admin/views/screens/crud_screen.dart';
import 'package:web_admin/views/screens/dashboard_screen.dart';
import 'package:web_admin/views/screens/dialogs_screen.dart';
import 'package:web_admin/views/screens/error_screen.dart';
import 'package:web_admin/views/screens/firm/create_firm_screen.dart';
import 'package:web_admin/views/screens/firm/firm_view_screen.dart';
import 'package:web_admin/views/screens/form_screen.dart';
import 'package:web_admin/views/screens/general_ui_screen.dart';
import 'package:web_admin/views/screens/iframe_demo_screen.dart';
import 'package:web_admin/views/screens/authentication/login_screen.dart';
import 'package:web_admin/views/screens/authentication/logout_screen.dart';
import 'package:web_admin/views/screens/my_profile_screen.dart';
import 'package:web_admin/views/screens/authentication/register_screen.dart';
import 'package:web_admin/views/screens/text_screen.dart';
import 'package:web_admin/views/screens/users/create_user_screen.dart';
import 'package:web_admin/views/screens/users/list_users_screen.dart';
import 'package:web_admin/views/screens/boutiques/create_boutique_screen.dart';

class RouteUri {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String myProfile = '/my-profile';
  static const String logout = '/logout';
  static const String form = '/form';
  static const String generalUi = '/general-ui';
  static const String colors = '/colors';
  static const String text = '/text';
  static const String buttons = '/buttons';
  static const String dialogs = '/dialogs';
  static const String error404 = '/404';
  static const String login = '/login';
  static const String register = '/register';
  static const String crud = '/crud';
  static const String crudDetail = '/crud-detail';
  static const String iframe = '/iframe';

  static const String firmDetail = '/firm';
  static const String createFirm = '/create-firm';

  static const String contacts = '/contacts';

  static const String listUser = '/list-user';
  static const String createUser = '/create-user';

  static const String listChain = '/list-chain';
  static const String createChain = '/create-chain';
  static const String detailChain = '/detail-chain';
  static const String updateChain = '/update-chain'; // TODO
  static const String deleteChain = '/delete-chain'; // TODO

  static const String listBoutique = '/list-boutique';
  static const String createBoutique = '/create-boutique';
}

const List<String> unrestrictedRoutes = [
  RouteUri.error404,
  RouteUri.logout,
  RouteUri.login, // Remove this line for actual authentication flow.
  RouteUri.register, // Remove this line for actual authentication flow.
];

const List<String> publicRoutes = [
  // RouteUri.login, // Enable this line for actual authentication flow.
  // RouteUri.register, // Enable this line for actual authentication flow.
];

GoRouter appRouter(UserDataProvider userDataProvider) {
  return GoRouter(
    initialLocation: RouteUri.home,
    errorPageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: const ErrorScreen(),
    ),
    routes: [
      GoRoute(
        path: RouteUri.home,
        redirect: (context, state) => RouteUri.dashboard,
      ),
      GoRoute(
        path: RouteUri.dashboard,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.myProfile,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const MyProfileScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.logout,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LogoutScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.form,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const FormScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.generalUi,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const GeneralUiScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.colors,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const ColorsScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.text,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const TextScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.buttons,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const ButtonsScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.dialogs,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const DialogsScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.login,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.register,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const RegisterScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteUri.crud,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const CrudScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteUri.crudDetail,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: CrudDetailScreen(id: state.uri.queryParameters['id'] ?? ''),
          );
        },
      ),
      GoRoute(
        path: RouteUri.iframe,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const IFrameDemoScreen(),
        ),
      ),

      // =========================== FIRMS ===========================

      GoRoute(
        path: RouteUri.firmDetail,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const FirmListScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteUri.createFirm,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const CreateFirmScreen(),
          );
        },
      ),

      // =========================== USERS ===========================

      GoRoute(
        path: RouteUri.listUser,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const ListUserScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteUri.createUser,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const CreateUserScreen(),
          );
        },
      ),

      // =========================== CHAINS && BOUTIQUES ===========================

      GoRoute(
        path: RouteUri.listChain,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const ListChainScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteUri.createChain,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const CreateChainScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteUri.detailChain,
        pageBuilder: (context, state) {
          final chain = state.extra as Chain;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: DetailChainScreen(chain: chain),
          );
        },
      ),

      GoRoute(
        path: RouteUri.createBoutique,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const CreateBoutiqueScreen(),
          );
        },
      ),

      // =========================== CONTACTS ===========================

      GoRoute(
        path: RouteUri.contacts,
        pageBuilder: (context, state) {
          // TODO: this needs to be felxible depending on the chain selected
          final chainId = state.extra as String;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: ContactsPage(chainId),
          );
        },
      ),
    ],
    redirect: (context, state) {
      if (unrestrictedRoutes.contains(state.matchedLocation)) {
        return null;
      } else if (publicRoutes.contains(state.matchedLocation)) {
        // Is public route.
        if (userDataProvider.isUserLoggedIn()) {
          // User is logged in, redirect to home page.
          return RouteUri.home;
        }
      } else {
        // Not public route.
        if (!userDataProvider.isUserLoggedIn()) {
          // User is not logged in, redirect to login page.
          return RouteUri.login;
        }
      }

      return null;
    },
  );
}
