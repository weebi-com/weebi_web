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
import '../../../core/services/chain_service.dart';
import '../../../core/theme/theme_extensions/app_button_theme.dart';

class CreateChainScreen extends StatefulWidget {
  const CreateChainScreen({super.key});

  @override
  State<CreateChainScreen> createState() => _CreateChainScreenState();
}

class _CreateChainScreenState extends State<CreateChainScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();
  bool _isLoading = false;

  final ChainService _chainService = ChainService();

  void _doSubmit(BuildContext context) async {
    AppFocusHelper.instance.requestUnfocus();

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _chainService.createOneChain(
          name: _formKey.currentState!.value['name'],
        );
        setState(() {
          _isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title:
          "La chaine  ${response.message} a bien été créé.",
          width: kDialogWidth,
          btnOkText: 'OK',
          btnOkOnPress: () => GoRouter.of(context).go(RouteUri.listChain),
        ).show();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Erreur",
          desc: "Erreur lors de la création de la chaine: ${e.toString()}",
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
    const pageTitle = 'Créer une chaine';

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
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'Nom de la chaine',
                hintText: 'Nom',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.name,
              validator: FormBuilderValidators.required(
                  errorText: 'Le nom est requis'),
              onSaved: (value) => {_formData.name = value ?? ''},
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
        onPressed: () => GoRouter.of(context).go(RouteUri.listChain),
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
  String name = '';
}
