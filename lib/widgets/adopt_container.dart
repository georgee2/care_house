import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class AdoptContainer extends StatelessWidget {
  final String imageUrl;
  final String type;
  final String name;
  final String petName;
  final String age;
  final bool male;
  final String phone;
  final String date;

  const AdoptContainer(
      {Key? key,
      required this.imageUrl,
      required this.type,
      required this.name,
      required this.age,
      required this.phone,
      required this.male,
      required this.petName,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.cover)),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.55,
            padding: const EdgeInsets.only(left: 10.0, top: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type,
                      style:
                          TextStyle(fontSize: 25, color: HexColor('#5B0A09')),
                    ),
                    Icon(male ? Icons.male : Icons.female),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      petName,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      '$age years',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => launchUrl(Uri(
                        scheme: 'tel',
                        path: phone,
                      )),
                      child: Text(phone, style: const TextStyle(color: Colors.blue),),
                    ),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
