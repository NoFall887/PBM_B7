import 'package:cloud_firestore/cloud_firestore.dart';

class Facility {
  static Map<String, dynamic> castFacilities(data) {
    Map<String, dynamic> tempData = Map<String, dynamic>.from(data as Map);

    List<DocumentReference<Map<String, dynamic>>> facilities =
        List<DocumentReference<Map<String, dynamic>>>.from(
            tempData["fasilitas"]);
    tempData["fasilitas"] = facilities;
    return tempData;
  }
}
