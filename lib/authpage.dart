import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/data_manager.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.title});

  final String title;

  @override
  State<AuthPage> createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  DataManager data = DataManager();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/minimanalogopurple.png"),
              width: 200,
              height: 200,
            ),
            Text("Welcome to MiniMana!", style: TextStyle(fontSize: 30, color: Colors.black),),
            TextField(
              controller: emailController,
              obscureText: false,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            
            //login and signup buttons
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Expanded(
                    child:
                    ElevatedButton(
                        onPressed: (){
                          print(emailController.text);
                          print(passwordController.text);
                          FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text
                          ).then((value) async {
                            print("Successful login.");
                            print(value.user!.uid);

                            //Load in info from cloud
                            data.loadFromFirebase();
                            data.saveAll();

                            //Show Loading alert
                            showDialog<String>(
                              context: context,
                              builder:
                                  (BuildContext context) => AlertDialog(
                                title: const Text('Login Successful!'),
                                content: const Text('Please wait while we retrieve your projects.'),
                                actions: <Widget>[
                                  // TextButton(
                                  //   onPressed: () => Navigator.pop(context, 'OK'),
                                  //   child: const Text('OK'),
                                  // ),
                                ],
                              ),
                            );

                            //go to calendar page after login
                            Timer(const Duration(seconds: 5), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CalendarPage(title: "Calendar"))));

                          }).catchError((error) {
                            print("ERROR HERE: ");
                            print(error.toString());
                            print("Login unsuccessful");

                            if(error.toString().contains("invalid-credential")){
                              showDialog<String>(
                                context: context,
                                builder:
                                    (BuildContext context) => AlertDialog(
                                  title: const Text('Invalid Email or Password'),
                                  content: const Text('The email address or password you entered was invalid. Please try again.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (error.toString().contains("invalid-email")){
                              showDialog<String>(
                                context: context,
                                builder:
                                    (BuildContext context) => AlertDialog(
                                  title: const Text('Invalid Email'),
                                  content: const Text('The email address you entered is invalid. Please try again.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }


                          });
                        },
                        child: Text("Login")
                    ),
                ),
                //Signup button
                Expanded(
                  child:
                  ElevatedButton(
                      onPressed: () async {
                        //Create user with stated credentials

                        Future<UserCredential> ucFuture = FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text
                        ).then((value) async {
                          print("Successfully signed up the user.");
                          print(value.user!.uid);

                          //Login with new credentials
                          FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text
                          );



                          //Load in info from cloud
                          await data.loadFromFirebase();
                          data.saveAll();

                          //go to calendar page after login
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CalendarPage(title: "Calendar")));
                        }).catchError((error){
                          //print("Failed to sign up user.");
                          //print(error);
                          print("ERROR HERE: ");
                          print(error);

                          if(error.toString().contains("email-already-in-use")){
                            showDialog<String>(
                              context: context,
                              builder:
                                  (BuildContext context) => AlertDialog(
                                title: const Text('Email Already In Use'),
                                content: const Text('The email address you entered is already in use. Please try again.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else if (error.toString().contains("invalid-email")){
                            showDialog<String>(
                              context: context,
                              builder:
                                  (BuildContext context) => AlertDialog(
                                title: const Text('Invalid Email'),
                                content: const Text('The email address you entered is invalid. Please try again.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }



                        }) as Future<UserCredential>;
                      },
                      child: Text("Signup")
                  ),
                ),
              ],
            ),
            
            //Forgot Password Button
            TextButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder:
                        (BuildContext context) => AlertDialog(
                      title: const Text('Password Reset'),
                      content: const Text('Please enter your email, we will send you an email to reset your password.'),
                      actions: <Widget>[
                        TextField(
                          controller: emailController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                print(emailController.text);
                                try{
                                  FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                                } catch (FirebaseAuthException){
                                  print("Error in sending email");
                                  print(FirebaseAuthException);
                                }
                                //Navigator.pop(context, 'OK');
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        ),

                      ],
                    ),
                  );
                },
                child: Text("Forgot Password?")
            )

          ],
        ),
      ),
    );
  }
}
