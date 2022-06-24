import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourly/database/facility.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/database/order.dart';
import 'package:tourly/database/room_type.dart';
import 'package:tourly/database/user.dart';
import 'package:tourly/history_page.dart';
import 'package:tourly/ongoing_order_detail.dart';
import 'package:tourly/widgets/colors.dart';
import 'package:tourly/widgets/hotel_checkin_checkout.dart';
import 'package:tourly/widgets/main_btn.dart';
import 'package:tourly/widgets/shadowed_container.dart';

class OngoingOrder extends StatelessWidget {
  const OngoingOrder({Key? key}) : super(key: key);

  Stream<Future<List<Order>>> loadOngoingOrderData(CreateUser user) {
    DocumentReference userReference =
        FirebaseFirestore.instance.collection("user").doc(user.id);
    return FirebaseFirestore.instance
        .collection("pesanan")
        .where("batas", isGreaterThan: Timestamp.now())
        .where("selesai", isEqualTo: false)
        .where(
          "user",
          isEqualTo: userReference,
        )
        .snapshots()
        .map((snapshot) => Future.wait(snapshot.docs
            .map((doc) => Order.createFromFirestore(doc.data(), user, doc.id))
            .toList()));
  }

  @override
  Widget build(BuildContext context) {
    final CreateUser? user = Provider.of<CreateUser?>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Transaksi Berlangsung"),
        ),
        body: (user != null
            ? StreamBuilder<Future<List<Order>>>(
                stream: loadOngoingOrderData(user),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    Future<List<Order>> data = snapshot.data;
                    return FutureBuilder<List<Order>>(
                      future: data,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List<Order> data = snapshot.data;
                          return buildPage(data);
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        ;
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              )));
  }

  Widget buildPage(List<Order> orderList) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      itemCount: orderList.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        Order data = orderList[index];

        return HotelCheckinCheckout(
          hotelName: data.hotel.nama,
          location: data.hotel.alamat,
          rating: data.hotel.rating.toDouble(),
          dateCheckin: data.checkIn,
          dateCheckout: data.checkOut,
          actionBtn: ulasanBtn(context, data),
        );
      },
    );
  }

  Widget ulasanBtn(BuildContext context, Order order) {
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
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => OngoingOrderDetail(order: order)),
          ),
        );
      },
      child: Text("Lihat detail"),
    );
  }
}
