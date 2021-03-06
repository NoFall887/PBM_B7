import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:tourly/database/facility.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/hotel_detail_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final CollectionReference _hotelReference =
      FirebaseFirestore.instance.collection("hotel");

  Future<List<Hotel>> readHotels(Query query) async {
    try {
      return await query.get().then((value) async {
        return await Future.wait(value.docs.map((doc) async {
          String id = doc.id;
          Hotel data = Hotel.create(Facility.castFacilities(doc.data()), id);
          return data;
        }).toList());
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<List<Hotel>>(
                future: readHotels((_hotelReference
                    .orderBy('rating', descending: true)
                    .limit(5))),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("Something went wrong");
                  }
                  if (snapshot.hasData) {
                    final List<Hotel> hotels = snapshot.data;
                    return hotelCarouselSlider(hotels);
                  } else {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }),
            SizedBox(height: 20),
            FutureBuilder<List<Hotel>>(
              future:
                  readHotels(_hotelReference.where('diskon', isGreaterThan: 0)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text("Something went wrong");
                }
                if (snapshot.hasData) {
                  final List<Hotel> hotels = snapshot.data;
                  return discountListView(hotels);
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Hotel list components
  Widget discountListView(List<Hotel> hotels) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Diskon untuk anda",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: hotels.length,
            itemBuilder: (BuildContext context, int index) {
              var data = hotels[index];
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelDetail(
                            hotel: data,
                          ),
                        ),
                      );
                    },
                    child: Ink(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          thumbnailImage(data.foto[0]),
                          SizedBox(width: 10),
                          briefDetail(data, currencyFormat),
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

  Widget thumbnailImage(String link) {
    return Flexible(
      flex: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.network(
            link,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget briefDetail(Hotel hotel, NumberFormat currencyFormat) {
    return Flexible(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            hotel.nama,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            currencyFormat.format(
              hotel.harga,
            ),
            style: TextStyle(
                color: Colors.red, decoration: TextDecoration.lineThrough),
          ),
          Text(
            currencyFormat.format(
              hotel.hargaAkhir,
            ),
          ),
          RatingBarIndicator(
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemSize: 20,
            rating: hotel.rating,
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

  Widget hotelName(String data, BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white.withOpacity(0.7),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        alignment: Alignment.center,
        child: Text(
          data,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget hotelCarouselSlider(List<Hotel> hotelList) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider.builder(
          itemCount: hotelList.length,
          carouselController: buttonCarouselController,
          itemBuilder: (context, itemIndex, index) {
            var data = hotelList[itemIndex];
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  data.foto[0],
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                ),
                hotelName(data.nama, context),
              ],
            );
          },
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 7),
            enlargeCenterPage: true,
            height: 250,
          ),
        ),
        forwardButton(),
        backButton(),
      ],
    );
  }
}
