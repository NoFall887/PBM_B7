import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tourly/widgets/hotel_checkin_checkout.dart';
import 'package:tourly/widgets/main_btn.dart';
import 'package:tourly/widgets/room_facility.dart';
import 'package:tourly/widgets/shadowed_container.dart';

Map<String, dynamic> hotelData = {
  "name": "Primebiz Surabaya",
  "rating": 4.5,
  "location": "Gayungan, Surabaya, Jawa Timur",
  "facility": <String>["Kolam", "Parkir", "Wifi", "Gym", "Restoran"],
  "description":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  "checkin": DateTime.now(),
  'checkout': DateTime.now().add(Duration(days: 1)),
};

Map<String, dynamic> roomData = {
  "name": "Standard Doubled Bed - Smoking",
  "type": "double bed",
  "guest": 2,
  "photo":
      "https://img.inews.co.id/media/600/files/inews_new/2021/10/08/hotel_citradream_bintaro.jpg",
  "faciity": ['wifi', 'sarapan'],
};

class OrderReview extends StatelessWidget {
  const OrderReview({Key? key}) : super(key: key);

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
                  hotelName: hotelData['name'],
                  dateCheckin: hotelData['checkin'],
                  dateCheckout: hotelData['checkout'],
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
                MainBtn(btnText: "Lanjut ke pembayaran", onPressed: () {}),
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
            roomData["name"],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          typeAndGuest("Tipe kamar", roomData["type"]),
          SizedBox(
            height: 4,
          ),
          typeAndGuest("Tamu", roomData["guest"].toString() + " orang/kamar"),
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
                // roomData["photo"],
                "https://img.inews.co.id/media/600/files/inews_new/2021/10/08/hotel_citradream_bintaro.jpg",
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
          hotelData["description"],
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
