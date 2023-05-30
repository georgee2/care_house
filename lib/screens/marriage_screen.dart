import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:untitled/screens/open_item.dart';
import 'package:untitled/upload_data/add_marriage.dart';
import 'package:untitled/widgets/marriage_container.dart';

class MarriageScreen extends StatefulWidget {
  const MarriageScreen({Key? key}) : super(key: key);

  @override
  State<MarriageScreen> createState() => _MarriageScreenState();
}

class _MarriageScreenState extends State<MarriageScreen> {
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> marriage = FirebaseFirestore.instance.collection('marriage').orderBy('time', descending: true).snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.deepOrange.shade50,
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search for a pet:',
              style: TextStyle(fontSize: 20),
            ),
            AnimSearchBar(
              rtl: true,
              width: MediaQuery.of(context).size.width * 0.6,
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: marriage,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.requireData.docs.isEmpty) {
                      return const Center(
                          child: Text('There is no pets for marriage for now'));
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (BuildContext c, int i) {
                        return Column(
                          children: [
                            Stack(
                              children: [
                                MarriageContainer(
                                  imageUrl: '${data.docs[i]['imageUrl']}',
                                  type: '${data.docs[i]['type']}',
                                  male: data.docs[i]['gender'] == 'Male'? true : false,
                                  age: '${data.docs[i]['age']}',
                                  name: '${data.docs[i]['owner']}',
                                  petName: '${data.docs[i]['petName']}',
                                  phone: '${data.docs[i]['phone']}',
                                  married: '${data.docs[i]['married']}' == 'Yes'? true:false,
                                  date: '${data.docs[i]['date']}',
                                  // navigate: () {
                                  //   showMaterialModalBottomSheet(
                                  //     context: context,
                                  //     builder: (context) => OpenItem(
                                  //       imageUrl: '${data.docs[i]['imageUrl']}',
                                  //       type: '${data.docs[i]['type']}',
                                  //       name: '${data.docs[i]['petName']}',
                                  //       male: data.docs[i]['gender'] == 'Male'? true : false,
                                  //       age: '${data.docs[i]['age']}',
                                  //       married: '${data.docs[i]['married']}' == 'Yes'? true:false,
                                  //       phone: '${data.docs[i]['phone']}',
                                  //     ),
                                  //   );
                                  // },
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
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMarriage())),
      backgroundColor: Colors.orangeAccent,
    ),
    );
  }
}
