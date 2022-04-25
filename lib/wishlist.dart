// ignore_for_file: non_constant_identifier_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:favorite_button/favorite_button.dart';

class Wishlist extends StatelessWidget {
  Wishlist({Key? key}) : super(key: key);

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
  ];

  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            WishListView(),
          ],
        ),
      ),
    );
  }

  Widget WishListView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Yang ingin Anda Kunjungi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dummyHotelList.length,
            itemBuilder: (BuildContext context, int index) {
              var data = dummyHotelList[index];
              final currencyFormat =
                  NumberFormat.currency(locale: "id_ID", symbol: "Rp.");
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
                      child: Row(
                        children: [
                          thumbnailImage(data),
                          const SizedBox(width: 10),
                          briefDetail(data, currencyFormat),
                          Favorite(data),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget thumbnailImage(Map data) {
    return Expanded(
      // flex: 1,
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

  Widget Favorite(Map data) {
    return Container(
      alignment: Alignment.centerRight,
      child: FavoriteButton(
        isFavorite: true,
        valueChanged: (_isFavorite) {},
      ),
    );
  }

  Widget briefDetail(Map data, NumberFormat currencyFormat) {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["nama"],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text(
            currencyFormat.format(
              data["harga"],
            ),
            style: const TextStyle(
                color: Colors.red, decoration: TextDecoration.lineThrough),
          ),
          Text(
            currencyFormat.format(
              data["diskon"],
            ),
          ),
          RatingBarIndicator(
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemSize: 20,
            rating: data["rating"].toDouble(),
            unratedColor: Colors.amber.withOpacity(0.5),
          ),
          // FavoriteButton(
          //   isFavorite: true,
          //   valueChanged: (_isFavorite) {},
          // ),
        ],
      ),
    );
  }
}
