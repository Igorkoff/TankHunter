import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'domain/losses.dart';

// TODO: cache data and query once a day
// TODO: download icons and use them locally

class LossesPage extends StatefulWidget {
  const LossesPage({Key? key}) : super(key: key);

  @override
  State<LossesPage> createState() => _LossesPageState();
}

class _LossesPageState extends State<LossesPage> {
  late Future<Details> futureDetails;

  @override
  void initState() {
    super.initState();
    futureDetails = fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Details>(
      future: futureDetails,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String currentDate = DateFormat("dd.MM.yyyy").format(DateTime.parse(snapshot.data!.data.date));
          String currentDay = snapshot.data!.data.day.toString();
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Column(
                  children: [
                    const Text('Russian Losses', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('$currentDate, Day $currentDay'),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              buildListTile(
                title: snapshot.data!.data.stats.personnel_units.toString(),
                increase: snapshot.data!.data.increase.personnel_units,
                subtitle: 'Personnel',
                imageURL: 'https://russianwarship.rip/images/icons/icon-people.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.tanks.toString(),
                increase: snapshot.data!.data.increase.tanks,
                subtitle: 'Tanks',
                imageURL: 'https://russianwarship.rip/images/icons/icon-tank.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.armoured_fighting_vehicles.toString(),
                increase: snapshot.data!.data.increase.armoured_fighting_vehicles,
                subtitle: 'AFV',
                imageURL: 'https://russianwarship.rip/images/icons/icon-bbm.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.artillery_systems.toString(),
                increase: snapshot.data!.data.increase.artillery_systems,
                subtitle: 'Artillery',
                imageURL: 'https://russianwarship.rip/images/icons/icon-art.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.mlrs.toString(),
                increase: snapshot.data!.data.increase.mlrs,
                subtitle: 'MLRS',
                imageURL: 'https://russianwarship.rip/images/icons/icon-rszv.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.aa_warfare_systems.toString(),
                increase: snapshot.data!.data.increase.aa_warfare_systems,
                subtitle: 'Anti-Aircraft',
                imageURL: 'https://russianwarship.rip/images/icons/icon-ppo.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.planes.toString(),
                increase: snapshot.data!.data.increase.planes,
                subtitle: 'Planes',
                imageURL: 'https://russianwarship.rip/images/icons/icon-plane.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.helicopters.toString(),
                increase: snapshot.data!.data.increase.helicopters,
                subtitle: 'Helicopters',
                imageURL: 'https://russianwarship.rip/images/icons/icon-helicopter.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.vehicles_fuel_tanks.toString(),
                increase: snapshot.data!.data.increase.vehicles_fuel_tanks,
                subtitle: 'Vehicles',
                imageURL: 'https://russianwarship.rip/images/icons/icon-auto.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.warships_cutters.toString(),
                increase: snapshot.data!.data.increase.warships_cutters,
                subtitle: 'Warships and Cutters',
                imageURL: 'https://russianwarship.rip/images/icons/icon-ship.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.cruise_missiles.toString(),
                increase: snapshot.data!.data.increase.cruise_missiles,
                subtitle: 'Cruise Missiles',
                imageURL: 'https://russianwarship.rip/images/icons/icon-rocket.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.uav_systems.toString(),
                increase: snapshot.data!.data.increase.uav_systems,
                subtitle: 'UAV Systems',
                imageURL: 'https://russianwarship.rip/images/icons/icon-bpla.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.special_military_equip.toString(),
                increase: snapshot.data!.data.increase.special_military_equip,
                subtitle: 'Special Equipment',
                imageURL: 'https://russianwarship.rip/images/icons/icon-special.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.atgm_srbm_systems.toString(),
                increase: snapshot.data!.data.increase.atgm_srbm_systems,
                subtitle: 'ATGM and SRBM',
                imageURL: 'https://russianwarship.rip/images/icons/icon-trk.svg',
              ),
              Center(
                child: Column(
                  children: const [
                    SizedBox(height: 8),
                    Text('Glory To Ukraine!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                  ],
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget buildListTile({
    required String title,
    required String subtitle,
    required String imageURL,
    required int increase,
  }) =>
      ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: SvgPicture.network(imageURL, width: 50),
        trailing: Text('+ $increase', style: const TextStyle(fontWeight: FontWeight.bold)),
      );
}
