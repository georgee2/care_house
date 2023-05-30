import 'package:flutter/material.dart';

class ShopPartition extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String price;
  final String desc;

  const ShopPartition(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.price,
      required this.desc,})
      : super(key: key);

  @override
  State<ShopPartition> createState() => _ShopPartitionState();
}

class _ShopPartitionState extends State<ShopPartition> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            offset: const Offset(
              -3.0,
              3.0,
            ),
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              //width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.imageUrl),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.only(right: 5, left: 5, bottom: 5, top: 5),
              //height: MediaQuery.of(context).size.height * 0.1,
              //width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.blueGrey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    '${widget.price} L.E',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
