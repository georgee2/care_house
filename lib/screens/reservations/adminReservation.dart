import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/widgets/user_reserv_container.dart';

class AdminReservationsScreen extends StatefulWidget {
  const AdminReservationsScreen({Key? key}) : super(key: key);

  @override
  State<AdminReservationsScreen> createState() => _AdminReservationsScreenState();
}

class _AdminReservationsScreenState extends State<AdminReservationsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> reservation = FirebaseFirestore.instance
        .collection("reservationAdmin")
        .orderBy('time', descending: true)
        .snapshots();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade50,
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
        color: Colors.cyan.shade50,
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: reservation,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.requireData.docs.isEmpty) {
                      return const Center(
                          child: Text('You have no reservations'));
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (BuildContext c, int i) {
                        return Column(
                          children: [
                            Stack(
                              children: [
                                UserReservContainer(
                                  firstName: '${data.docs[i]['firstName']}',
                                  lastName: '${data.docs[i]['lastName']}',
                                  phone: '${data.docs[i]['phone']}',
                                  date: '${data.docs[i]['date']}',
                                  placeName: '${data.docs[i]['placeNme']}',
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () async{
                                      await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                                        myTransaction.delete(snapshot.data!.docs[i].reference);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
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
          ],
        ),
      ),
    );
  }
}
