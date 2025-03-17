import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:protos_weebi/protos_weebi_io.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/views/widgets/card_elements.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

import '../../../app_router.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/services/chain_service.dart';
import '../../../core/theme/theme_extensions/app_button_theme.dart';
import '../../../core/theme/theme_extensions/app_color_scheme.dart';
import '../../../core/theme/theme_extensions/app_data_table_theme.dart';

class ListChainScreen extends StatefulWidget {
  const ListChainScreen({super.key});

  @override
  State<ListChainScreen> createState() => _ListChainScreenState();
}

class _ListChainScreenState extends State<ListChainScreen> {
  final ChainService _chainService = ChainService();
  late Future<ReadAllChainsResponse> chains;
  String? errorMessage;
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _loadAllChains();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAllChains() async {
    setState(() {
      chains = _chainService.readAllChains();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = themeData.extension<AppColorScheme>()!;
    final appDataTableTheme = themeData.extension<AppDataTableTheme>()!;

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            'Gestions des chaines',
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardHeader(
                    title: 'Mes chaines',
                  ),
                  CardBody(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: kDefaultPadding * 2.0),
                          child: FormBuilder(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: kDefaultPadding,
                                runSpacing: kDefaultPadding,
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 300.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: kDefaultPadding * 1.5),
                                      child: FormBuilderTextField(
                                        name: 'search',
                                        decoration: InputDecoration(
                                          labelText: lang.search,
                                          hintText: lang.search,
                                          border: const OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: kDefaultPadding),
                                        child: SizedBox(
                                          height: 40.0,
                                          child: ElevatedButton(
                                            style: themeData
                                                .extension<AppButtonTheme>()!
                                                .infoElevated,
                                            onPressed: () {},
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right:
                                                              kDefaultPadding *
                                                                  0.5),
                                                  child: Icon(
                                                    Icons.search,
                                                    size: (themeData
                                                            .textTheme
                                                            .labelLarge!
                                                            .fontSize! +
                                                        4.0),
                                                  ),
                                                ),
                                                Text(lang.search),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40.0,
                                        child: ElevatedButton(
                                          style: themeData
                                              .extension<AppButtonTheme>()!
                                              .successElevated,
                                          onPressed: () => GoRouter.of(context)
                                              .go(RouteUri.createChain),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right:
                                                        kDefaultPadding * 0.5),
                                                child: Icon(
                                                  Icons.add,
                                                  size: (themeData
                                                          .textTheme
                                                          .labelLarge!
                                                          .fontSize! +
                                                      4.0),
                                                ),
                                              ),
                                              Text(lang.crudNew),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              final double dataTableWidth =
                                  max(kScreenWidthMd, constraints.maxWidth);

                              return Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _scrollController,
                                  child: SizedBox(
                                    width: dataTableWidth,
                                    child: Theme(
                                      data: themeData.copyWith(
                                        cardTheme: appDataTableTheme.cardTheme,
                                        dataTableTheme: appDataTableTheme
                                            .dataTableThemeData,
                                      ),
                                      child: FutureBuilder<ReadAllChainsResponse>(
                                        future: _chainService.readAllChains(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Erreur: ${snapshot.error}');
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.chains.isEmpty) {
                                            return const Center(
                                                child: Text(
                                                    'Aucune chaine trouvé'));
                                          }

                                          final currentChains = snapshot.data!;
                                          return PaginatedDataTable(
                                            source: DataSource(
                                              chains: currentChains,
                                              onDetailButtonPressed: (chain) {
                                                GoRouter.of(context).go(RouteUri.detailChain, extra: chain);
                                              },
                                            ),
                                            rowsPerPage: 10,
                                            showCheckboxColumn: false,
                                            showFirstLastButtons: true,
                                            columns: const [
                                              DataColumn(label: Text('Nom')),
                                              DataColumn(
                                                  label: Text('Boutiques')),  DataColumn(
                                                  label: Text('Nbre Boutiques')),
                                              DataColumn(
                                                  label: Text('Actions')),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class DataSource extends DataTableSource {
  final ReadAllChainsResponse chains;
  final void Function(Chain chain) onDetailButtonPressed;

  DataSource({
    required this.chains,
    required this.onDetailButtonPressed,
  });


  @override
  DataRow? getRow(int index) {
    final chain = chains.chains[index];
    final List<String> boutiqueNames = chain.boutiques.map((boutique) => boutique.name).toList();

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(chain.name)),
      DataCell(Expanded(
        child: Text(
          boutiqueNames.join(', '),
          overflow: TextOverflow.ellipsis,
        ),
      ),),
      DataCell(Text(chain.boutiques.length.toString())),
      DataCell(
        Row(
          children: [
            OutlinedButton(
              onPressed: () => onDetailButtonPressed(chain),
              child: const Text("Détails"),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => chains.chains.length;

  @override
  int get selectedRowCount => 0;
}
