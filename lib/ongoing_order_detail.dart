import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:tourly/database/order.dart';
import 'package:tourly/widgets/main_btn.dart';
import 'package:tourly/widgets/shadowed_container.dart';

class OngoingOrderDetail extends StatelessWidget {
  final Order order;
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);
  OngoingOrderDetail({Key? key, required this.order}) : super(key: key);

  checkout(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("pesanan")
        .doc(order.id)
        .update({
      "selesai": true,
    });
    Navigator.pop(context);
  }

  cancelOrder(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("pesanan")
        .doc(order.id)
        .update({"batal": true});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
            Text("Metode pembayaran : ${order.paymentMethodData!.nama}"),
            SizedBox(
              height: 30,
            ),
            invoiceSection(),
            SizedBox(
              height: 30,
            ),
            MainBtn(
                btnText: "Bayar sekarang",
                onPressed: () {
                  checkout(context);
                }),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                cancelOrder(context);
              },
              child: Text("Batalkan"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  minimumSize: Size(MediaQuery.of(context).size.width, 40)),
            )
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
                  order.hotel.nama,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text("Check-in"),
                Text(
                  DateFormat.yMMMMEEEEd('id').format(
                    order.checkIn,
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
                  DateFormat('EEEE, d MMMM yyyy - HH:mm', 'id')
                      .format(order.limit!),
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
      duration:
          DateTimeRange(start: DateTime.now(), end: order.limit!).duration,
    );
  }

  Widget invoiceSection() {
    int harga = (order.hotel.harga + order.roomType.harga) * order.jumlah;
    int diskon = ((order.hotel.diskon * order.hotel.harga) / 100).toInt();
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
                  order.roomType.nama +
                      (order.roomType.smoking ? " - smoking" : "") +
                      " (x${order.jumlah})",
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
