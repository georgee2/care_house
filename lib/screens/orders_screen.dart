import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/widgets/order_container.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    double lastPoints = 0.0;

    getLastPoints(String id) async{
      var docSnapshot = await fireStore.collection('UsersData').doc(id).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        lastPoints = data?['points'];
      }
    }

    final Stream<QuerySnapshot> orders = FirebaseFirestore.instance
        .collection('orders')
        .orderBy('time', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.deepOrange.shade50,
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: orders,
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.requireData.docs.isEmpty) {
                return const Center(
                    child: Text('There is no pets for sell for now'));
              }
              final data = snapshot.requireData;
              return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (BuildContext c, int i) {
                  // double total = data.docs[i]['totalPrice'] /50 * 10;
                  // getLastPoints('${data.docs[i]['user']}');
                  // double points = total + lastPoints;
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async{
                            // FirebaseFirestore.instance.collection('UsersData').doc('${data.docs[i]['user']}').set(
                            //     {
                            //       'points' : points,
                            //     });
                            await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                              myTransaction.delete(snapshot.data!.docs[i].reference);
                            });
                          },
                          child: const Text('Done'),
                        ),
                      ),
                      OrderContainer(
                        address: '${data.docs[i]['address']}',
                        order: data.docs[i]['allOrder'],
                        phone: '${data.docs[i]['phone']}',
                        totalPrice: '${data.docs[i]['totalPrice']}',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
