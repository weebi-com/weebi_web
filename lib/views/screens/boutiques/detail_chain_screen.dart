import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:protos_weebi/protos_weebi_io.dart';
import '../../../app_router.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/services/device_service.dart';
//import '../../../generated/l10n.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';


// dirty widget to hack generating the pairing code
class BoutiqueDetail extends StatefulWidget {
  final Chain chain;
  final BoutiquePb boutique;
  const BoutiqueDetail(this.chain, this.boutique, {super.key});

  @override
  State<BoutiqueDetail> createState() => _BoutiqueDetailState();
}

class _BoutiqueDetailState extends State<BoutiqueDetail> {
  final DeviceService _deviceService = DeviceService();
  bool isLoading = false;
  final Map<String, bool> _loadingStatus = {};

  Future<void> _generatePairingCodeForBoutique(
      String boutiqueName, String boutiqueId, String chainId) async {
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
            "Code pour relier un nouvel appareil à la boutique $boutiqueName :\n\n${codeForPairing.code}",
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

  @override
  Widget build(BuildContext context) {
    final name = widget.boutique.name.isEmpty ? widget.chain.name : widget.boutique.name; 
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child:
          // TODO: here we want to be able to : display boutique full detail
          // * - to enter edit boutique view
          // * to delete boutique
          // to see all devices linked
          ListTile(
        leading: const Icon(Icons.store),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold),),
        subtitle: widget.boutique.addressFull.city.isEmpty &&
                widget.boutique.addressFull.street.isEmpty
            ? null
            : Text('Adresse : ${widget.boutique.addressFull.toString()}'),
        trailing: ElevatedButton(
          onPressed: isLoading
              ? null
              : () => _generatePairingCodeForBoutique(
                    name,
                    widget.boutique.boutiqueId,
                    widget.chain.chainId,
                  ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Relier un nouvel appareil à cette boutique'),
        ),
      ),
    );
    ;
  }
}

class DetailChainScreen extends StatefulWidget {
  final Chain chain;

  const DetailChainScreen({super.key, required this.chain});

  @override
  _DetailChainScreenState createState() => _DetailChainScreenState();
}

class _DetailChainScreenState extends State<DetailChainScreen> {
  final DeviceService _deviceService = DeviceService();
  final Map<String, bool> _loadingStatus = {};

  @override
  Widget build(BuildContext context) {
    final boutiques = widget.chain.boutiques;
    final themeData = Theme.of(context);
    final String pageTitle = widget.chain.name;

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
                  CardHeader(title: pageTitle),
                  CardBody(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Boutiques de la chaîne: '),
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
                                child:
                                    // TODO: here we want to be able to : display boutique full detail
                                    // * - to enter edit boutique view
                                    // * to delete boutique
                                    // to see all devices linked
                                    ListTile(
                                  title: Text('Boutique : ${boutique.name}'),
                                  subtitle: boutique.boutique.addressFull.city
                                              .isEmpty &&
                                          boutique.boutique.addressFull.street
                                              .isEmpty
                                      ? null
                                      : Text(
                                          'Adresse : ${boutique.boutique.addressFull.toString()}'),
                                  trailing: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => _generatePairingCodeForBoutique(
                                              boutique.name,
                                              boutique.boutiqueId,
                                              widget.chain.chainId,
                                            ),
                                    child: isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        : const Text(
                                            'Relier un nouvel appareil à cette boutique'),
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
      String boutiqueName, String boutiqueId, String chainId) async {
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
            "Code pour relier un nouvel appareil à la boutique $boutiqueName :\n\n${codeForPairing.code}",
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
