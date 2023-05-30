import 'package:flutter/material.dart';

class HomePartition extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Function() onPressed;
  const HomePartition({Key? key, required this.title, required this.imageUrl, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(imageUrl),),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[600]!,
              offset: const Offset(
                -3.0,
                3.0,
              ),
              blurRadius: 6.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.04,
          width: MediaQuery.of(context).size.width * 0.35,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.cyan.shade200,
          ),
          child: Text(title, style: const TextStyle(fontSize: 20),),
        ),
      ),
    );
  }
}
