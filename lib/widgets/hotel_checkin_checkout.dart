import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tourly/widgets/shadowed_container.dart';

class HotelCheckinCheckout extends StatelessWidget {
  final Widget? actionBtn;
  final double? rating;
  final String hotelName;
  final String? location;
  final DateTime dateCheckin;
  final DateTime dateCheckout;
  late String days = DateTimeRange(start: dateCheckin, end: dateCheckout)
      .duration
      .inDays
      .toString();
  HotelCheckinCheckout({
    Key? key,
    this.actionBtn,
    this.rating,
    required this.hotelName,
    this.location,
    required this.dateCheckin,
    required this.dateCheckout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return ShadowedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HOTEL NAME
          Text(
            hotelName,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
          ),
          // RATING
          (rating != null
              ? RatingBarIndicator(
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemSize: 20,
                  rating: rating!,
                  unratedColor: Colors.amber.withOpacity(0.5),
                )
              : Container()),
          const SizedBox(height: 6),
          // LOCATION
          location != null
              ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.black54,
                  ),
                  Text(
                    location!,
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  )
                ])
              : Container(
                  height: 0,
                ),
          // const SizedBox(height: 8),
          Divider(
            thickness: 2,
            color: Colors.black12,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              checkinCheckout(true),
              hari(),
              checkinCheckout(false),
            ],
          ),
          Container(
            child: this.actionBtn != null ? this.actionBtn! : Container(),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }

  Widget checkinCheckout(bool isCheckin) {
    return Expanded(
      flex: 6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            (isCheckin ? CrossAxisAlignment.start : CrossAxisAlignment.end),
        children: [
          Text(
            "Check-in",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            DateFormat.yMMMMEEEEd('id')
                .format((isCheckin ? this.dateCheckin : this.dateCheckout)),
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
          Text(DateFormat.Hm()
              .format((isCheckin ? this.dateCheckin : this.dateCheckout))),
        ],
      ),
    );
  }

  Widget hari() {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.wb_sunny),
          Text(
            this.days + ' Malam',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
