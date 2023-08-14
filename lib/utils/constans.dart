import 'package:google_maps_flutter/google_maps_flutter.dart';

const baseUrl = "https://geocode-maps.yandex.ru";
const String apiKey = "98766a71-a866-47bf-8184-2f9cb48187d2";

class TimeOutConstants {
  static int connectTimeout = 30;
  static int receiveTimeout = 25;
  static int sendTimeout = 60;
}

const List<String> kindList = [
  "house",
  "metro",
  "district",
  "street",
];

const List<String> langList = [
  "uz_UZ",
  "ru_RU",
  "en_GB",
  "tr_TR",
];

const List<MapType> maps = [
  MapType.terrain,
  MapType.normal,
  MapType.hybrid,
  MapType.satellite,
];

Map<dynamic,dynamic> mapsTypeName = {
  MapType.terrain.name: "terrain",
  MapType.normal.name: "normal",
  MapType.hybrid.name: "hybrid",
  MapType.satellite.name: "satellite",
};