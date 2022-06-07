import 'package:flutter/material.dart';

class hotelFacilityItem extends StatelessWidget {
  final String facilityName;
  hotelFacilityItem({Key? key, required this.facilityName}) : super(key: key);

  Map _facilityIcon = {
    "restoran": IconTemplate(icon: Icons.restaurant),
    "gym": IconTemplate(icon: Icons.fitness_center_rounded),
    "wifi": IconTemplate(icon: Icons.wifi),
    "kolam": IconTemplate(icon: Icons.pool_rounded),
    "laundry": IconTemplate(icon: Icons.local_laundry_service_rounded),
    "parkir": IconTemplate(icon: Icons.local_parking_rounded)
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade300,
            child: _facilityIcon[facilityName],
            radius: 30,
          ),
          SizedBox(height: 10),
          Text(facilityName)
        ],
      ),
    );
  }
}

class IconTemplate extends StatelessWidget {
  final IconData icon;
  const IconTemplate({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 40);
  }
}
