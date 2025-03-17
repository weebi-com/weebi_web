import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/utils/app_focus_helper.dart';
import 'package:web_admin/views/widgets/card_elements.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/services/user_service.dart';
import '../../../core/theme/theme_extensions/app_button_theme.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();
  bool _isLoading = false;

  final UserService _userService = UserService();

  void _doSubmit(BuildContext context) async {
    AppFocusHelper.instance.requestUnfocus();

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _userService.createPendingUser(
          mail: _formKey.currentState!.value['mail'],
          firstname: _formKey.currentState!.value['firstname'],
          lastname: _formKey.currentState!.value['lastname'],
          countryCode: _formKey.currentState!.value['countryCode'],
          phone: _formKey.currentState!.value['phone'],
        );
        setState(() {
          _isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title:
          "L'utilisateur  ${response.userPublic.firstname} a bien été créé.",
          width: kDialogWidth,
          btnOkText: 'OK',
          btnOkOnPress: () => GoRouter.of(context).go(RouteUri.listUser),
        ).show();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Erreur",
          desc: "Erreur lors de la création de l'utilisateur: ${e.toString()}",
          btnOkText: 'OK',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    const pageTitle = 'Créer un utilisateur (permissions vendeur)';

    return PortalMasterLayout(
      selectedMenuUri: RouteUri.crud,
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            pageTitle,
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
                    title: pageTitle,
                  ),
                  CardBody(
                    child: _content(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);

    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
            child: FormBuilderTextField(
              name: 'firstname',
              decoration: const InputDecoration(
                labelText: 'Prénom',
                hintText: 'Prénom',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.firstname,
              validator: FormBuilderValidators.required(
                  errorText: 'Le prénom est requis'),
              onSaved: (value) => {_formData.firstname = value ?? ''},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
            child: FormBuilderTextField(
              name: 'lastname',
              decoration: const InputDecoration(
                labelText: 'Nom',
                hintText: 'Nom',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.lastname,
              validator: FormBuilderValidators.required(
                  errorText: 'Le nom est requis'),
              onSaved: (value) => {_formData.lastname = value ?? ''},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
            child: Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    keyboardType: TextInputType.number,
                    name: 'countryCode',
                    decoration: const InputDecoration(
                      labelText: 'Indicatif',
                      hintText: 'Indicatif',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "L'indicatif est requis !"),
                      FormBuilderValidators.integer(
                          errorText: "L'indicatif doit être un nombre entier."),
                    ]),
                    onSaved: (value) => _formData.countryCode = _formData.countryCode = value ?? '',
                  ),
                ),
                const SizedBox(width: kDefaultPadding),
                Expanded(
                  child: FormBuilderTextField(
                    keyboardType: TextInputType.number,
                    name: 'phone',
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      hintText: 'Téléphone',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    initialValue: _formData.phone,
                    validator: FormBuilderValidators.required(
                        errorText: 'Le numéro de téléphone est requis'),
                    onSaved: (value) => {_formData.phone = value ?? ''},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
            child: FormBuilderTextField(
              name: 'mail',
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Email',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.mail,
              validator: FormBuilderValidators.required(
                  errorText: "L'email est requis"),
              onSaved: (value) => {_formData.mail = value ?? ''},
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBackButton(context, themeData, lang),
              const Spacer(),
              _buildSubmitButton(context, themeData, lang),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(
      BuildContext context, ThemeData themeData, Lang lang) {
    return SizedBox(
      height: 40.0,
      child: ElevatedButton(
        style: themeData.extension<AppButtonTheme>()!.secondaryElevated,
        onPressed: () => GoRouter.of(context).go(RouteUri.listUser),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: kDefaultPadding * 0.5),
              child: Icon(
                Icons.arrow_circle_left_outlined,
                size: (themeData.textTheme.labelLarge!.fontSize! + 4.0),
              ),
            ),
            Text(lang.crudBack),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, ThemeData themeData, Lang lang) {
    return SizedBox(
      height: 40.0,
      child: ElevatedButton(
        style: themeData.extension<AppButtonTheme>()!.successElevated,
        onPressed: () => _doSubmit(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: kDefaultPadding * 0.5),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: (themeData.textTheme.labelLarge!.fontSize! + 4.0),
              ),
            ),
            Text(lang.submit),
          ],
        ),
      ),
    );
  }
}

class FormData {
  String firstname = '';
  String lastname = '';
  String mail = '';
  String countryCode = '';
  String phone = '';
}
