import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static LocationService _instance;

  factory LocationService() => _instance ??= new LocationService._();

  LocationService._();

  Future<List<Placemark>> getAddresses(double latitude, double longitude) async {
    return await placemarkFromCoordinates(latitude, longitude);
  }

  // Future<double> getDistanceBetween(Position start, Position finish) async {
  //   try {
  //     double distance = GeolocatorPlatform.distanceBetween(start.latitude, start.longitude, finish.latitude, finish.longitude);
  //     return distance;
  //   } catch (e) {
  //     return -1;
  //   }
  // }

  // Future<bool> isClose(Position start, Position finish) async {
  //   try {
  //     var distance = await getDistanceBetween(start, finish);
  //     if (distance == -1) return false;
  //     return distance < 10;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Set<Polyline> createRoute(String encodedPoly) {
    Set<Polyline> polyLines = Set<Polyline>();
    polyLines.add(
      Polyline(
        polylineId: PolylineId('route'),
        width: 4,
        points: _decodePoly(encodedPoly),
        color: Colors.red,
      ),
    );

    return polyLines;
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List<LatLng> _decodePoly(String poly) {
    List<int> list = poly.codeUnits;
    List lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (result & 1 == 1) {
        result = ~result;
      }

      double result1 = (result >> 1) * 0.00001;

      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return _convertToLatLng(lList);
  }
}
