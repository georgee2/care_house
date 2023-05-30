import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/reservations/trainReservationScreen.dart';
import 'package:untitled/upload_data/add_training.dart';
import 'package:untitled/widgets/training_container.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  // TextEditingController textController = TextEditingController();
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   textController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> train = FirebaseFirestore.instance
        .collection("training")
        .orderBy('time', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.blueGrey.shade50,
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
            //     ),
            //   ],
            // ),
            // TrainingContainer(
            //   name: 'Pet Vet',
            //   phone: '01287395885',
            //   navigate: () {},
            //   location: '12 حسين جاد، النزهة، قسم النزهة، محافظة القاهرة',
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Expanded(
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
                                TrainingContainer(
                                  name: '${data.docs[i]['placeName']}',
                                  phone: '${data.docs[i]['phone']}',
                                  location: '${data.docs[i]['location']}',
                                  imageUrl: '${data.docs[i]['imageUrl']}',
                                  navigate: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => TrainReservationScreen(
                                            trainPass: '${data.docs[i]['password']}',
                                            trainName: '${data.docs[i]['placeName']}',
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
      //only admin can add training
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTraining())),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}
