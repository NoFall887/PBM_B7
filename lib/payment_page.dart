import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:tourly/history_page.dart';
import 'package:tourly/widgets/shadowed_container.dart';
import 'package:intl/date_symbol_data_local.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  final DateFormat dateFormat = DateFormat.yMMMMEEEEd('id');
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
            WhiteLongButton(
              displayText: "Pilih metode pembayaran",
              onPressed: () {},
            ),
            SizedBox(
              height: 30,
            ),
            ShadowedContainer(
              child: Text("swdw"),
            ),
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
                  "Hotel Surabaya",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text("Check-in"),
                Text(
                  dateFormat.format(
                    DateTime.now(),
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
                  dateFormat.format(DateTime.now()),
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
      duration: Duration(hours: 0, minutes: 1),
    );
  }
}
