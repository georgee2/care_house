import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/main_page.dart';
import 'package:untitled/widgets/shop_container.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartList;

  const CartScreen({Key? key, required this.cartList}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int? totalPrice = 0;
  final formKey = GlobalKey<FormState>();

  // double points = 0.0;
  // User? user = FirebaseAuth.instance.currentUser;
  // FirebaseFirestore fireStore = FirebaseFirestore.instance;
  //
  // getLastPoints() async{
  //   var docSnapshot = await fireStore.collection('UsersData').doc(user!.uid).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     points = data?['points'];
  //   }
  // }

  calculateTotalPrice() {
    for(var element in widget.cartList) {
      totalPrice = int.parse(element['price']) + totalPrice!;
    }
  }

  @override
  void initState() {
    calculateTotalPrice();
    // getLastPoints();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController address = TextEditingController();
    TextEditingController phone = TextEditingController();
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Center(child: Text(user!.uid != null? '$points' : '', style: const TextStyle(fontSize: 20),)),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            widget.cartList.isEmpty
                ? const Center(
                    child: Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 20),
                  ))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total price: ', style: TextStyle(fontSize: 20),),
                  Text('$totalPrice', style: const TextStyle(fontSize: 20),),
                ],
              ),
            ),
            Padding(
                    padding: const EdgeInsets.all(15),
                    child: ListView.builder(
                      itemCount: widget.cartList.length,
                      itemBuilder: (ctx, i) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.22,
                                  child: ShopPartition(
                                    title: widget.cartList[i]['title'],
                                    imageUrl: widget.cartList[i]['imageUrl'],
                                    price: widget.cartList[i]['price'],
                                    desc: widget.cartList[i]['desc'],
                                  ),
                                ),
                                GestureDetector(
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(
                                    color: Colors.red, fontSize: 15),
                                  ),
                                  onTap: () {
                                    widget.cartList.removeAt(i);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Removed from your cart'),
                                      duration: Duration(milliseconds: 500),
                                    ));
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.black,
                              height: 1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
            widget.cartList.isNotEmpty
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: phone,
                                          validator: (value) {
                                            if (value!.isEmpty || value.length < 11 || value.length > 11) {
                                              return 'enter valid phone';
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                            labelText: 'Phone number',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                        TextField(
                                          controller: address,
                                          decoration: const InputDecoration(
                                            hintTextDirection: TextDirection.rtl,
                                            labelText: 'Address',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if(formKey.currentState!.validate()) {
                                        List<String> order = [];
                                        int count = 0;
                                        for (var element in widget.cartList) {
                                          count++;
                                          order.add('$count ${element['title']}: ${element['price']}');
                                        }
                                        FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc()
                                            .set({
                                          'totalPrice' : totalPrice,
                                          'time': DateTime.now(),
                                          'address': address.text,
                                          'phone': phone.text,
                                          'allOrder' : FieldValue.arrayUnion(order),
                                          'user' : user!.uid,
                                        });
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
                                      }
                                    },
                                    child: const Text('Order'),
                                  ),
                                ],
                              );
                          });
                        },
                        child: const Text('Order'),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
