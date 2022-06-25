import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tourly/database/order.dart';
import 'package:tourly/widgets/hotel_checkin_checkout.dart';
import 'package:tourly/widgets/shadowed_container.dart';

class CancelledOrderDetail extends StatelessWidget {
  final Order order;
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);

  CancelledOrderDetail({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaksi dibatalkan"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HotelCheckinCheckout(
                hotelName: order.hotel.nama,
                dateCheckin: order.checkIn,
                dateCheckout: order.checkOut,
              ),
              SizedBox(
                height: 30,
              ),
              invoiceSection(),
            ],
          ),
        ),
      ),
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
