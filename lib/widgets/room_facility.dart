import 'package:flutter/material.dart';

class RoomFacility extends StatelessWidget {
  final List<String> facilities;
  RoomFacility({Key? key, required this.facilities}) : super(key: key);

  final Map<String, dynamic> facilityList = {
    "wifi": Icons.wifi_rounded,
  };
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: facilities
          .map(
            (item) => Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      facilityList[item],
                      color: Colors.pink.shade300,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      item,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
