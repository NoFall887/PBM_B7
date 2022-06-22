import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:tourly/database/facility.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/hotel_detail_page.dart';

class SearchResultPage extends StatelessWidget {
  String? name;
  int? priceMin;
  int? priceMax;
  SearchResultPage({Key? key, this.name, this.priceMin, this.priceMax})
      : super(key: key);

  Future<List<Hotel>> getHotelList() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("hotel");
    Query<Map<String, dynamic>> query = collectionReference.where("nama");
    if (name != null && name!.isNotEmpty) {
      query = collectionReference
          .where("nama", isGreaterThanOrEqualTo: name)
          .where("nama", isLessThanOrEqualTo: name! + "\uf8ff");
    }
    if (priceMin != null) {
      query = query.where("harga", isGreaterThanOrEqualTo: priceMin);
    }
    if (priceMax != null) {
      query = query.where("harga", isLessThanOrEqualTo: priceMax);
    }

    return await query.get().then((QuerySnapshot<Map<String, dynamic>> docs) {
      return docs.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> data = doc.data();
        data = Facility.castFacilities(data);
        return Hotel.create(data);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hasil pencarian"),
      ),
      body: FutureBuilder<List<Hotel>>(
        future: getHotelList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return hotelList(snapshot.data);
          }
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget hotelList(List<Hotel> data) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      itemCount: data.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        Hotel hotel = data[index];
        final currencyFormat =
            NumberFormat.currency(locale: "id_ID", symbol: "Rp.");

        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                offset: const Offset(0, 4),
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
                      hotel: hotel,
                    ),
                    // builder: (context) => Container(),
                  ),
                );
              },
              child: Ink(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    thumbnailImage(hotel),
                    const SizedBox(width: 10),
                    briefDetail(hotel, currencyFormat),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget thumbnailImage(Hotel data) {
    return Flexible(
      flex: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.network(
            data.foto[0],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget briefDetail(Hotel data, NumberFormat currencyFormat) {
    return Flexible(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            data.nama,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            currencyFormat.format(
              data.hargaAkhir,
            ),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 6,
          ),
          RatingBarIndicator(
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemSize: 20,
            rating: data.rating.toDouble(),
            unratedColor: Colors.amber.withOpacity(0.5),
          )
        ],
      ),
    );
  }
}
