import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:tourly/database/facility.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/hotel_detail_page.dart';

class HotelNearby extends StatefulWidget {
  HotelNearby({Key? key}) : super(key: key);

  @override
  State<HotelNearby> createState() => _HotelNearbyState();
}

class _HotelNearbyState extends State<HotelNearby> {
  final LatLng _initialCameraPosition = const LatLng(0, 0);
  late GoogleMapController _mapController;
  final Location _location = Location();
  final Set<Marker> _markers = new Set(); //markers for google map
  List<Hotel>? _sortedHotel;
  Geoflutterfire geo = Geoflutterfire();

  Future<LocationData> getUserLocation() async {
    return await _location.getLocation();
  }

  Stream<List<Hotel>>? getHotelData(LocationData userLocation) {
    final hotelReference = FirebaseFirestore.instance.collection("hotel");
    GeoFireCollectionRef geoRef = geo.collection(collectionRef: hotelReference);

    GeoFirePoint point = geo.point(
        latitude: userLocation.latitude!, longitude: userLocation.longitude!);

    Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream = geoRef.within(
        center: point, radius: 1000, field: "koordinat", strictMode: true);

    return stream.map((List<DocumentSnapshot<Map<String, dynamic>>> docList) {
      return docList.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic>? data = Facility.castFacilities(doc.data());
        GeoPoint lokasiHotel = data["koordinat"]["geopoint"];
        double jarak = point.kmDistance(
            lat: lokasiHotel.latitude, lng: lokasiHotel.longitude);
        return Hotel.createNearby(data, jarak);
      }).toList();
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    _mapController = _cntlr;

    _location.getLocation().then((l) async {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_sortedHotel![0].koordinat!.latitude,
                _sortedHotel![0].koordinat!.longitude),
            zoom: 15,
          ),
        ),
      );
      getMarker();
    });
  }

  Set<Marker> getMarker() {
    setState(() {
      for (var i = 0; i < _sortedHotel!.length; i++) {
        Hotel hotel = _sortedHotel![i];
        _markers.add(Marker(
            markerId: MarkerId(hotel.nama),
            position:
                LatLng(hotel.koordinat!.latitude, hotel.koordinat!.longitude),
            infoWindow: InfoWindow(
                title: hotel.nama, snippet: hotel.hargaAkhir.toString()),
            icon: BitmapDescriptor.defaultMarker));
      }
    });
    return _markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel disekitar'),
      ),
      body: FutureBuilder<LocationData>(
          future: getUserLocation(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            if (snapshot.hasData) {
              return StreamBuilder<List<Hotel>>(
                  stream: getHotelData(snapshot.data!),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Hotel>> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    if (snapshot.hasData) {
                      _sortedHotel = snapshot.data;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 250),
                            child: GoogleMap(
                              zoomGesturesEnabled: true,
                              initialCameraPosition: CameraPosition(
                                  target: _initialCameraPosition, zoom: 15),
                              mapType: MapType.normal,
                              onMapCreated: _onMapCreated,
                              markers: _markers,
                            ),
                          ),
                          Expanded(child: hotelList()),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget hotelList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: _sortedHotel!.length,
      itemBuilder: (BuildContext context, int index) {
        Hotel data = _sortedHotel![index];
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
                      hotel: data,
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
                    thumbnailImage(data),
                    const SizedBox(width: 10),
                    briefDetail(data, currencyFormat),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey,
              ),
              Text(
                data.jarak! > 1
                    ? (data.jarak!).toStringAsFixed(1) + ' Km'
                    : (data.jarak! * 1000).toStringAsFixed(1) + ' M',
                style: const TextStyle(color: Colors.grey),
              )
            ],
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
