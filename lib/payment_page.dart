import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/database/order.dart';
import 'package:tourly/database/payment.dart';
import 'package:tourly/database/payment_method.dart';
import 'package:tourly/database/room_type.dart';
import 'package:tourly/database/user.dart';
import 'package:tourly/history_page.dart';
import 'package:tourly/hotel_detail_page.dart';
import 'package:tourly/payment_method.dart';
import 'package:tourly/transaction_succes.dart';
import 'package:tourly/widgets/main_btn.dart';
import 'package:tourly/widgets/shadowed_container.dart';
import 'package:intl/date_symbol_data_local.dart';

class PaymentPage extends StatefulWidget {
  final Order order;
  PaymentPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final DateTime endTime = DateTime.now().add(Duration(hours: 3));
  final DateFormat dateFormat = DateFormat.yMMMMEEEEd('id');
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);
  PaymentMethodData? method;

  createOrder(CreateUser? user) async {
    if (method != null) {
      widget.order.orderDate = DateTime.now();
      CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance.collection("pesanan");
      String orederReference =
          (await collectionReference.add(widget.order.toMap())).id;

      collectionReference = FirebaseFirestore.instance.collection("pembayaran");
      await collectionReference.add(Payment(
              paymentMethodData: method!,
              orderId: orederReference,
              user: user!,
              dateLimit: endTime)
          .toMap());
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (method == null) {
      SnackBar snackBar = SnackBar(content: Text("Pilih metode pembayaran!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CreateUser? user = Provider.of<CreateUser?>(context);
    print(user);
    if (user == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          children: [
            topSection(),
            SizedBox(
              height: 30,
            ),
            WhiteLongButton(
              displayText: "Pilih metode pembayaran" +
                  (method != null ? " (${method!.nama})" : ""),
              onPressed: () async {
                method = await Navigator.push<PaymentMethodData>(context,
                    MaterialPageRoute(builder: ((context) => PaymentMethod())));
                setState(() {});
              },
            ),
            SizedBox(
              height: 30,
            ),
            invoiceSection(),
            SizedBox(
              height: 30,
            ),
            MainBtn(
                btnText: "Bayar sekarang", onPressed: () => createOrder(user)),
          ],
        ),
      ),
    );
  }

  Widget topSection() {
    return ShadowedContainer(
      usePadding: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              children: [
                Text(
                  widget.order.hotel.nama,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text("Check-in"),
                Text(
                  DateFormat.yMMMMEEEEd('id').format(
                    widget.order.checkIn,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.orange.shade100),
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  "Selesaikan pembayaran sebelum",
                  style: TextStyle(color: Colors.orange.shade900),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  DateFormat('EEEE, d MMMM yyyy - HH:mm', 'id').format(endTime),
                  style: TextStyle(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 12,
                ),
                countdown(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget countdown() {
    return SlideCountdownSeparated(
      showZeroValue: true,
      textStyle: TextStyle(
          color: Colors.orange.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      duration: Duration(hours: 3),
    );
  }

  Widget invoiceSection() {
    int harga = (widget.order.hotel.harga + widget.order.hotel.harga) *
        widget.order.jumlah;
    int diskon =
        ((widget.order.hotel.diskon * widget.order.hotel.harga) / 100).toInt();
    int total = harga - diskon;
    return ShadowedContainer(
      usePadding: false,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Harga Total",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  currencyFormat.format(total),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(color: Colors.grey.shade300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.order.roomType.nama +
                      (widget.order.roomType.smoking ? " - smoking" : "") +
                      " (x${widget.order.jumlah})",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  currencyFormat.format(harga),
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Diskon",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  currencyFormat.format(diskon),
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
