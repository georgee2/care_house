import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/screens/main_page.dart';

class TrainerAuthScreen extends StatefulWidget {
  const TrainerAuthScreen({Key? key}) : super(key: key);

  @override
  State<TrainerAuthScreen> createState() => _TrainerAuthScreenState();
}

class _TrainerAuthScreenState extends State<TrainerAuthScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  login() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('haveAcc', true);
    preferences.setString('pass', passwordController.text);
    preferences.setBool('isTrainer', true);
    preferences.setBool('isDoc', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/register.png'),
                  fit: BoxFit.fill,
                )
            ),
          ),
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(right: 35, left: 35, top: MediaQuery.of(context).size.height * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome\nback', style: TextStyle(fontSize: 35, color: Colors.white),),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
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
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    MaterialButton(
                      child: const Text(
                        'Login', style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      textColor: Colors.white,
                      onPressed: () async{
                        if(formKey.currentState!.validate()){
                          CollectionReference users = FirebaseFirestore.instance.collection('training');
                          var doc = await users.doc(passwordController.text).get();
                          doc.exists? login()
                              : ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Wrong account'),
                          ));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}