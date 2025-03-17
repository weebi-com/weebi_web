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
import '../../../core/services/user_service.dart';
import '../../../core/theme/theme_extensions/app_button_theme.dart';
import '../../../core/theme/theme_extensions/app_color_scheme.dart';
import '../../../core/theme/theme_extensions/app_data_table_theme.dart';

class ListUserScreen extends StatefulWidget {
  const ListUserScreen({super.key});

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  final UserService _userService = UserService();
  late Future<UsersPublic> users;
  String? errorMessage;
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAllUsers() async {
    setState(() {
      users = _userService.readAllUsers();
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
            'Gestions des utilisateurs',
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
                    title: 'Mes utilisateurs',
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
                                              .go(RouteUri.createUser),
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
                                      child: FutureBuilder<UsersPublic>(
                                        future: _userService.readAllUsers(),
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
                                              snapshot.data!.users.isEmpty) {
                                            return const Center(
                                                child: Text(
                                                    'Aucun utilisateur trouvé'));
                                          }

                                          final userList = snapshot.data!;
                                          return PaginatedDataTable(
                                            source: DataSource(
                                              users: userList,
                                              onDetailButtonPressed: (data) {
                                                // GoRouter.of(context).go('/user-detail?id=${data['id']}');
                                              },
                                              onDeleteButtonPressed: (data) {
                                                // TODO: first ask if user is really sure
                                                _deleteUser(data['id']);
                                              },
                                            ),
                                            rowsPerPage: 10,
                                            showCheckboxColumn: false,
                                            showFirstLastButtons: true,
                                            columns: const [
                                              DataColumn(label: Text('Prénom')),
                                              DataColumn(label: Text('Nom')),
                                              DataColumn(
                                                  label: Text('Téléphone')),
                                              DataColumn(label: Text('Email')),
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

  Future<void> _deleteUser(String userId) async {
    try {
      await _userService.deleteOneUser(userId: userId);
      _loadAllUsers();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Utilisateur supprimé')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur de suppression: $e')));
    }
  }
}

class DataSource extends DataTableSource {
  final UsersPublic users;
  final void Function(Map<String, dynamic> data) onDetailButtonPressed;
  final void Function(Map<String, dynamic> data) onDeleteButtonPressed;

  DataSource({
    required this.users,
    required this.onDetailButtonPressed,
    required this.onDeleteButtonPressed,
  });

  @override
  DataRow? getRow(int index) {
    final user = users.users[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(user.firstname)),
      DataCell(Text(user.lastname)),
      DataCell(Text("${user.phone.countryCode}${user.phone.number}")),
      DataCell(Text(user.mail)),
      DataCell(Row(
        children: [
          OutlinedButton(
            onPressed: () => onDetailButtonPressed({'id': user.userId}),
            child: const Text("Voir"),
          ),
          OutlinedButton(
            onPressed: () => onDeleteButtonPressed({'id': user.userId}),
            child: const Text("Supprimer"),
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.users.length;

  @override
  int get selectedRowCount => 0;
}
