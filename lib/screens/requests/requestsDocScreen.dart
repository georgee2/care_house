import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/widgets/request_container.dart';

class RequestsDocScreen extends StatefulWidget {
  final String docPass;

  const RequestsDocScreen({Key? key, required this.docPass}) : super(key: key);

  @override
  State<RequestsDocScreen> createState() => _RequestsDocScreenState();
}

class _RequestsDocScreenState extends State<RequestsDocScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> clinics = FirebaseFirestore.instance
        .collection('clinics')
        .doc(widget.docPass)
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
            stream: clinics,
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
                          FirebaseFirestore.instance.collection('clinics').doc(widget.docPass).collection('accepted').doc().set({
                            'firstName' : '${data.docs[i]['firstName']}',
                            'lastName' : '${data.docs[i]['lastName']}',
                            'time' : DateTime.now(),
                            'phone': '${data.docs[i]['phone']}',
                            'date': '${data.docs[i]['date']}',
                            'pass': widget.docPass,
                            'user': '${data.docs[i]['user']}',
                          });
                          FirebaseFirestore.instance.collection('UsersData').doc('${data.docs[i]['user']}').collection('reservation').doc().set({
                            'firstName' : '${data.docs[i]['firstName']}',
                            'lastName' : '${data.docs[i]['lastName']}',
                            'time' : DateTime.now(),
                            'phone': '${data.docs[i]['phone']}',
                            'date': '${data.docs[i]['date']}',
                            'pass': widget.docPass,
                            'user': '${data.docs[i]['user']}',
                            'placeNme' : '${data.docs[i]['placeNme']}'
                          });
                          FirebaseFirestore.instance.collection('reservationAdmin').doc().set({
                            'firstName' : '${data.docs[i]['firstName']}',
                            'lastName' : '${data.docs[i]['lastName']}',
                            'time' : DateTime.now(),
                            'phone': '${data.docs[i]['phone']}',
                            'date': '${data.docs[i]['date']}',
                            'pass': widget.docPass,
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
