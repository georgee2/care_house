import 'package:flutter/material.dart';
import 'package:untitled/screens/adopt_screen.dart';
import 'package:untitled/screens/buy_screen.dart';
import 'package:untitled/screens/clinic_screen.dart';
import 'package:untitled/screens/marriage_screen.dart';
import 'package:untitled/screens/shop_screen.dart';
import 'package:untitled/screens/training_screen.dart';

import '../widgets/home_partition.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    HomePartition(
                      title: 'Shop',
                      imageUrl: 'assets/images/shop.jpg',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen())),
                    ),
                    HomePartition(
                      title: 'Clinic',
                      imageUrl: 'assets/images/3yadat.png',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClinicScreen())),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    HomePartition(
                      title: 'Adopt',
                      imageUrl: 'assets/images/tbny.jpg',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdoptScreen())),
                    ),
                    HomePartition(
                      title: 'Training',
                      imageUrl: 'assets/images/tdreb.jpg',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainingScreen())),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    HomePartition(
                      title: 'Buy & Sell',
                      imageUrl: 'assets/images/sell_buy.jpg',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BuyScreen())),
                    ),
                    HomePartition(
                      title: 'Marriage',
                      imageUrl: 'assets/images/wedding.jpg',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarriageScreen())),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
