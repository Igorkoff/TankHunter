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
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  children: [
                    Text('Russian Losses', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8.0),
                    Text('$currentDate, Day $currentDay', style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  children: [
                    _buildListTile(
                      title: snapshot.data!.data.stats.personnel_units.toString(),
                      increase: snapshot.data!.data.increase.personnel_units,
                      subtitle: 'Personnel',
                      imagePath: 'assets/icons/icon-people.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.tanks.toString(),
                      increase: snapshot.data!.data.increase.tanks,
                      subtitle: 'Main Battle Tanks',
                      imagePath: 'assets/icons/icon-tank.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.armoured_fighting_vehicles.toString(),
                      increase: snapshot.data!.data.increase.armoured_fighting_vehicles,
                      subtitle: 'Armoured Vehicles',
                      imagePath: 'assets/icons/icon-bbm.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.artillery_systems.toString(),
                      increase: snapshot.data!.data.increase.artillery_systems,
                      subtitle: 'Artillery',
                      imagePath: 'assets/icons/icon-art.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.mlrs.toString(),
                      increase: snapshot.data!.data.increase.mlrs,
                      subtitle: 'Rocket Launchers',
                      imagePath: 'assets/icons/icon-rszv.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.aa_warfare_systems.toString(),
                      increase: snapshot.data!.data.increase.aa_warfare_systems,
                      subtitle: 'Anti-Aircraft',
                      imagePath: 'assets/icons/icon-ppo.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.planes.toString(),
                      increase: snapshot.data!.data.increase.planes,
                      subtitle: 'Planes',
                      imagePath: 'assets/icons/icon-plane.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.helicopters.toString(),
                      increase: snapshot.data!.data.increase.helicopters,
                      subtitle: 'Helicopters',
                      imagePath: 'assets/icons/icon-helicopter.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.vehicles_fuel_tanks.toString(),
                      increase: snapshot.data!.data.increase.vehicles_fuel_tanks,
                      subtitle: 'Vehicles',
                      imagePath: 'assets/icons/icon-auto.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.warships_cutters.toString(),
                      increase: snapshot.data!.data.increase.warships_cutters,
                      subtitle: 'Warships and Cutters',
                      imagePath: 'assets/icons/icon-ship.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.cruise_missiles.toString(),
                      increase: snapshot.data!.data.increase.cruise_missiles,
                      subtitle: 'Cruise Missiles',
                      imagePath: 'assets/icons/icon-rocket.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.uav_systems.toString(),
                      increase: snapshot.data!.data.increase.uav_systems,
                      subtitle: 'UAV Systems',
                      imagePath: 'assets/icons/icon-bpla.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.special_military_equip.toString(),
                      increase: snapshot.data!.data.increase.special_military_equip,
                      subtitle: 'Special Equipment',
                      imagePath: 'assets/icons/icon-special.svg',
                    ),
                    _buildListTile(
                      title: snapshot.data!.data.stats.atgm_srbm_systems.toString(),
                      increase: snapshot.data!.data.increase.atgm_srbm_systems,
                      subtitle: 'ATGM and SRBM',
                      imagePath: 'assets/icons/icon-trk.svg',
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Text('Glory To Ukraine!  🇺🇦', style: Theme.of(context).textTheme.titleLarge)
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Center(child: Text('Failed to Load Data'));
        }
        return const Center(
          child: CircularProgressIndicator(color: Color(0xff0037C3)),
        );
      },
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required String imagePath,
    required int increase,
  }) =>
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 14.0),
        color: const Color(0xffE5EBFA),
        elevation: 0.15,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 19),
          title: Text(title),
          subtitle: Text(subtitle),
          leading: SvgPicture.asset(imagePath, width: 55.0),
          trailing: increase != 0 ? Text('+ $increase') : null,
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          subtitleTextStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      );
}
