import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tourly/database/payment_method.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  Future<List<PaymentMethodData>> getPaymentMethod() async {
    return await FirebaseFirestore.instance
        .collection("bank")
        .get()
        .then((docs) {
      return docs.docs.map((doc) {
        return PaymentMethodData.create(doc);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih metode"),
      ),
      body: FutureBuilder<List<PaymentMethodData>>(
        future: getPaymentMethod(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<PaymentMethodData> data = snapshot.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, data[index]);
                        },
                        child: Text(
                          data[index].nama,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                      color: Colors.grey.shade400,
                    )
                  ],
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
