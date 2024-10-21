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
import '../../../core/services/boutique_service.dart';
import '../../../core/theme/theme_extensions/app_button_theme.dart';

class CreateBoutiqueScreen extends StatefulWidget {
  const CreateBoutiqueScreen({super.key});

  @override
  State<CreateBoutiqueScreen> createState() => _CreateBoutiqueScreenState();
}

class _CreateBoutiqueScreenState extends State<CreateBoutiqueScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  final BoutiqueService _boutiqueService = BoutiqueService();

  void _doSubmit(BuildContext context) async {
    AppFocusHelper.instance.requestUnfocus();

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _boutiqueService.createOneBoutique(
          name: _formKey.currentState!.value['name'],
          boutiqueId: _formKey.currentState!.value['boutiqueId'],
          chainId: _formKey.currentState!.value['chainId'],
          firmId: _formKey.currentState!.value['firmId'],
          code: _formKey.currentState!.value['code'],
          city: _formKey.currentState!.value['city'],
          code2Letters: _formKey.currentState!.value['code2Letters'],
          namel10n: _formKey.currentState!.value['namel10n'],
          latitude: double.tryParse(_formKey.currentState!.value['latitude']),
          longitude: double.tryParse(_formKey.currentState!.value['longitude']),
          street: _formKey.currentState!.value['street'],
        );
        setState(() {
          _isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title:
          "La boutique  ${response.message} a bien été créée.",
          width: kDialogWidth,
          btnOkText: 'OK',
          btnOkOnPress: () => GoRouter.of(context).go(RouteUri.listBoutique),
        ).show();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Erreur",
          desc: "Erreur lors de la création de la boutique: ${e.toString()}",
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
    const pageTitle = 'Créer une boutique';

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
          _buildTextField('name', 'Nom de la boutique', "Boutique"),
          _buildTextField('boutiqueId', 'ID de la boutique', 'Identifiant boutique'),
          _buildTextField('chainId', 'ID de la chaîne', 'Identifiant chaîne'),
          _buildTextField('firmId', 'ID de l\'entreprise', 'Identifiant entreprise'),
          _buildTextField('code', 'Code postal', 'Code postal'),
          _buildTextField('city', 'Ville', 'Ville'),
          _buildTextField('code2Letters', 'Code pays', 'Code à 2 lettres'),
          _buildTextField('namel10n', 'Nom pays', 'Nom du pays'),
          _buildTextField('latitude', 'Latitude', 'Coordonnées latitude'),
          _buildTextField('longitude', 'Longitude', 'Coordonnées longitude'),
          _buildTextField('street', 'Rue', 'Nom de la rue'),
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

  Widget _buildTextField(String name, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FormBuilderTextField(
        name: name,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        validator: FormBuilderValidators.required(),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, ThemeData themeData, Lang lang) {
    return ElevatedButton(
      onPressed: _isLoading ? null : () => _doSubmit(context),
      style: themeData.extension<AppButtonTheme>()!.primaryElevated,
      child: _isLoading
          ? const CircularProgressIndicator.adaptive()
          : Text(lang.submit),
    );
  }

  Widget _buildBackButton(BuildContext context, ThemeData themeData, Lang lang) {
    return ElevatedButton(
      onPressed: () => GoRouter.of(context).pop(),
      style: themeData.extension<AppButtonTheme>()!.primaryElevated,
      child: Text("Retour"),
    );
  }
}
