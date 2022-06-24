import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:tourly/hotel_nearby.dart';
import 'package:tourly/search_result_page.dart';
import 'package:tourly/widgets/main_btn.dart';
import 'package:collection/collection.dart';
import 'package:tourly/widgets/room_dropdown.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var date = DateTime.now();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  final TextEditingController _penginapanController = TextEditingController();
  final TextEditingController _malamController = TextEditingController();

  String _selectedItem = "";

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date,
        lastDate: DateTime(date.year + 1));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  setSelected(String value) {
    setState(() {
      _selectedItem = value;
    });
  }

  _filter(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _minController,
                        decoration: const InputDecoration(labelText: "Min"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        " - ",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _maxController,
                        decoration: const InputDecoration(labelText: "Max"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cari hotel"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              )
            ],
          ),
          child: Form(
            child: Column(
              children: [
                penginapanTerdekat(),
                const SizedBox(height: 4),
                // tanggal(context),
                const SizedBox(height: 4),
                // RoomDropdown(selected: _selectedItem, setSelected: setSelected),
                const SizedBox(height: 20),
                filterBtn(context),
                const SizedBox(height: 50),
                MainBtn(
                  btnText: "Cari",
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      String name = _penginapanController.text;
                      int? max;
                      int? min;

                      if (_maxController.text.isNotEmpty) {
                        max = int.parse(_maxController.text);
                      }
                      if (_minController.text.isNotEmpty) {
                        min = int.parse(_minController.text);
                      }
                      return SearchResultPage(
                        name: _penginapanController.text,
                        priceMax: max,
                        priceMin: min,
                      );
                    })));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget penginapanTerdekat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 25,
          color: Colors.blue.shade400,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _penginapanController,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: "Penginapan"),
          ),
        ),
        const SizedBox(width: 4),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(), padding: const EdgeInsets.all(10)),
          child: const Icon(Icons.gps_fixed_rounded),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HotelNearby()));
          },
        ),
      ],
    );
  }

  // Widget tanggal(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Icon(
  //         Icons.date_range_rounded,
  //         size: 25,
  //         color: Colors.blue.shade400,
  //       ),
  //       Expanded(
  //         flex: 7,
  //         child: TextButton(
  //           onPressed: () {
  //             _selectedDate(context);
  //           },
  //           style: TextButton.styleFrom(alignment: Alignment.bottomLeft),
  //           child: Text(
  //             date.toLocal().toString().split(' ')[0],
  //             style: const TextStyle(
  //               color: Colors.black54,
  //               fontSize: 18,
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         flex: 3,
  //         child: TextFormField(
  //           controller: _malamController,
  //           decoration: const InputDecoration(
  //               border: const UnderlineInputBorder(), labelText: "1 Malam"),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget filterBtn(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.filter_alt_rounded,
          size: 25,
          color: Colors.blue.shade400,
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              _filter(context);
            },
            style: TextButton.styleFrom(alignment: Alignment.bottomLeft),
            child: const Text(
              "Filter",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
