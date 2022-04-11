import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(Icons.arrow_back),
        title: Text("Riwayat Pemesanan"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Riwayat pemesanan anda",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            WhiteLongButton(
              displayText: "Transaksi sedang berlangsung",
            ),
            SizedBox(height: 30),
            WhiteLongButton(displayText: "Transaksi berhasil"),
            SizedBox(height: 30),
            WhiteLongButton(displayText: "Transaksi dibatalkan"),
            SizedBox(height: 30),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class WhiteLongButton extends StatelessWidget {
  final String displayText;
  // final Function routerFunction;
  const WhiteLongButton({
    Key? key,
    required this.displayText,
    // this.routerFunction = ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            this.displayText,
            style: TextStyle(fontSize: 14),
          ),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        fixedSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width, 50),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
