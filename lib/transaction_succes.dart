import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tourly/database/order.dart';
import 'package:tourly/database/user.dart';
import 'package:tourly/ulasan.dart';
import 'package:tourly/widgets/colors.dart';
import 'package:tourly/widgets/facility.dart';
import 'package:tourly/widgets/hotel_checkin_checkout.dart';
import 'package:tourly/widgets/main_btn.dart';

class Transaction_Suc extends StatelessWidget {
  Transaction_Suc({Key? key}) : super(key: key);

  Future<List<Order>> loadSuccessOrderData(CreateUser user) {
    DocumentReference userReference =
        FirebaseFirestore.instance.collection("user").doc(user.id);
    return FirebaseFirestore.instance
        .collection("pesanan")
        .where("selesai", isEqualTo: true)
        .where(
          "user",
          isEqualTo: userReference,
        )
        .get()
        .then((docs) => Future.wait(docs.docs.map((doc) async {
              Map<String, dynamic> orderData = doc.data();

              Order result =
                  await Order.createFromFirestore(orderData, user, doc.id);

              return result;
            }).toList()));
  }

  @override
  Widget build(BuildContext context) {
    final CreateUser? user = Provider.of<CreateUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Transaksi Berhasil"),
      ),
      body: (user != null
          ? FutureBuilder<List<Order>>(
              future: loadSuccessOrderData(user),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Order> data = snapshot.data;
                  return TiketListView(data);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            )),
    );
  }

  Widget TiketListView(List<Order> orders) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        Order data = orders[index];
        return HotelCheckinCheckout(
          hotelName: data.hotel.nama,
          location: data.hotel.alamat,
          rating: data.hotel.rating.toDouble(),
          dateCheckin: data.checkIn,
          dateCheckout: data.checkOut,
          actionBtn: ulasanBtn(context),
        );
      },
    );
  }

  Widget ulasanBtn(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(MyColor.oren),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: ((context) => Ulasan()))),
      child: Text("Ulasan"),
    );
  }
}
