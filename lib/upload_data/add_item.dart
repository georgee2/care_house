import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String type = 'Food';
  ImagePicker picker = ImagePicker();
  XFile? imageCamera;
  XFile? imageGallery;
  File? imagePicked;
  var imageUrl = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance.ref('shop');

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
      var snapshot = await storage.child(nameController.text).putFile(imagePicked!);
      imageUrl = await snapshot.ref.getDownloadURL();
      type == 'Accessories' ?
      FirebaseFirestore.instance.collection('shop').doc('Accessories').collection('products').doc().set({
        'item' : nameController.text,
        'description' : descController.text,
        'imageUrl' : imageUrl,
        'price' : priceController.text,
        'time' : DateTime.now(),
      }) : FirebaseFirestore.instance.collection('shop').doc('Food').collection('products').doc().set({
        'item' : nameController.text,
        'description' : descController.text,
        'imageUrl' : imageUrl,
        'price' : priceController.text,
        'time' : DateTime.now(),
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_outlined),
        ),
        title: const Text("Add Item"),
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
                          labelText: 'Item name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                        controller: priceController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter valid price';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Item price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  //maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Item description',
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
                      '+ upload item photo' : '+ upload another photo',
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Type of product: ', style: TextStyle(fontSize: 17),),
                    Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: HexColor('2F409C'),
                      ),
                      child: DropdownButton(
                        value: type,
                        elevation: 30,
                        dropdownColor: HexColor('2F409C'),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(15)),
                        hint: const Text(
                          'Food',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            type = newValue as String;
                          });
                        },
                        underline: Container(
                          height: 0,
                          color: Colors.black,
                        ),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        items: ['Food', 'Accessories']
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
                      'Upload item',
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
