import 'package:flutter/material.dart';
import 'package:tourly/database/room_type.dart';
import 'package:collection/collection.dart';

class RoomDropdown extends StatelessWidget {
  final String selected;
  final Function setSelected;
  const RoomDropdown(
      {Key? key, required this.selected, required this.setSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RoomType>>(
      future: RoomType.getData(),
      initialData: [
        RoomType(jumlahKasur: 0, nama: "Pilih kamar", id: "", smoking: false)
      ],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        List<RoomType> rooms = snapshot.data;
        return Row(
          children: [
            Icon(
              Icons.meeting_room_rounded,
              size: 25,
              color: Colors.blue.shade400,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField(
                value: selected,
                decoration:
                    InputDecoration(enabledBorder: UnderlineInputBorder()),
                items: rooms
                    .mapIndexed((index, e) => DropdownMenuItem(
                          enabled: (index != 0),
                          child: e.smoking
                              ? Text(e.nama + " - smoking")
                              : Text(e.nama),
                          value: e.id,
                        ))
                    .toList(),
                onChanged: (dynamic value) => setSelected(value),
              ),
            ),
          ],
        );
      },
    );
  }
}
