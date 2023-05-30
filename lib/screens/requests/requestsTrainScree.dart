import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/widgets/request_container.dart';

class RequestsTrainScreen extends StatefulWidget {
  final String trainPass;

  const RequestsTrainScreen({Key? key, required this.trainPass}) : super(key: key);

  @override
  State<RequestsTrainScreen> createState() => _RequestsTrainScreenState();
}

class _RequestsTrainScreenState extends State<RequestsTrainScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> train = FirebaseFirestore.instance
        .collection('training')
        .doc(widget.trainPass)
        .collection('requests')
        .orderBy('time', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        color: Colors.white,
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: train,
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.requireData.docs.isEmpty) {
                return const Center(child: Text('You have no reservation for now'));
              }
              final data = snapshot.requireData;
              return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (BuildContext c, int i) {
                  return Column(
                    children: [
                      RequestContainer(
                        firstName: '${data.docs[i]['firstName']}',
                        lastName: '${data.docs[i]['lastName']}',
                        phone: '${data.docs[i]['phone']}',
                        date: '${data.docs[i]['date']}',
                        accept: () async{
                          FirebaseFirestore.instance.collection('training').doc(widget.trainPass).collection('accepted').doc().set({
                            'firstName' : '${data.docs[i]['firstName']}',
                            'lastName' : '${data.docs[i]['lastName']}',
                            'time' : DateTime.now(),
                            'phone': '${data.docs[i]['phone']}',
                            'date': '${data.docs[i]['date']}',
                            'pass': widget.trainPass,
                            'user': '${data.docs[i]['user']}',
                          });
                          FirebaseFirestore.instance.collection('UsersData').doc('${data.docs[i]['user']}').collection('reservation').doc().set({
                            'firstName' : '${data.docs[i]['firstName']}',
                            'lastName' : '${data.docs[i]['lastName']}',
                            'time' : DateTime.now(),
                            'phone': '${data.docs[i]['phone']}',
                            'date': '${data.docs[i]['date']}',
                            'pass': widget.trainPass,
                            'user': '${data.docs[i]['user']}',
                            'placeNme' : '${data.docs[i]['placeNme']}'
                          });
                          FirebaseFirestore.instance.collection('reservationAdmin').doc().set({
                            'firstName' : '${data.docs[i]['firstName']}',
                            'lastName' : '${data.docs[i]['lastName']}',
                            'time' : DateTime.now(),
                            'phone': '${data.docs[i]['phone']}',
                            'date': '${data.docs[i]['date']}',
                            'pass': widget.trainPass,
                            'user': '${data.docs[i]['user']}',
                            'placeNme' : '${data.docs[i]['placeNme']}'
                          });
                          await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                            myTransaction.delete(snapshot.data!.docs[i].reference);
                          });
                        },
                        decline: () async{
                          await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                            myTransaction.delete(snapshot.data!.docs[i].reference);
                          });
                        },
                      ),
                      const SizedBox(height: 10,),
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
