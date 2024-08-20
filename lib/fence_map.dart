import 'package:flutter/material.dart';
import 'package:web_admin/constants/dimens.dart';

const List<MaterialColor> filtered = <MaterialColor>[
  Colors.indigo,
  Colors.blue,
//  Colors.lightBlue,
  // Colors.cyan,
  Colors.teal,
//  Colors.green,
  Colors.lightGreen,
  Colors.lime,
//  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.blueGrey,
];

class UserWidget extends StatelessWidget {
  final String userId;
  final String name;
  static const color = Colors.orange;
  const UserWidget(this.userId, this.name, {Key? key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all((12)),
        color: color,
        child: Text(name),
      ),
    );
  }
}

class FirmWidget extends StatelessWidget {
  static const color = Colors.indigo;
  final Iterable<ChainWidget> chains;
  final Iterable<UserWidget> bosses;
  final String firmId;
  final String name;
  const FirmWidget(this.firmId, this.name, this.chains, this.bosses,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 3,
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: kDefaultPadding,
          spacing: kDefaultPadding,
          direction: Axis.horizontal,
          children: [
            Text(name),
            for (final boss in bosses) boss,
            for (final chain in chains) chain
          ],
        ),
      ),
    );
  }
}

class ChainWidget extends StatelessWidget {
  static const color = Colors.blue;
  final String chainId;
  final String name;
  final Iterable<BoutiqueWidget> boutiques;
  final Iterable<DeviceWidget> devices;
  final Iterable<UserWidget> managers;
  const ChainWidget(
      this.chainId, this.name, this.boutiques, this.managers, this.devices,
      {Key? key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 3,
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: kDefaultPadding,
          spacing: kDefaultPadding,
          direction: Axis.horizontal,
          children: [
            Text(name),
            for (final manager in managers) manager,
            for (final boutique in boutiques) boutique,
            for (final device in devices) device
          ],
        ),
      ),
    );
  }
}

class DeviceWidget extends StatelessWidget {
  final String name;
  const DeviceWidget(this.name, {Key? key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Icon(Icons.point_of_sale),
    );
  }
}

class BoutiqueWidget extends StatelessWidget {
  static const color = Colors.teal;
  final String chainId;
  final String boutiqueId;
  final String name;
  final Iterable<UserWidget> sellers;
  const BoutiqueWidget(this.chainId, this.boutiqueId, this.name, this.sellers,
      {Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: color,
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: kDefaultPadding,
            spacing: kDefaultPadding,
            direction: Axis.horizontal,
            children: [
              Text(name),
              for (final seller in sellers) seller,
            ],
          ),
        ),
        elevation: 3,
      ),
    );
  }
}

class NestedWrapExample extends StatelessWidget {
  NestedWrapExample({
    Key? key,
    this.depth = 0,
    this.valuePrefix = '',
    this.color,
    this.onTap,
  }) : super(key: key);
  final void Function()? onTap;
  final int depth;
  final String valuePrefix;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FirmWidget(
      '1',
      'Firme chez lili',
      [
        ChainWidget(
          '11',
          'Chain chez lili',
          [
            BoutiqueWidget(
              '11',
              '111',
              'Boutique chez lili',
              [
                UserWidget('99', 'Seller'),
              ],
            )
          ],
          [UserWidget('98', 'Manager')],
          [DeviceWidget('caisse par défaut')],
        ),
        ChainWidget(
          '12',
          'Chain ice cream',
          [
            BoutiqueWidget(
              '12',
              '121',
              'Boutique ice cream',
              [
                UserWidget('92', 'Seller'),
              ],
            ),
            BoutiqueWidget(
              '12',
              '122',
              'Boutique chocolat vanilla',
              [
                UserWidget('91', 'Seller'),
              ],
            )
          ],
          [],
          [DeviceWidget('caisse par défaut')],
        )
      ],
      [
        UserWidget('95', 'Boss'),
      ],
    );
  }
}
