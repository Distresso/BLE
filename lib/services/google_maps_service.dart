import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const String APIKEY = '';

class GoogleMapsServices {
  static GoogleMapsServices _instance;

  factory GoogleMapsServices() => _instance ??= new GoogleMapsServices._();

  GoogleMapsServices._();

  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    if (l1 == null || l2 == null) return null;
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$APIKEY";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);

    List routes = values["routes"];
    return routes.length > 0 ? routes[0]["overview_polyline"]["points"] : '';
  }

  // Future<List<PoiResult>> getPOIResults(String placeType, Position position) async {
  //   var url = "https://us-central1-response24-sa-prod.cloudfunctions.net/location/places-near-lat-long/v1";
  //   var response = await http.post(
  //     url,
  //     body: {
  //       'placeType': placeType,
  //       'lat': "${position.latitude}",
  //       'long': "${position.longitude}",
  //     },
  //   );
  //   var saps = SapsResults.fromJson(json.decode(response.body));
  //   return saps.poiResults;
  // }

  // Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(BuildContext context, String assetName) async {
  //   String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  //   DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);
  //   MediaQueryData queryData = MediaQuery.of(context);
  //   double devicePixelRatio = queryData.devicePixelRatio;
  //   double width = 32 * devicePixelRatio; // where 32 is your SVG's original width
  //   double height = 32 * devicePixelRatio; // same thing
  //   ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
  //   ui.Image image = await picture.toImage(width.toInt(), height.toInt());
  //   ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  //   return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  // }
}
