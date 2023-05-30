import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'home_screen.dart';
import 'menu_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _drawerController = AdvancedDrawerController();
    bool isOpen = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade100,
        title: const Center(
            child: Text(
          'Care House',
          style: TextStyle(fontSize: 25, color: Colors.black),
        )),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            if (isOpen) {
              _drawerController.hideDrawer();
              isOpen = false;
            } else {
              _drawerController.showDrawer();
              isOpen = true;
            }
          },
        ),
      ),
      body: AdvancedDrawer(
        controller: _drawerController,
        child: const HomeScreen(),
        drawer: const MenuScreen(),
        backdropColor: Colors.cyan.shade100,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
