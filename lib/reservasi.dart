import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/database/room_type.dart';
import 'package:tourly/order_review.dart';
import 'package:tourly/widgets/main_btn.dart';
import 'package:collection/collection.dart';
import 'package:tourly/widgets/room_dropdown.dart';

class Reservasi extends StatefulWidget {
  final String namaHotel;
  Reservasi({Key? key, required this.namaHotel}) : super(key: key);

  @override
  State<Reservasi> createState() => _ReservasiState();
}

class _ReservasiState extends State<Reservasi> {
  final TextEditingController _namaPenghuniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  String _selectedItem = "";
  DateTime date = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Hotel'),
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
                namaPenghuni(),
                const SizedBox(height: 4),
                tanggal(context),
                const SizedBox(height: 4),
                // roomDropDownBuilder(),
                RoomDropdown(selected: _selectedItem, setSelected: setSelected),
                const SizedBox(height: 20),
                email(),
                const SizedBox(height: 50),
                MainBtn(
                  btnText: "Lanjutkan pesanan",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => OrderReview())));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget namaPenghuni() {
    return Row(
      children: [
        Icon(
          Icons.account_box_rounded,
          size: 25,
          color: Colors.blue.shade400,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _namaPenghuniController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Nama penghuni",
            ),
          ),
        )
      ],
    );
  }

  Widget tanggal(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.date_range_rounded,
          size: 25,
          color: Colors.blue.shade400,
        ),
        Expanded(
          flex: 7,
          child: TextButton(
            onPressed: () {
              _selectedDate(context);
            },
            style: TextButton.styleFrom(alignment: Alignment.bottomLeft),
            child: Text(
              date.toLocal().toString().split(' ')[0],
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: _dayController,
            decoration: const InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: "1 Malam",
            ),
          ),
        ),
      ],
    );
  }

  Widget email() {
    return Row(
      children: [
        Icon(
          Icons.email_rounded,
          size: 25,
          color: Colors.blue.shade400,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            // initialValue: (FirebaseAuth.instance.currentUser != null
            //     ? FirebaseAuth.instance.currentUser?.email
            //     : ""),
            decoration: InputDecoration(
              labelText: "Email",
              border: UnderlineInputBorder(),
            ),
            controller: _emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            validator: (input) {
              if (input!.isEmpty) {
                return "Email tidak boleh kosong";
              } else if (!EmailValidator.validate(input)) {
                return "Email tidak valid";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
