import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class AddAdopt extends StatefulWidget {
  const AddAdopt({Key? key}) : super(key: key);

  @override
  State<AddAdopt> createState() => _AddAdoptState();
}

class _AddAdoptState extends State<AddAdopt> {
  String? gender;
  ImagePicker picker = ImagePicker();
  XFile? imageCamera;
  XFile? imageGallery;
  File? imagePicked;
  String imageUrl = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance.ref('adopt');

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

  uploadItem() async{
    if (formKey.currentState!.validate() &&
        imagePicked != null) {
      var snapshot = await storage.child('${DateTime.now()}').putFile(imagePicked!);
      imageUrl = await snapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('adopt').doc().set({
        'owner' : nameController.text,
        'petName' : petNameController.text,
        'imageUrl' : imageUrl,
        'age' : ageController.text,
        'time' : DateTime.now(),
        'type' : typeController.text,
        'phone' : phoneController.text,
        'gender' : gender,
        'date' : '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    petNameController.dispose();
    phoneController.dispose();
    typeController.dispose();
    ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_outlined),
        ),
        title: const Text("Add your pet"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter valid name';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Your name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                        controller: petNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter valid name';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Pet name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
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
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                        controller: typeController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter valid type';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Pet type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextFormField(
                        controller: ageController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter valid age';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Pet age',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Text('pet gender: ', style: TextStyle(fontSize: 17),),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: HexColor('2F409C'),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: DropdownButton(
                            value: gender,
                            elevation: 30,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                            hint: const Text(
                              'Male',
                              style: TextStyle(color: Colors.grey),
                            ),
                            dropdownColor: HexColor('2F409C'),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                gender = newValue;
                              });
                            },
                            underline: Container(
                              height: 1,
                              color: Colors.white,
                            ),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            items: ['Male', 'Female']
                                .map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                child: Text(
                                  e,
                                  style:
                                  const TextStyle(color: Colors.white),
                                ),
                                value: e,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
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
                      '+ upload pet photo' : '+ upload another photo',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () => showImagesDialog(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
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
                TextButton(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(15)),
                      color: HexColor('2F409C'),
                    ),
                    child: const Text(
                      'Post pet data',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () => uploadItem(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
