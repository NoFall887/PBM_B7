import 'package:geolocator/geolocator.dart';
import "package:http/http.dart" as http;
import 'dart:convert' as convert;

class MapsServices {
  final String _key = 'AIzaSyBUEbgGwWauGnqURRpVMkHGq_WQpR8PH80';

  List<Map<String, dynamic>> getClosest(
      List<Map<String, dynamic>> hotelList, double lat, double lng) {
    List<Map<String, dynamic>> temp = [];
    for (var hotel in hotelList) {
      double distance = Geolocator.distanceBetween(
        lat,
        lng,
        hotel["latlng"][0],
        hotel["latlng"][1],
      );
      hotel["distance"] = distance;
      temp.add(hotel);
    }
    temp.sort(((a, b) => a["distance"].compareTo(b["distance"])));

    return temp;
  }

  // Future<String> getId(String nama) async {
  //   final urlString =
  //       "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$nama&inputtype=textquery&key=$_key";

  //   var response = await http.get(Uri.parse(urlString));
  //   var jsonResponse = convert.jsonDecode(response.body);
  //   print(jsonResponse);
  //   var placeId = jsonResponse['candidates'][0]['place_id'];
  //   return placeId;
  // }

  // Future<Map<String, dynamic>> getDetails(String id) async {
  //   final urlString =
  //       "https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=$_key";

  //   var response = await http.get(Uri.parse(urlString));
  //   var jsonResponse = convert.jsonDecode(response.body);
  //   print(jsonResponse);
  //   return jsonResponse;
  // }
}
