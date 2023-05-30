import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/screens/aboutUs.dart';
import 'package:untitled/screens/reservations/adminReservation.dart';
import 'package:untitled/screens/reservations/user_reservations.dart';

import 'authentication/auth.dart';
import 'orders_screen.dart';
import 'requests/requestsDocScreen.dart';
import 'requests/requestsTrainScree.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late SharedPreferences preferences;
  String pass = '';
  bool doc = false;
  bool trainer = false;

  initializeSharedPreferences() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      doc = preferences.getBool('isDoc')!;
      trainer = preferences.getBool('isTrainer')!;
      pass = preferences.getString('pass')!;
    });
  }
  // checkValues() {
  //   print('$trainer  $doc');
  //   print(pass);
  // }

  @override
  void initState() {
    initializeSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Container(
          color: Colors.cyan.shade100,
          child: ListTileTheme(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 20, top: 25),
                  child: const Text('Welcome back', style: TextStyle(fontSize: 25),),
                ),
                //all orders for admin only
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
                  },
                  leading: const Icon(Icons.shopping_cart_outlined, color: Colors.black,),
                  title: const Text('Orders', style: TextStyle(fontSize: 20),),
                ),
                //all reservations for admin only
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminReservationsScreen()));
                  },
                  leading: const Icon(Icons.done_all, color: Colors.black,),
                  title: const Text('All Reservations', style: TextStyle(fontSize: 20),),
                ),
                //doctor requests
                doc? ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => RequestsDocScreen(docPass: pass,)));
                  },
                  leading: const Icon(Icons.request_quote_outlined, color: Colors.black,),
                  title: const Text('Doctor Requests', style: TextStyle(fontSize: 20),),
                ) : const SizedBox(),
                //trainer requests
                trainer? ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => RequestsTrainScreen(trainPass: pass,)));
                  },
                  leading: const Icon(Icons.request_quote_outlined, color: Colors.black,),
                  title: const Text('Trainer Requests', style: TextStyle(fontSize: 20),),
                ) : const SizedBox(),
                //user reservations
                user?.uid != null? ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const UserReservationsScreen()));
                  },
                  leading: const Icon(Icons.book_online, color: Colors.black,),
                  title: const Text('Reservations', style: TextStyle(fontSize: 20),),
                ) : const SizedBox(),
                Container(color: Colors.black, height: 1,),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUs()));
                  },
                  leading: const Icon(Icons.info_outline, color: Colors.black,),
                  title: const Text('About Us', style: TextStyle(fontSize: 20),),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.phone, color: Colors.black,),
                  title: const Text('Contact Us', style: TextStyle(fontSize: 20),),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.star_rate_outlined, color: Colors.black,),
                  title: const Text('Rate the app', style: TextStyle(fontSize: 20),),
                ),
                Container(color: Colors.black, height: 1,),
                ListTile(
                  onTap: () async{
                    //SharedPreferences preferences = await SharedPreferences.getInstance();
                    await FirebaseAuth.instance.signOut();
                    preferences.setBool('haveAcc', false);
                    preferences.setString('pass', '');
                    preferences.setBool('isDoc', false);
                    preferences.setBool('isTrainer', false);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Auth()));
                  },
                  leading: const Icon(Icons.logout, color: Colors.black,),
                  title: const Text('Log out', style: TextStyle(fontSize: 20),),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: const Text('Terms of Service | Privacy Policy', style: TextStyle(color: Colors.black),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
