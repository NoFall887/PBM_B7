import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/database/order.dart';
import 'package:tourly/database/room_type.dart';
import 'package:tourly/payment_page.dart';
import 'package:tourly/widgets/hotel_checkin_checkout.dart';
import 'package:tourly/widgets/main_btn.dart';
import 'package:tourly/widgets/room_facility.dart';
import 'package:tourly/widgets/shadowed_container.dart';

class OrderReview extends StatelessWidget {
  final Hotel hotelData;
  final RoomType roomType;
  final DateTime checkIn;
  final DateTime checkOut;
  final String namaPenghuni;
  final int durasi;
  final Order order;
  const OrderReview({
    Key? key,
    required this.hotelData,
    required this.roomType,
    required this.checkIn,
    required this.checkOut,
    required this.namaPenghuni,
    required this.durasi,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Pesanan'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            child: Text(
              'Mohon periksa kembali data pemesanan anda sebelum melanjutkan ke pembayaran',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade800,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
              children: [
                HotelCheckinCheckout(
                  hotelName: hotelData.nama,
                  dateCheckin: checkIn,
                  dateCheckout: checkOut,
                ),
                SizedBox(
                  height: 8,
                ),
                room(),
                SizedBox(
                  height: 8,
                ),
                description(),
                SizedBox(
                  height: 32,
                ),
                MainBtn(
                    btnText: "Lanjut ke pembayaran",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => PaymentPage(
                                    order: order,
                                  ))));
                    }),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget room() {
    return ShadowedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            roomType.nama + (roomType.smoking ? " - smoking" : ""),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          typeAndGuest("Tipe kamar", roomType.nama),
          SizedBox(
            height: 4,
          ),
          typeAndGuest(
              "Tamu", roomType.jumlahKasur.toString() + " orang/kamar"),
          SizedBox(
            height: 16,
          ),
          photoAndFacility(),
        ],
      ),
    );
  }

  Widget typeAndGuest(String textLeft, String textRight) {
    return Row(
      children: [
        Expanded(child: Text(textLeft)),
        Expanded(child: Text(textRight)),
      ],
    );
  }

  Widget photoAndFacility() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                hotelData.foto[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Expanded(
          flex: 4,
          child: RoomFacility(facilities: ['wifi']),
        ),
      ],
    );
  }

  Widget description() {
    return ShadowedContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kebijakan hotel & kamar",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        SizedBox(
          height: 8,
        ),
        ReadMoreText(
          hotelData.deskripsi!,
          trimLines: 9,
          colorClickableText: Colors.blue.shade300,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.justify,
        ),
      ],
    ));
  }
}
