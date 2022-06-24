import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/database/order.dart';
import 'package:tourly/database/room_type.dart';
import 'package:tourly/order_review.dart';
import 'package:tourly/widgets/main_btn.dart';
import 'package:collection/collection.dart';
import 'package:tourly/widgets/room_dropdown.dart';

class Reservasi extends StatefulWidget {
  final Hotel hotelData;
  Reservasi({Key? key, required this.hotelData}) : super(key: key);

  @override
  State<Reservasi> createState() => _ReservasiState();
}

class _ReservasiState extends State<Reservasi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaPenghuniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  List<RoomType> _roomList = [
    RoomType(
        jumlahKasur: 0, nama: "Pilih kamar", id: "", smoking: false, harga: 0)
  ];
  late RoomType _selectedItem;

  void getData() async {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('tipe kamar');
    try {
      List<RoomType> fetched = await collectionReference
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> value) {
        List<RoomType> temp = value.docs.map((e) {
          Map<String, dynamic> data = e.data();
          String id = e.id;
          return RoomType(
              jumlahKasur: data["jumlah kasur"],
              nama: data["nama"],
              id: id,
              smoking: data["smoking"],
              harga: data["harga"]);
        }).toList();
        temp.sort(((a, b) {
          if (b.smoking) {
            return 1;
          }
          return -1;
        }));

        return temp;
      });
      setState(() {
        _roomList = [..._roomList, ...fetched];
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  DateTime date = DateTime.now();
  @override
  void initState() {
    super.initState();
    _selectedItem = _roomList[0];
    getData();
  }

  proccessOrder() {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      Navigator.push(context, MaterialPageRoute(builder: ((context) {
        DateTime checkIn = new DateTime(date.year, date.month, date.day, 14);
        DateTime checkOut =
            checkIn.add(Duration(days: int.parse(_dayController.text)));
        checkOut = DateTime(checkOut.year, checkOut.month, checkOut.day, 12);

        return OrderReview(
          hotelData: widget.hotelData,
          roomType: _selectedItem,
          checkIn: checkIn,
          checkOut: checkOut,
          namaPenghuni: _namaPenghuniController.text,
          durasi: int.parse(_dayController.text),
          order: Order(
              checkIn: checkIn,
              checkOut: checkOut,
              email: _emailController.text,
              hotel: widget.hotelData,
              jumlah: int.parse(_dayController.text),
              namaPenghuni: _namaPenghuniController.text,
              orderDate: DateTime.now(),
              roomType: _selectedItem),
        );
      })));
    }
  }

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

  setSelected(RoomType value) {
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
            key: _formKey,
            child: Column(
              children: [
                namaPenghuni(),
                const SizedBox(height: 4),
                tanggal(context),
                const SizedBox(height: 4),
                RoomDropdown(
                  selected: _selectedItem,
                  setSelected: setSelected,
                  roomList: _roomList,
                ),
                const SizedBox(height: 20),
                email(),
                const SizedBox(height: 50),
                MainBtn(
                  btnText: "Lanjutkan pesanan",
                  onPressed: proccessOrder,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Field wajib diisi";
              }
              return null;
            },
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
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Durasi",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Field wajib diisi";
              }
              return null;
            },
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
            // autovalidateMode: AutovalidateMode.onUserInteraction,
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
