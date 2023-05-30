import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/cart_screen.dart';
import 'package:untitled/upload_data/add_item.dart';
import 'package:untitled/widgets/shop_container.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    final Stream<QuerySnapshot> accessProducts = FirebaseFirestore.instance
        .collection('shop')
        .doc('Accessories')
        .collection('products')
        .orderBy('time', descending: true)
        .snapshots();
    final Stream<QuerySnapshot> foodProducts = FirebaseFirestore.instance
        .collection('shop')
        .doc('Food')
        .collection('products')
        .orderBy('time', descending: true)
        .snapshots();

    List<Map<String, dynamic>> cartList = [];

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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CartScreen(cartList: cartList))),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Food:',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  // Text(
                  //   'show all',
                  //   style: TextStyle(fontSize: 18, color: Colors.blue),
                  // ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: StreamBuilder<QuerySnapshot>(
                  stream: foodProducts,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.requireData.docs.isEmpty) {
                      return const Center(
                          child: Text('There is no products for now'));
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.docs.length,
                      itemBuilder: (BuildContext c, int i) {
                        return SingleChildScrollView(
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: ShopPartition(
                                          desc:
                                              '${data.docs[i]['description']}',
                                          price: '${data.docs[i]['price']}',
                                          imageUrl:
                                              '${data.docs[i]['imageUrl']}',
                                          title: '${data.docs[i]['item']}',
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade900,
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Add to cart',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                              Container(
                                                alignment: Alignment.topRight,
                                                child: const Icon(
                                                    Icons.shopping_cart_rounded,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          cartList.add({
                                            'desc':
                                                '${data.docs[i]['description']}',
                                            'price': '${data.docs[i]['price']}',
                                            'imageUrl':
                                                '${data.docs[i]['imageUrl']}',
                                            'title': '${data.docs[i]['item']}',
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text('Added to your cart'),
                                            duration:
                                                Duration(milliseconds: 500),
                                          ));
                                        },
                                      ),
                                    ],
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
                                width: 15,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Accessories:',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  // Text(
                  //   'show all',
                  //   style: TextStyle(fontSize: 18, color: Colors.blue),
                  // ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                child: StreamBuilder<QuerySnapshot>(
                  stream: accessProducts,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.requireData.docs.isEmpty) {
                      return const Center(
                          child: Text('There is no products for now'));
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.docs.length,
                      itemBuilder: (BuildContext c, int i) {
                        return Row(
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width:
                                      MediaQuery.of(context).size.width * 0.4,
                                      child: ShopPartition(
                                        desc: '${data.docs[i]['description']}',
                                        price: '${data.docs[i]['price']}',
                                        imageUrl: '${data.docs[i]['imageUrl']}',
                                        title: '${data.docs[i]['item']}',
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade900,
                                          border: Border.all(color: Colors.black),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Add to cart',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: const Icon(
                                                  Icons.shopping_cart_rounded,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        cartList.add({
                                          'desc': '${data.docs[i]['description']}',
                                          'price': '${data.docs[i]['price']}',
                                          'imageUrl': '${data.docs[i]['imageUrl']}',
                                          'title': '${data.docs[i]['item']}',
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('Added to your cart'),
                                          duration: Duration(milliseconds: 500),
                                        ));
                                      },
                                    ),
                                  ],
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
                              width: 15,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddItem())),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}
