import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/screens/main_page.dart';

class UserAuthScreen extends StatefulWidget {
  const UserAuthScreen({Key? key}) : super(key: key);

  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  final formKey = GlobalKey<FormState>();
  bool signIn = true;
  bool doctor = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  logIn() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool('haveAcc', false);
      preferences.setString('pass', '');
      preferences.setBool('isDoc', false);
      preferences.setBool('isTrainer', false);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => const MainPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
          content:
          Text('No user found for that email.'),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
          content: Text(
              'Wrong password provided for that user.'),
        ));
      }
    }
  }

  signUp() async{
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // store email in FirebaseFirestore
      await FirebaseFirestore.instance
          .collection('UsersData')
          .doc(userCredential.user!.uid)
          .set({'email': userCredential.user!.email});
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool('haveAcc', false);
      preferences.setString('pass', '');
      preferences.setBool('isDoc', false);
      preferences.setBool('isTrainer', false);
      //navigate to home after account created
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const MainPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
          content: Text(
              'The password provided is too weak.'),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
          content: Text(
              'The account already exists for that email.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Text(
            e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(signIn? 'assets/images/login.png' : 'assets/images/register.png'),
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
                    Text(signIn? 'Welcome\nback' : 'Create\naccount', style: const TextStyle(fontSize: 35, color: Colors.white),),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 15 || value.contains(' ')) {
                          return 'enter valid e-mail';
                        } else {
                          return null;
                        }
                      },
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
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
                      child: Text(
                        signIn ? 'Login' : 'SignUp', style: TextStyle(color: signIn? Colors.blue : Colors.black, fontSize: 25),
                      ),
                      textColor: Colors.white,
                      onPressed: () async{
                        if(formKey.currentState!.validate()){
                          signIn ? logIn() : signUp();
                        }
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          signIn
                              ? 'create new account?   '
                              : 'already have account?   ',
                          style: const TextStyle(fontSize: 20),
                        ),
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              signIn = !signIn;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              signIn ? 'SignUp' : 'Login', style: TextStyle(fontSize: 20, color: signIn? Colors.blue : Colors.black,),),
                          ),
                        ),
                      ],
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