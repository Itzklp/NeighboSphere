import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neighbosphere/CheckUser.dart';
import 'package:neighbosphere/RegisterSociety.dart';
import 'package:neighbosphere/SignUp.dart';
import 'SignIn.dart';
import 'SplashScreen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
      home: CheckUser()
  ));
}

