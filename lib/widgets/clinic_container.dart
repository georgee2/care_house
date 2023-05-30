import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicContainer extends StatelessWidget {
  final String name;
  final String phone;
  final Function() navigate;
  final String location;
  final String imageUrl;
  final String price;

  const ClinicContainer(
      {Key? key,
      required this.name,
      required this.phone,
      required this.navigate,
      required this.location, required this.imageUrl, required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: navigate,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.cover)),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.55,
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                      fontSize: 20,
                    )),
                const SizedBox(
                  height: 10,
                ),
                // InkWell(
                //   onTap: () => launchUrl(Uri(
                //     scheme: 'tel',
                //     path: phone,
                //   )),
                //   child: Text(
                //     phone,
                //     style: const TextStyle(fontSize: 15, color: Colors.blue),
                //   ),
                // ),
                InkWell(
                  onTap: () => launchUrl(Uri(
                    scheme: 'tel',
                    path: phone,
                  )),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 25,
                        color: Colors.blue,
                      ),
                      Flexible(
                          child: Text(
                        phone,
                        style: const TextStyle(fontSize: 15, color: Colors.blue),
                      )),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 25,
                    ),
                    Flexible(
                        child: Text(
                      location,
                      style: const TextStyle(fontSize: 15),
                    )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 25,
                    ),
                    Flexible(
                        child: Text(
                      price,
                      style: const TextStyle(fontSize: 15),
                    )),
                  ],
                ),
              ],
            ),
          ),
          // Row(
          //   children: const [
          //     Icon(
          //       Icons.star,
          //       size: 15,
          //     ),
          //     Icon(
          //       Icons.star,
          //       size: 15,
          //     ),
          //     Icon(
          //       Icons.star,
          //       size: 15,
          //     ),
          //     Icon(
          //       Icons.star,
          //       size: 15,
          //     ),
          //     Icon(
          //       Icons.star,
          //       size: 15,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
