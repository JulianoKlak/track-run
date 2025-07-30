import 'package:h3_flutter/h3_flutter.dart';

final h3 = H3();

String getH3IndexFromLocation(double lat, double lon, {int resolution = 10}) {
  return h3.geoToH3(lat, lon, resolution);
}
