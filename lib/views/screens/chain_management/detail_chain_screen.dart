import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:protos_weebi/protos_weebi_io.dart';
import '../../../app_router.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/services/device_service.dart';
import '../../../generated/l10n.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';

class DetailChainScreen extends StatefulWidget {
  final Chain chain;

  const DetailChainScreen({super.key, required this.chain});

  @override
  _DetailChainScreenState createState() => _DetailChainScreenState();
}

class _DetailChainScreenState extends State<DetailChainScreen> {
  final DeviceService _deviceService = DeviceService();
  Map<String, bool> _loadingStatus = {};

  @override
  Widget build(BuildContext context) {
    final boutiques = widget.chain.boutiques;
    final themeData = Theme.of(context);
    const pageTitle = 'Détail de la chaîne';

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nom de la chaîne : ${widget.chain.name}'),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 400, // Fixe la hauteur du ListView
                          child: ListView.builder(
                            itemCount: boutiques.length,
                            itemBuilder: (context, index) {
                              final boutique = boutiques[index];
                              final isLoading =
                                  _loadingStatus[boutique.boutiqueId] ?? false;

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text('Boutique : ${boutique.name}'),
                                  subtitle: Text(
                                      'Adresse : ${boutique.boutique.addressFull.toString()}'),
                                  trailing: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => _generatePairingCodeForBoutique(
                                              boutique.boutiqueId,
                                              widget.chain.firmId,
                                            ),
                                    child: isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        : const Text(
                                            'Générer code de parrainage'),
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

  Future<void> _generatePairingCodeForBoutique(
      String boutiqueId, String chainId) async {
    setState(() {
      _loadingStatus[boutiqueId] = true;
    });

    try {
      final codeForPairing = await _deviceService.generateCodeForPairingDevice(
        boutiqueId: boutiqueId,
        chainId: chainId,
      );

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title:
            "Code de parrainage pour la boutique ${codeForPairing.boutiqueId} généré: ${codeForPairing.code}",
        width: kDialogWidth,
        btnOkText: 'OK',
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      // Log en cas d'erreur
      print("Erreur: $e");

      // Notification d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Erreur lors de la génération du code pour la boutique $boutiqueId')),
      );
    } finally {
      setState(() {
        _loadingStatus[boutiqueId] = false;
      });
    }
  }
}
