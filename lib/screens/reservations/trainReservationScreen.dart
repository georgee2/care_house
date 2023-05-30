import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TrainReservationScreen extends StatefulWidget {
  final String trainPass;
  final String trainName;

  const TrainReservationScreen({Key? key, required this.trainPass, required this.trainName}) : super(key: key);

  @override
  State<TrainReservationScreen> createState() => _TrainReservationScreenState();
}

class _TrainReservationScreenState extends State<TrainReservationScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();

  DateTime? datePicked;
  String selectedTime = '';
  static const timeSlot = {
    '10:00-10:30',
    '10:30-11:00',
    '11:00-11:30',
    '11:30-12:00',
    '12:00-12:30',
    '12:30-13:00',
    '13:00-13:30',
  };
  bool taken = false;
  final formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  requestReservation() {
    if(selectedTime.isNotEmpty && datePicked != null && formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('training').doc(widget.trainPass).collection('requests').doc().set({
        'firstName' : firstName.text,
        'lastName' : lastName.text,
        'time' : DateTime.now(),
        'phone' : phone.text,
        'date' : '${datePicked!.day}-${datePicked!.month}-${datePicked!.year}/$selectedTime',
        'user' : user!.uid,
        'pass' : widget.trainPass,
        'placeNme' : widget.trainName,
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: firstName,
                        decoration: const InputDecoration(
                          labelText: 'First name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: lastName,
                        decoration: const InputDecoration(
                          labelText: 'Last name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.blue.shade900,),
                    ),
                    child: const Text(
                      'Select an appointment date',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime.now().add(const Duration(days: 30)),
                        onConfirm: (date) {
                          setState(() {
                            datePicked = date;
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    datePicked != null
                        ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child:
                        Text('${datePicked!.month}-${datePicked!.day}'))
                        : Container(),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    selectedTime != ''
                        ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(selectedTime))
                        : Container(),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: GridView.builder(
                    itemCount: timeSlot.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTime = timeSlot.elementAt(index);
                          });
                        },
                        child: Card(
                          color: selectedTime == timeSlot.elementAt(index) ? Colors.white10 : selectedTime == timeSlot.elementAt(index)? Colors.grey : Colors.white,
                          child: GridTile(
                            header: selectedTime == timeSlot.elementAt(index)
                                ? const Icon(Icons.check)
                                : const SizedBox(),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(timeSlot.elementAt(index)),
                                  const Text('Available'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // BookingCalendar(
                //   bookingService: mockBookingService,
                //   getBookingStream: getBookingStreamMock,
                //   uploadBooking: uploadBookingMock,
                //   convertStreamResultToDateTimeRanges: convertStreamResultFirebase,
                //   uploadingWidget: const CircularProgressIndicator(),
                // ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextButton(
                        onPressed: () => requestReservation(),
                        child: const Text(
                          'حجز',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
