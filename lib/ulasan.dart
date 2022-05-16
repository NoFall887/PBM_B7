import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tourly/upload_file.dart';
import 'package:tourly/widgets/colors.dart';
import 'package:tourly/widgets/facility.dart';
import 'package:tourly/widgets/main_btn.dart';

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

class Ulasan extends StatelessWidget {
  Ulasan({Key? key}) : super(key: key);

  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ulasan"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            TiketListView(context),
          ],
        ),
      ),
    );
  }

  Widget hotelName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hotelData["name"],
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        RatingBarIndicator(
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemSize: 20,
          rating: hotelData['rating'],
          unratedColor: Colors.amber.withOpacity(0.5),
        ),
        SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
            Text(
              hotelData["location"],
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        SizedBox(height: 8),
        sectionDivider(),
        SizedBox(height: 8)
      ],
    );
  }

  Widget sectionDivider() {
    return Divider(
      thickness: 2,
      color: Colors.black12,
    );
  }

  Widget ticketDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hotelName(),
      ],
    );
  }

  Widget TiketListView(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dummyHotelList.length,
            itemBuilder: (BuildContext context, int index) {
              var data = dummyHotelList[index];
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      offset: Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Material(
                  child: InkWell(
                    onTap: () {
                      print("object");
                    },
                    child: Ink(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(width: 40),
                          Column(
                            children: [
                              ticketDescription(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  checkin(),
                                  const SizedBox(width: 10),
                                  hari(),
                                  checkout(),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 14,
          ),
          form_ulasan(),
          SizedBox(
            height: 14,
          ),
          form_gambar(context),
          SizedBox(
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

  Widget checkin() {
    return Expanded(
      flex: 6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Check-in", style: TextStyle(fontSize: 12)),
          Text(
            "Rabu, 9 Maret 2022",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
          Text("14.00"),
        ],
      ),
    );
  }

  Widget checkout() {
    return Expanded(
      flex: 6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Check-out",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            "Kamis, 10 Maret 2022",
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
          Text("12.00"),
        ],
      ),
    );
  }

  ulasan(BuildContext context) {}
}

Widget form_ulasan() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: 15),
      Icon(
        Icons.text_fields,
        size: 25,
        color: Colors.blue.shade400,
      ),
      SizedBox(width: 10),
      Expanded(
        child: TextFormField(
          decoration: InputDecoration(
              border: UnderlineInputBorder(), labelText: "Ulasan"),
        ),
      ),
      SizedBox(width: 4),
    ],
  );
}

Widget form_gambar(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: 15),
      Expanded(
          child: TextButton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_rounded,
              color: Colors.black,
            ),
            Text(
              "Lampirkan Gambar",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => Upload())));
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey.withOpacity(0.2),
          primary: Colors.grey.withOpacity(0.2),
          elevation: 0,
          fixedSize: Size(double.infinity, 140),
        ),
      )),
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
        Icon(Icons.sunny),
        Text(
          "1 Malam",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
        ),
      ],
    ),
  );
}
