import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/reservations/docReservationScreen.dart';
import 'package:untitled/upload_data/add_clinic.dart';
import 'package:untitled/widgets/clinic_container.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({Key? key}) : super(key: key);

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  // TextEditingController textController = TextEditingController();
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   textController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> clinic = FirebaseFirestore.instance
        .collection("clinics")
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text(
            //       'Search for a clinic:',
            //       style: TextStyle(fontSize: 20),
            //     ),
            //     AnimSearchBar(
            //       width: MediaQuery.of(context).size.width * 0.6,
            //       textController: textController,
            //       onSuffixTap: () {
            //         setState(() {
            //           textController.clear();
            //         });
            //       },
            //     )
            //   ],
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: clinic,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.requireData.docs.isEmpty) {
                      return const Center(
                          child: Text('There is no clinics available'));
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (BuildContext c, int i) {
                        return Column(
                          children: [
                            Stack(
                              children: [
                                ClinicContainer(
                                  name: '${data.docs[i]['placeName']}',
                                  phone: '${data.docs[i]['phone']}',
                                  location: '${data.docs[i]['location']}',
                                  imageUrl: '${data.docs[i]['imageUrl']}',
                                  price: '${data.docs[i]['price']}',
                                  navigate: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DocReservationScreen(
                                            clinicPass: '${data.docs[i]['password']}', clinicName: '${data.docs[i]['placeName']}',
                                          ))),
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
      //only admin can add clinic
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddClinic())),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}
