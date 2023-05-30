import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderContainer extends StatefulWidget {
  final String address;
  final List order;
  final String phone;
  final String totalPrice;

  const OrderContainer(
      {Key? key,
      required this.address,
      required this.order,
      required this.phone,
      required this.totalPrice})
      : super(key: key);

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            offset: const Offset(
              0.0,
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
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: [
                  InkWell(
                      onTap: () => launchUrl(Uri(
                        scheme: 'tel',
                        path: widget.phone,
                      )),
                      child: Text(
                        widget.phone,
                        style: const TextStyle(fontSize: 20, color: Colors.blue,),
                      )),
                  Text(
                    widget.address,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    widget.totalPrice,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              alignment: Alignment.bottomCenter,
              padding:
                  const EdgeInsets.only(right: 5, left: 5, bottom: 5, top: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.blueGrey.shade100,
              ),
              child: ListView.builder(
                itemCount: widget.order.length,
                itemBuilder: (BuildContext ctx, int i) {
                  return Text(
                    '${widget.order[i]}',
                    style: const TextStyle(fontSize: 18),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
