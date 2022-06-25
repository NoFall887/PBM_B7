import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tourly/database/order.dart';
import 'package:tourly/database/ulasan.dart';
import 'package:tourly/upload_file.dart';
import 'package:tourly/widgets/colors.dart';
import 'package:tourly/widgets/facility.dart';
import 'package:tourly/widgets/hotel_checkin_checkout.dart';
import 'package:tourly/widgets/main_btn.dart';
import 'package:tourly/widgets/shadowed_container.dart';

class UploadImageProvider with ChangeNotifier {
  XFile? image;
  UploadImageProvider({this.image});
  void changeImage(XFile newImage) {
    image = newImage;
    notifyListeners();
  }
}

class Ulasan extends StatelessWidget {
  final Order order;
  const Ulasan({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => UploadImageProvider()),
      child: UlasanWrapper(order: order),
    );
  }
}

class UlasanWrapper extends StatefulWidget {
  final Order order;
  const UlasanWrapper({Key? key, required this.order}) : super(key: key);

  @override
  State<UlasanWrapper> createState() => _UlasanWrapperState();
}

class _UlasanWrapperState extends State<UlasanWrapper> {
  double _rating = 1;

  final TextEditingController _ulasanController = TextEditingController();

  uploadUlasan(XFile? image) async {
    if (image == null) return;
    File file = File(image.path);
    String? url;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("image-" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });
    UlasanData ulasanData = UlasanData(
      foto: url!,
      hotel: widget.order.hotel,
      ulasan: _ulasanController.text,
      user: widget.order.user,
      rating: _rating,
    );
    DocumentReference<Map<String, dynamic>> ulasanReference =
        await FirebaseFirestore.instance
            .collection("ulasan")
            .add(ulasanData.toMap());
    DocumentReference<Map<String, dynamic>> orderReference =
        FirebaseFirestore.instance.collection("pesanan").doc(widget.order.id);
    await orderReference.update({"ulasan": ulasanReference});

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    XFile? image = Provider.of<UploadImageProvider>(context).image;
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
                hotelName: widget.order.hotel.nama,
                dateCheckin: widget.order.checkIn,
                dateCheckout: widget.order.checkOut,
              ),
              SizedBox(
                height: 16,
              ),
              (widget.order.review == null
                  ? ratingFormSection(image)
                  : reviewSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewSection() {
    return ShadowedContainer(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Rating",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            RatingBarIndicator(
              itemBuilder: ((context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  )),
              itemSize: 50,
              rating: widget.order.review!.rating,
              unratedColor: Colors.amber.withOpacity(0.5),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Ulasan",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          widget.order.review!.ulasan,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            widget.order.review!.foto,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: 250,
          ),
        ),
      ],
    ));
  }

  Widget ratingFormSection(XFile? image) {
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
            onPressed: () {
              uploadUlasan(image);
            },
          ),
        ],
      ),
    );
  }

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
            controller: _ulasanController,
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
}
