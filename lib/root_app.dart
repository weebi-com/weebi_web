import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/environment.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/grpc/server.dart';
import 'package:web_admin/providers/app_preferences_provider.dart';
import 'package:web_admin/providers/server.dart';
import 'package:web_admin/providers/user_data_provider.dart';
import 'package:web_admin/token/token.dart';
import 'package:web_admin/utils/app_focus_helper.dart';

import 'core/theme/themes.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  GoRouter? _appRouter;

  Future<bool>? _future;

  Future<bool> _getScreenDataAsync(
      AppPreferencesProvider appPreferencesProvider,
      UserDataProvider userDataProvider) async {
    await appPreferencesProvider.loadAsync();
    await userDataProvider.loadAsync();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // consider reviewing
        ChangeNotifierProvider(create: (context) => UserDataProvider()),

        /// locale and dark mode
        ChangeNotifierProvider(create: (context) => AppPreferencesProvider()),

        Provider<AccessTokenObject>(create: (_) => AccessTokenObject()),
        ChangeNotifierProxyProvider<AccessTokenObject, AccessTokenProvider>(
            create: (context) =>
                AccessTokenProvider(context.read<AccessTokenObject>()),
            update: (context, access, accessProvider) =>
                accessProvider!..accessToken = access.value),

        //
        ChangeNotifierProxyProvider(
          create: (BuildContext context) => ArticleServiceClientProvider(
              GrpcWebClientChannelWeebi(env).clientChannel,
              context.read<AccessTokenProvider>().accessToken),
          update: (
            BuildContext context,
            AccessTokenObject accessToken,
            ArticleServiceClientProvider? provider2,
          ) =>
              provider2!..serviceClient = accessToken.value,
        ),
        ChangeNotifierProxyProvider(
          create: (BuildContext context) => ContactServiceClientProvider(
              GrpcWebClientChannelWeebi(env).clientChannel,
              context.read<AccessTokenProvider>().accessToken),
          update: (
            BuildContext context,
            AccessTokenObject accessToken,
            ContactServiceClientProvider? provider2,
          ) =>
              provider2!..serviceClient = accessToken.value,
        ),
        ChangeNotifierProxyProvider(
          create: (BuildContext context) => FenceServiceClientProvider(
              GrpcWebClientChannelWeebi(env).clientChannel,
              context.read<AccessTokenProvider>().accessToken),
          update: (
            BuildContext context,
            AccessTokenObject accessToken,
            FenceServiceClientProvider? provider2,
          ) =>
              provider2!..serviceClient = accessToken.value,
        ),
        ChangeNotifierProxyProvider(
          create: (BuildContext context) => TicketServiceClientProvider(
              GrpcWebClientChannelWeebi(env).clientChannel,
              context.read<AccessTokenProvider>().accessToken),
          update: (
            BuildContext context,
            AccessTokenObject accessToken,
            TicketServiceClientProvider? provider2,
          ) =>
              provider2!..serviceClient = accessToken.value,
        ),
      ],
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              // Tap anywhere to dismiss soft keyboard.
              AppFocusHelper.instance.requestUnfocus();
            },
            child: FutureBuilder<bool>(
              initialData: null,
              future: (_future ??= _getScreenDataAsync(
                  context.read<AppPreferencesProvider>(),
                  context.read<UserDataProvider>())),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!) {
                  return Consumer<AppPreferencesProvider>(
                    builder: (context, provider, child) {
                      _appRouter ??=
                          appRouter(context.read<UserDataProvider>());

                      return MaterialApp.router(
                        debugShowCheckedModeBanner: false,
                        routeInformationProvider:
                            _appRouter!.routeInformationProvider,
                        routeInformationParser:
                            _appRouter!.routeInformationParser,
                        routerDelegate: _appRouter!.routerDelegate,
                        supportedLocales: Lang.delegate.supportedLocales,
                        localizationsDelegates: const [
                          Lang.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                          FormBuilderLocalizations.delegate,
                        ],
                        locale: provider.locale,
                        onGenerateTitle: (context) => Lang.of(context).appTitle,
                        theme: AppThemeData.instance.light(),
                        darkTheme: AppThemeData.instance.dark(),
                        themeMode: provider.themeMode,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
