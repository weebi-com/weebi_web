import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/core/constants/dimens.dart';
import 'package:web_admin/core/theme/theme_extensions/app_color_scheme.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/providers/user_data_provider.dart';
import 'package:web_admin/token/jwt.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';
// import 'package:web_admin/core/theme/theme_extensions/app_data_table_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    // final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;
    final size = MediaQuery.of(context).size;

    final summaryCardCrossAxisCount = (size.width >= kScreenWidthLg ? 4 : 2);

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          const SizedBox(height: 8),
          /* ListTile(
            leading: const Icon(Icons.search),
            title: TextField(
              controller: TextEditingController(
                  text: 'recherche dynamique des tuiles ci-dessous'),
            ),
          ), */
          //Text(
          //  lang.dashboard,
          //  style: themeData.textTheme.headlineMedium,
          //),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final summaryCardWidth = ((constraints.maxWidth -
                        (kDefaultPadding * (summaryCardCrossAxisCount - 1))) /
                    summaryCardCrossAxisCount);
                return Wrap(
                  direction: Axis.horizontal,
                  spacing: kDefaultPadding,
                  runSpacing: kDefaultPadding,
                  children: [
                    GestureDetector(
                      child: SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Ma Firme',
                        icon: Icons.business,
                        backgroundColor: Colors.lightBlue,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      onTap: () {
                        GoRouter.of(context).go(RouteUri.firmDetail);
                      },
                    ),
                    GestureDetector(
                      child: SummaryCard(
                        title: lang.pendingIssues(2),
                        value:
                            'Mes boutiques', // TODO include chaines de if + 1 chain
                        icon: Icons.store,
                        backgroundColor: Colors.blue,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      onTap: () {
                        GoRouter.of(context).go(RouteUri.listChain);
                      },
                    ),
                    GestureDetector(
                      child: SummaryCard(
                        title: lang.newUsers(2),
                        value: 'Utilisateurs',
                        icon: Icons.group_add_rounded,
                        backgroundColor: appColorScheme.warning,
                        textColor: appColorScheme.buttonTextBlack,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      onTap: () {
                        GoRouter.of(context).go(RouteUri.listUser);
                      },
                    ),

                    // NOT READY YET
/*                     InkWell(
                      child: SummaryCard(
                        title: lang.newOrders(2),
                        value: 'Contacts',
                        icon: Icons.person,
                        backgroundColor: Colors.blue,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      onTap: () {
                        final chainId = JsonWebToken.parse(
                                context.read<UserDataProvider>().accessToken)
                            .permissions
                            .firmId; // first chainId == firmId, making it simple
                        GoRouter.of(context)
                            .go(RouteUri.contacts, extra: chainId);
                      },
                    ), */
/*                     GestureDetector(
                      child: SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Boutiques',
                        icon: Icons.store,
                        backgroundColor: Colors.teal,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      onTap: () {
                        GoRouter.of(context).go(RouteUri.listBoutique);
                      },
                    ), */
                    // mockup ok, now no point displaying until functionnal
                    if (2 + 2 == 5) ...[
                      SummaryCard(
                        title: lang.newOrders(2),
                        value: 'Vente',
                        icon: Icons.point_of_sale,
                        backgroundColor: appColorScheme.info,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.newOrders(2),
                        value: 'Vente hors-catalogue',
                        icon: Icons.point_of_sale,
                        backgroundColor: appColorScheme.info,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Achat',
                        icon: Icons.shopping_cart_rounded,
                        backgroundColor: appColorScheme.error,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Achat/dépense hors catalogue',
                        icon: Icons.shopping_cart_rounded,
                        backgroundColor: appColorScheme.error,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Mouvement de stock',
                        icon: Icons.warehouse,
                        backgroundColor: appColorScheme.error,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Faire un inventaire',
                        icon: Icons.warehouse,
                        backgroundColor: appColorScheme.success,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.newOrders(2),
                        value: 'Articles',
                        icon: Icons.widgets,
                        backgroundColor: Colors.orange,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Articles Import/Export',
                        icon: Icons.file_download,
                        backgroundColor: Colors.orange,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Articles photos Import/Export',
                        icon: Icons.image,
                        backgroundColor: Colors.orange,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),

                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Contacts Import/Export',
                        icon: Icons.file_download,
                        backgroundColor: Colors.blue,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Tickets',
                        icon: Icons.receipt,
                        backgroundColor: Colors.grey,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Tickets Import/Export',
                        icon: Icons.file_download,
                        backgroundColor: Colors.grey,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.todaySales,
                        value: 'Stats',
                        icon: Icons.ssid_chart_rounded,
                        backgroundColor: appColorScheme.success,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Taxes',
                        icon: Icons.cut,
                        backgroundColor: Colors.red[800]!,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      const Divider(),

                      /// Accessoires
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Imprimante',
                        icon: Icons.print,
                        backgroundColor: Colors.lightBlue,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: lang.pendingIssues(2),
                        value: 'Lecteur de code barre',
                        icon: Icons.barcode_reader,
                        backgroundColor: Colors.lightBlue,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double width;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 120.0,
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: backgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: kDefaultPadding * 0.3,
              right: kDefaultPadding * 0.5,
              child: Icon(
                icon,
                size: 80.0,
                color: iconColor,
              ),
            ),
            Positioned(
              bottom: kDefaultPadding * 0.2,
              left: kDefaultPadding * 0.5,
              child: Padding(
                padding: const EdgeInsets.only(bottom: kDefaultPadding * 0.5),
                child: SizedBox(
                  width: width / 1.5,
                  child: Text(
                    value,
                    style: textTheme.headlineSmall!.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.clip),
                    //Text(
                    //title,
                    //style: textTheme.labelLarge!.copyWith(
                    //  color: textColor,
                    //),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
