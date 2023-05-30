import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class AddTraining extends StatefulWidget {
  const AddTraining({Key? key}) : super(key: key);

  @override
  State<AddTraining> createState() => _AddTrainingState();
}

class _AddTrainingState extends State<AddTraining> {
  ImagePicker picker = ImagePicker();
  XFile? imageCamera;
  XFile? imageGallery;
  File? imagePicked;
  String imageUrl = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance.ref('training');

  getImageFromCamera() async {
    imageCamera = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      imagePicked = File(imageCamera!.path);
    });
    Navigator.pop(context);
  }

  getImageFromGallery() async {
    imageGallery = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePicked = File(imageGallery!.path);
    });
    Navigator.pop(context);
  }

  showImagesDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Choose image from:',
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () => getImageFromGallery(),
                child: const Text('Pick from gallery'),
              ),
              TextButton(
                onPressed: () => getImageFromCamera(),
                child: const Text('Pick from camera'),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    locationController.dispose();
    descController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_outlined),
        ),
        title: const Text("Add place"),
        actions: [
          IconButton(
            onPressed: () async{
              if (formKey.currentState!.validate() &&
                  imagePicked != null) {
                var snapshot = await storage.child('${DateTime.now()}').putFile(imagePicked!);
                imageUrl = await snapshot.ref.getDownloadURL();
                await firestore.collection('training').doc(passwordController.text).set({
                  'placeName' : nameController.text,
                  'location' : locationController.text,
                  'description' : descController.text,
                  'imageUrl' : imageUrl,
                  'phone' : phoneController.text,
                  'password' : passwordController.text,
                  'time' : DateTime.now(),
                  'price' : priceController.text,
                });
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.cloud_upload_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter valid name';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Place name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter valid password';
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'account password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextFormField(
                  controller: locationController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter valid location';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextFormField(
                  controller: phoneController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 11) {
                      return 'enter valid phone';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextFormField(
                  controller: descController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter valid description';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Place description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextFormField(
                  controller: priceController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter valid price';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextButton(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(15)),
                      color: HexColor('2F409C'),
                    ),
                    child: Text(
                      imagePicked == null?
                      '+ upload logo' : '+ upload another photo',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () => showImagesDialog(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                imagePicked == null? const SizedBox() : Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(25)),
                      image: DecorationImage(
                        image: FileImage(imagePicked!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
