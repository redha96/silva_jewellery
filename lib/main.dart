// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:silva_jewellery/screens%20of%20owner/productslist.dart';
import 'screens of owner/addItemPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("there is no connection to internet");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          Widget testWidget = new MediaQuery(
              data: new MediaQueryData(),
              child: new MaterialApp(
                home: new ProductsList(),
                //builder: EasyLoading.init(),
              ));

          return testWidget;
        }else if(snapshot.connectionState == ConnectionState.waiting)
        return Container(child: Text("loading", textDirection: TextDirection.ltr));
        else 
        //if(snapshot.connectionState == ConnectionState.none)
        return Container(child: Text("error", textDirection: TextDirection.ltr));

        // Otherwise, show something whilst waiting for initialization to complete
        // Widget testWidget = new MediaQuery(
        //     data: new MediaQueryData(),
        //     child: new MaterialApp(
        //         builder: EasyLoading.init()));

        // return testWidget;
      },
    );
  }
}
