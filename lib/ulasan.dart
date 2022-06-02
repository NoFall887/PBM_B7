import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tourly/upload_file.dart';
import 'package:tourly/widgets/colors.dart';
import 'package:tourly/widgets/facility.dart';
import 'package:tourly/widgets/hotel_checkin_checkout.dart';
import 'package:tourly/widgets/main_btn.dart';
import 'package:tourly/widgets/shadowed_container.dart';

final dummyItem = [
  "https://cdn.pixabay.com/photo/2016/04/25/22/41/cat-1353325_960_720.jpg",
  "https://cdn.pixabay.com/photo/2017/11/30/12/35/cat-2988354_960_720.jpg",
  "https://t4.ftcdn.net/jpg/00/90/42/33/240_F_90423384_EPURKnsID1eC8GX5lZU84nscT3MQSh6X.jpg",
];

final dummyHotelList = <Map>[
  {
    'link':
        "https://img.okezone.com/content/2021/03/20/406/2381202/5-hotel-di-tangerang-harganya-di-bawah-rp100-ribu-FdFIttej5V.jpg",
    'rating': 4,
    'nama': "Hotel maju sejahtera",
    'harga': 400000,
    'diskon': 375000,
    "location": "Gayungan, Surabaya, Jawa Timur",
  },
];

const hotelPhotoList = <String>[
  "https://cdn.pixabay.com/photo/2019/08/19/13/58/bed-4416515__340.jpg",
  "https://cdn.pixabay.com/photo/2019/08/19/13/58/bed-4416515__340.jpg",
  "https://cdn.pixabay.com/photo/2019/08/19/13/58/bed-4416515__340.jpg",
  "https://cdn.pixabay.com/photo/2019/08/19/13/58/bed-4416515__340.jpg",
];

const Map hotelData = {
  "name": "Primebiz Surabaya",
  "rating": 4.5,
  "location": "Gayungan, Surabaya, Jawa Timur",
  "facility": <String>["Kolam", "Parkir", "Wifi", "Gym", "Restoran"],
  "description":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
};

class Ulasan extends StatefulWidget {
  Ulasan({Key? key}) : super(key: key);

  @override
  State<Ulasan> createState() => _UlasanState();
}

class _UlasanState extends State<Ulasan> {
  double _rating = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ulasan"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HotelCheckinCheckout(
                hotelName: hotelData['name'],
                dateCheckin: DateTime.now(),
                dateCheckout: DateTime.now().add(
                  Duration(days: 1),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ratingFormSection()
            ],
          ),
        ),
      ),
    );
  }

  Widget ratingFormSection() {
    return ShadowedContainer(
      child: Column(
        children: [
          ratingInput(),
          SizedBox(
            height: 20,
          ),
          form_ulasan(),
          SizedBox(
            height: 20,
          ),
          Upload(),
          const SizedBox(
            height: 20,
          ),
          MainBtn(
            btnText: "Kirim",
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Widget TiketListView(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(8),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.25),
  //                 offset: const Offset(0, 4),
  //                 blurRadius: 6,
  //                 spreadRadius: 3,
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             children: [
  //               ticketDescription(),
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   checkin(),
  //                   hari(),
  //                   checkout(),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 24,
  //         ),
  //         ratingInput(),
  //         form_ulasan(),
  //         const SizedBox(
  //           height: 14,
  //         ),
  //         Upload(),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         MainBtn(
  //           btnText: "Kirim",
  //           onPressed: () {},
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget ratingInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Rating",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        RatingBar.builder(
          initialRating: 4,
          minRating: 1,
          allowHalfRating: true,
          itemBuilder: ((context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              )),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
      ],
    );
  }
}

Widget form_ulasan() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 15),
      Icon(
        Icons.text_fields,
        size: 25,
        color: Colors.blue.shade400,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Ulasan",
          ),
        ),
      ),
    ],
  );
}

Widget hari() {
  return Expanded(
    flex: 3,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.sunny),
        const Text(
          "1 Malam",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
        ),
      ],
    ),
  );
}
