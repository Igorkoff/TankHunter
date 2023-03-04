import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

Future<Details> fetchDetails(Dio dio) async {
  dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: 'https://russianwarship.rip')).interceptor);
  String url = 'https://russianwarship.rip/api/v1/statistics/latest';

  Response response =
      await dio.get(url, options: buildCacheOptions(const Duration(hours: 24), maxStale: const Duration(hours: 48)));

  if (response.statusCode == 200) {
    return Details.fromJson(response.data);
  } else {
    throw Exception('Failed to Load Details');
  }
}

class Details {
  final Data data;

  const Details({required this.data});

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(data: Data.fromJson(json['data']));
  }
}

class Data {
  final String date;
  final int day;
  final Stats stats;
  final Increase increase;

  const Data({
    required this.date,
    required this.day,
    required this.stats,
    required this.increase,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      date: json['date'],
      day: json['day'],
      stats: Stats.fromJson(json['stats']),
      increase: Increase.fromJson(json['increase']),
    );
  }
}

class Stats {
  final int personnel_units;
  final int tanks;
  final int armoured_fighting_vehicles;
  final int artillery_systems;
  final int mlrs;
  final int aa_warfare_systems;
  final int planes;
  final int helicopters;
  final int vehicles_fuel_tanks;
  final int warships_cutters;
  final int cruise_missiles;
  final int uav_systems;
  final int special_military_equip;
  final int atgm_srbm_systems;

  const Stats({
    required this.personnel_units,
    required this.tanks,
    required this.armoured_fighting_vehicles,
    required this.artillery_systems,
    required this.mlrs,
    required this.aa_warfare_systems,
    required this.planes,
    required this.helicopters,
    required this.vehicles_fuel_tanks,
    required this.warships_cutters,
    required this.cruise_missiles,
    required this.uav_systems,
    required this.special_military_equip,
    required this.atgm_srbm_systems,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      personnel_units: json['personnel_units'],
      tanks: json['tanks'],
      armoured_fighting_vehicles: json['armoured_fighting_vehicles'],
      artillery_systems: json['artillery_systems'],
      mlrs: json['mlrs'],
      aa_warfare_systems: json['aa_warfare_systems'],
      planes: json['planes'],
      helicopters: json['helicopters'],
      vehicles_fuel_tanks: json['vehicles_fuel_tanks'],
      warships_cutters: json['warships_cutters'],
      cruise_missiles: json['cruise_missiles'],
      uav_systems: json['uav_systems'],
      special_military_equip: json['special_military_equip'],
      atgm_srbm_systems: json['atgm_srbm_systems'],
    );
  }
}

class Increase {
  final int personnel_units;
  final int tanks;
  final int armoured_fighting_vehicles;
  final int artillery_systems;
  final int mlrs;
  final int aa_warfare_systems;
  final int planes;
  final int helicopters;
  final int vehicles_fuel_tanks;
  final int warships_cutters;
  final int cruise_missiles;
  final int uav_systems;
  final int special_military_equip;
  final int atgm_srbm_systems;

  const Increase({
    required this.personnel_units,
    required this.tanks,
    required this.armoured_fighting_vehicles,
    required this.artillery_systems,
    required this.mlrs,
    required this.aa_warfare_systems,
    required this.planes,
    required this.helicopters,
    required this.vehicles_fuel_tanks,
    required this.warships_cutters,
    required this.cruise_missiles,
    required this.uav_systems,
    required this.special_military_equip,
    required this.atgm_srbm_systems,
  });

  factory Increase.fromJson(Map<String, dynamic> json) {
    return Increase(
      personnel_units: json['personnel_units'],
      tanks: json['tanks'],
      armoured_fighting_vehicles: json['armoured_fighting_vehicles'],
      artillery_systems: json['artillery_systems'],
      mlrs: json['mlrs'],
      aa_warfare_systems: json['aa_warfare_systems'],
      planes: json['planes'],
      helicopters: json['helicopters'],
      vehicles_fuel_tanks: json['vehicles_fuel_tanks'],
      warships_cutters: json['warships_cutters'],
      cruise_missiles: json['cruise_missiles'],
      uav_systems: json['uav_systems'],
      special_military_equip: json['special_military_equip'],
      atgm_srbm_systems: json['atgm_srbm_systems'],
    );
  }
}
