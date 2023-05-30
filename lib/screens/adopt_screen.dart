import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled/upload_data/add_adopt.dart';
import 'package:untitled/widgets/adopt_container.dart';

class AdoptScreen extends StatefulWidget {
  const AdoptScreen({Key? key}) : super(key: key);

  @override
  State<AdoptScreen> createState() => _AdoptScreenState();
}

class _AdoptScreenState extends State<AdoptScreen> {
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> adopt = FirebaseFirestore.instance.collection('adopt').orderBy('time', descending: true).snapshots();

    return Scaffold(
      body: Container(
        color: HexColor('#fff8e8'),
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
            Row(
              children: [
                const Text(
                  'Search for a pet:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  width: 10,
                ),
                AnimSearchBar(
                  //rtl: true,
                  width: MediaQuery.of(context).size.width * 0.4,
                  textController: textController,
                  onSuffixTap: () {
                    setState(() {
                      textController.clear();
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: adopt,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.requireData.docs.isEmpty) {
                      return const Center(
                          child: Text('There is no pets for adopt for now'));
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (BuildContext c, int i) {
                        return Column(
                          children: [
                            Stack(
                              children: [
                                AdoptContainer(
                                  imageUrl: '${data.docs[i]['imageUrl']}',
                                  type: '${data.docs[i]['type']}',
                                  male: data.docs[i]['gender'] == 'Male'? true : false,
                                  age: '${data.docs[i]['age']}',
                                  name: '${data.docs[i]['owner']}',
                                  petName: '${data.docs[i]['petName']}',
                                  phone: '${data.docs[i]['phone']}',
                                  date: '${data.docs[i]['date']}',
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
                            const SizedBox(height: 10,),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddAdopt())),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}
