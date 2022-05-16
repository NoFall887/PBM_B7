import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:tourly/dummy_hotel_data.dart';
import 'package:tourly/hotel_detail_page.dart';
import 'package:tourly/maps_services.dart';

class HotelNearby extends StatefulWidget {
  HotelNearby({Key? key}) : super(key: key);

  @override
  State<HotelNearby> createState() => _HotelNearbyState();
}

class _HotelNearbyState extends State<HotelNearby> {
  LatLng _initialCameraPosition = LatLng(0, 0);
  late GoogleMapController _mapController;
  Location _location = Location();
  final Set<Marker> _markers = new Set(); //markers for google map
  List _sortedHotel = [];

  void _onMapCreated(GoogleMapController _cntlr) async {
    _mapController = _cntlr;

    _location.getLocation().then((l) {
      _sortedHotel =
          MapsServices().getClosest(HotelList, l.latitude!, l.longitude!);
      print(_sortedHotel[0]);
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                _sortedHotel[0]["latlng"][0], _sortedHotel[0]["latlng"][1]),
            zoom: 15,
          ),
        ),
      );
      getMarker();
    });
  }

  Set<Marker> getMarker() {
    setState(() {
      for (var i = 0; i < _sortedHotel.length; i++) {
        var hotel = _sortedHotel[i];
        _markers.add(Marker(
            markerId: MarkerId(hotel["nama"]),
            position: LatLng(hotel["latlng"][0], hotel["latlng"][1]),
            infoWindow: InfoWindow(
                title: hotel["nama"], snippet: hotel["harga"].toString()),
            icon: BitmapDescriptor.defaultMarker));
      }
    });
    return _markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel disekitar'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 250),
            child: GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: _initialCameraPosition, zoom: 15),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              markers: _markers,
              myLocationEnabled: true,
            ),
          ),
          Expanded(child: hotelList()),
        ],
      ),
    );
  }

  Widget hotelList() {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: _sortedHotel.length,
        itemBuilder: (BuildContext context, int index) {
          var data = _sortedHotel[index];
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
                      builder: (context) => HotelDetail(),
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
                      thumbnailImage(data),
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
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey,
              ),
              Text(
                data["distance"] >= 1000
                    ? (data["distance"] / 1000).toStringAsFixed(1) + ' Km'
                    : data["distance"].toStringAsFixed(1) + ' M',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Text(
            currencyFormat.format(
              data["harga"],
            ),
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 6,
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
}
