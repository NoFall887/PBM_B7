import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tourly/widgets/colors.dart';
import 'package:tourly/widgets/facility.dart';

const hotelPhotoList = <String>[
  "https://cdn.pixabay.com/photo/2019/08/19/13/58/bed-4416515__340.jpg",
  "https://cdn.pixabay.com/photo/2019/08/19/13/58/bed-4416515__340.jpg",
  "https://cdn.pixabay.com/photo/2019/08/19/13/58/bed-4416515__340.jpg",
  "https://cdn.pixabay.com/photo/2019/08/19/13/58/bed-4416515__340.jpg",
];

const Map hotelData = {
  "name": "Regantris Hotel Surabaya",
  "rating": 4.5,
  "location": "Tegalsari, Surabaya, Jawa Timur",
  "facility": <String>["Kolam", "Parkir", "Wifi", "Gym", "Restoran"],
  "description":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
};

class HotelDetail extends StatefulWidget {
  HotelDetail({Key? key}) : super(key: key);

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Hotel"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hotelCarousel(),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: hotelDescription(),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
            Positioned(child: bottomBar(), bottom: 0),
          ],
        ),
      ),
    );
  }

  Widget hotelCarousel() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider.builder(
          itemCount: hotelPhotoList.length,
          itemBuilder: (context, itemIndex, index) {
            var data = hotelPhotoList[itemIndex];
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                data,
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height,
              ),
            );
          },
          options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 10),
              viewportFraction: 1,
              enlargeCenterPage: true,
              height: 250,
              onPageChanged: (index, changeReason) {
                setState(() {
                  activeIndex = index;
                });
              }),
        ),
        Positioned(
          bottom: 20,
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: hotelPhotoList.length,
            effect: WormEffect(
              activeDotColor: Colors.blue.shade300,
              dotHeight: 11,
              dotWidth: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget hotelDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hotelName(),
        aboutHotel(),
        facility(),
      ],
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

  Widget aboutHotel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tentang hotel",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        SizedBox(height: 8),
        ReadMoreText(
          hotelData["description"],
          trimLines: 4,
          colorClickableText: Colors.blue.shade300,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 8),
        sectionDivider(),
        SizedBox(height: 8),
      ],
    );
  }

  Widget facility() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Fasilitas",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hotelData["facility"].length,
            itemBuilder: (BuildContext context, int index) {
              return hotelFacilityItem(
                facilityName: hotelData["facility"][index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget sectionDivider() {
    return Divider(
      thickness: 2,
      color: Colors.black12,
    );
  }

  Widget bottomBar() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 10,
        ),
      ], color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Harga kamar mulai dari",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
                Text(
                  currencyFormat.format(4999000),
                  style: TextStyle(
                      color: Colors.orange.shade400,
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Pesan hotel",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(MyColor.oren),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 10, horizontal: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
