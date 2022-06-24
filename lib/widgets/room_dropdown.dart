import 'package:flutter/material.dart';
import 'package:tourly/database/room_type.dart';
import 'package:collection/collection.dart';

class RoomDropdown extends StatelessWidget {
  final RoomType selected;
  final Function setSelected;
  final List<RoomType> roomList;
  RoomDropdown(
      {Key? key,
      required this.selected,
      required this.setSelected,
      required this.roomList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            decoration: InputDecoration(enabledBorder: UnderlineInputBorder()),
            items: roomList
                .mapIndexed((index, e) => DropdownMenuItem<RoomType>(
                      enabled: (index != 0),
                      child: e.smoking
                          ? Text(e.nama + " - smoking")
                          : Text(e.nama),
                      value: e,
                    ))
                .toList(),
            onChanged: (RoomType? value) => setSelected(value),
            validator: (RoomType? value) {
              if (value == null) {
                return "Silahkan pilih tipe kamar";
              }
              if (value.id.isEmpty) {
                return "Silahkan pilih tipe kamar";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
