import 'package:flutter/material.dart';

class RequestContainer extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String date;
  final Function() accept;
  final Function() decline;

  const RequestContainer({Key? key, required this.firstName, required this.lastName, required this.phone, required this.date, required this.accept, required this.decline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('$firstName $lastName', style: const TextStyle(fontSize: 20, color: Colors.white),),
          Text(phone, style: const TextStyle(fontSize: 20, color: Colors.white),),
          Text(date, style: const TextStyle(fontSize: 20, color: Colors.white),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                  ),
                  onPressed: decline,
                  child: const Text('Decline', style: TextStyle(fontSize: 15, color: Colors.white),),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: accept,
                  child: const Text('Accept', style: TextStyle(fontSize: 15, color: Colors.white),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
