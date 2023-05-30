import 'package:flutter/material.dart';
import 'package:untitled/screens/authentication/user_login.dart';

import 'doctor_login.dart';
import 'trainer_login.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserAuthScreen())),
              child: const Text('Sign in as user', style: TextStyle(fontSize: 25),),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorAuthScreen())),
              child: const Text('Sign in as doctor', style: TextStyle(fontSize: 25),),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainerAuthScreen())),
              child: const Text('Sign in as trainer', style: TextStyle(fontSize: 25),),
            ),
          ],
        ),
      );
  }
}
