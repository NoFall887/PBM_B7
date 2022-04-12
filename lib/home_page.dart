import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

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
      'diskon': 375000
    },
    {
      'link':
          "https://img.inews.co.id/media/600/files/inews_new/2021/10/08/hotel_citradream_bintaro.jpg",
      'rating': 4.5,
      'nama': "Hotel sukamaju",
      'harga': 440000,
      'diskon': 250000
    },
    {
      'link':
          "https://imgcy.trivago.com/c_lfill,d_dummy.jpeg,e_sharpen:60,f_auto,h_450,q_auto,w_450/itemimages/68/47/6847396.jpeg",
      'rating': 5,
      'nama': "Hotel sukamundur",
      'harga': 450000,
      'diskon': 370000
    },
    {
      'link':
          "https://dkgzabag3frbh.cloudfront.net/attachments/room_type_photos/images/610463/610463/standard_IMG_6640.jpg",
      'rating': 4,
      'nama': "Hotel maju sejahtera",
      'harga': 400000,
      'diskon': 375000
    },
    {
      'link':
          "https://media-cdn.tripadvisor.com/media/photo-s/0f/76/68/b1/twin-room.jpg",
      'rating': 4.5,
      'nama': "Hotel apalah",
      'harga': 440000,
      'diskon': 250000
    },
    {
      'link':
          "https://t4.ftcdn.net/jpg/00/90/42/33/240_F_90423384_EPURKnsID1eC8GX5lZU84nscT3MQSh6X.jpg",
      'rating': 5,
      'nama': "Hotel mboh",
      'harga': 450000,
      'diskon': 370000
    },
  ];

  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            hotelCarouselSlider(),
            SizedBox(height: 20),
            discountListView(),
          ],
        ),
      ),
    );
  }

  // Hotel list components
  Widget discountListView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      color: Colors.white,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: dummyHotelList.length,
        itemBuilder: (BuildContext context, int index) {
          var data = dummyHotelList[index];
          final currencyFormat =
              NumberFormat.currency(locale: "id_ID", symbol: "Rp.");
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  offset: Offset(0, 4),
                  blurRadius: 6,
                  spreadRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                thumbnailImage(data),
                SizedBox(width: 10),
                briefDetail(data, currencyFormat),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget thumbnailImage(Map data) {
    return Flexible(
      flex: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.network(
            data["link"],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget briefDetail(Map data, NumberFormat currencyFormat) {
    return Flexible(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            data["nama"],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            currencyFormat.format(
              data["harga"],
            ),
            style: TextStyle(
                color: Colors.red, decoration: TextDecoration.lineThrough),
          ),
          Text(
            currencyFormat.format(
              data["diskon"],
            ),
          ),
          RatingBarIndicator(
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemSize: 20,
            rating: data["rating"].toDouble(),
            unratedColor: Colors.amber.withOpacity(0.5),
          )
        ],
      ),
    );
  }
  // HOTEL CAROUSEL COMPONENTS

  Widget backButton() {
    return Positioned(
      left: 0,
      child: IconButton(
        // color: Colors.white,
        onPressed: () {
          buttonCarouselController.previousPage(
              duration: Duration(milliseconds: 400));
        },
        icon: Icon(
          Icons.arrow_back_ios,
          size: 35,
        ),
      ),
    );
  }

  Widget forwardButton() {
    return Positioned(
      right: 0,
      child: IconButton(
        // color: Colors.white,
        onPressed: () {
          buttonCarouselController.nextPage(
              duration: Duration(milliseconds: 400));
        },
        icon: Icon(
          Icons.arrow_forward_ios,
          size: 35,
        ),
      ),
    );
  }

  Widget HotelName(Map data, BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white.withOpacity(0.7),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        alignment: Alignment.center,
        child: Text(
          data["nama"],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget hotelCarouselSlider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider.builder(
          itemCount: dummyHotelList.length,
          carouselController: buttonCarouselController,
          itemBuilder: (context, itemIndex, index) {
            var data = dummyHotelList[itemIndex];
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  data["link"],
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                ),
                HotelName(data, context),
              ],
            );
          },
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 7),
            enlargeCenterPage: true,
            height: 300,
          ),
        ),
        forwardButton(),
        backButton(),
      ],
    );
  }
}
