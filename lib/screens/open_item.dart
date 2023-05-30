import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OpenItem extends StatelessWidget {
  final String imageUrl;
  final String type;
  final String name;
  final String age;
  final bool male;
  final bool married;
  final String phone;

  const OpenItem(
      {Key? key,
      required this.imageUrl,
      required this.type,
      required this.name,
      required this.age,
      required this.married,
      required this.phone, required this.male})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ModalScrollController.of(context),
      child: Container(
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: HexColor('#fff8e8'),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl),),
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
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: HexColor('#fff8e8'),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(type, style: TextStyle(fontSize: 25, color: HexColor('#5B0A09')),),
                    Icon(male? Icons.male : Icons.female),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18),),
                    Text(phone),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(married? 'married before' : 'first time', style: const TextStyle(fontSize: 18),),
                    Text('$age years', style: const TextStyle(fontSize: 15),),
                  ],
                ),
                const SizedBox(height: 5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
