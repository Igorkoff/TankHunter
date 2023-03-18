import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/losses.dart';

class EnemyLossesPage extends StatefulWidget {
  const EnemyLossesPage({Key? key}) : super(key: key);

  @override
  State<EnemyLossesPage> createState() => _EnemyLossesPageState();
}

class _EnemyLossesPageState extends State<EnemyLossesPage> {
  Future<Details>? futureDetails;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    futureDetails = fetchDetails(dio);
  }

  @override
  void dispose() {
    super.dispose();
    dio.close();
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
                imagePath: 'assets/icons/icon-people.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.tanks.toString(),
                increase: snapshot.data!.data.increase.tanks,
                subtitle: 'Main Battle Tanks',
                imagePath: 'assets/icons/icon-tank.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.armoured_fighting_vehicles.toString(),
                increase: snapshot.data!.data.increase.armoured_fighting_vehicles,
                subtitle: 'Armoured Vehicles',
                imagePath: 'assets/icons/icon-bbm.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.artillery_systems.toString(),
                increase: snapshot.data!.data.increase.artillery_systems,
                subtitle: 'Artillery',
                imagePath: 'assets/icons/icon-art.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.mlrs.toString(),
                increase: snapshot.data!.data.increase.mlrs,
                subtitle: 'Rocket Launchers',
                imagePath: 'assets/icons/icon-rszv.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.aa_warfare_systems.toString(),
                increase: snapshot.data!.data.increase.aa_warfare_systems,
                subtitle: 'Anti-Aircraft',
                imagePath: 'assets/icons/icon-ppo.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.planes.toString(),
                increase: snapshot.data!.data.increase.planes,
                subtitle: 'Planes',
                imagePath: 'assets/icons/icon-plane.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.helicopters.toString(),
                increase: snapshot.data!.data.increase.helicopters,
                subtitle: 'Helicopters',
                imagePath: 'assets/icons/icon-helicopter.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.vehicles_fuel_tanks.toString(),
                increase: snapshot.data!.data.increase.vehicles_fuel_tanks,
                subtitle: 'Vehicles',
                imagePath: 'assets/icons/icon-auto.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.warships_cutters.toString(),
                increase: snapshot.data!.data.increase.warships_cutters,
                subtitle: 'Warships and Cutters',
                imagePath: 'assets/icons/icon-ship.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.cruise_missiles.toString(),
                increase: snapshot.data!.data.increase.cruise_missiles,
                subtitle: 'Cruise Missiles',
                imagePath: 'assets/icons/icon-rocket.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.uav_systems.toString(),
                increase: snapshot.data!.data.increase.uav_systems,
                subtitle: 'UAV Systems',
                imagePath: 'assets/icons/icon-bpla.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.special_military_equip.toString(),
                increase: snapshot.data!.data.increase.special_military_equip,
                subtitle: 'Special Equipment',
                imagePath: 'assets/icons/icon-special.svg',
              ),
              buildListTile(
                title: snapshot.data!.data.stats.atgm_srbm_systems.toString(),
                increase: snapshot.data!.data.increase.atgm_srbm_systems,
                subtitle: 'ATGM and SRBM',
                imagePath: 'assets/icons/icon-trk.svg',
              ),
              const Center(
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    Text('Glory To Ukraine!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                  ],
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Center(child: Text('Failed to Load Data'));
        }
        return const Center(
          child: CircularProgressIndicator(color: Color.fromRGBO(32, 42, 68, 1)),
        );
      },
    );
  }

  Widget buildListTile({
    required String title,
    required String subtitle,
    required String imagePath,
    required int increase,
  }) =>
      ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: SvgPicture.asset(imagePath, width: 50),
        trailing: increase != 0 ? Text('+ $increase', style: const TextStyle(fontWeight: FontWeight.bold)) : null,
      );
}
