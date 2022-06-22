import 'package:flutter/material.dart';

class hotelFacilityItem extends StatelessWidget {
  final String facilityName;
  hotelFacilityItem({Key? key, required this.facilityName}) : super(key: key);

  final Map _facilityIcon = {
    "restoran": const IconTemplate(icon: Icons.restaurant),
    "gym": const IconTemplate(icon: Icons.fitness_center_rounded),
    "wifi": const IconTemplate(icon: Icons.wifi),
    "kolam": const IconTemplate(icon: Icons.pool_rounded),
    "laundry": const IconTemplate(icon: Icons.local_laundry_service_rounded),
    "parkir": const IconTemplate(icon: Icons.local_parking_rounded),
    "bar": const IconTemplate(icon: Icons.local_bar_rounded),
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
          const SizedBox(height: 10),
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
