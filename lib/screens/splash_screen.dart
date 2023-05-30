import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/screens/authentication/auth.dart';
import 'package:untitled/screens/main_page.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;
  bool haveAcc = false;
  User? user = FirebaseAuth.instance.currentUser;

  checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    haveAcc = preferences.getBool('haveAcc')!;
  }

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/videos/splashVideo.mp4');
    _controller?.initialize();
    //_controller?.setLooping(true);
    _controller?.play();
    // _controller?.setVolume(0.0);
    // _controller?.play();
    checkLogin();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return haveAcc
            ? const MainPage()
            : user == null
                ? const Auth()
                : const MainPage();
      }));
    });

    return Scaffold(
      body: Container(
        color: Colors.lightBlue.shade50,
        child: Center(
          child: AspectRatio(
            child: VideoPlayer(_controller!),
            aspectRatio: _controller!.value.aspectRatio,
          ),
        ),
      ),
    );
  }
}
