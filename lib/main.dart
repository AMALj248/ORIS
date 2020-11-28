import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'Ans_Key_Screen.dart';
import 'Multiple_Image_Selector.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Grpahing_Module.dart';
import 'package:firebase_core/firebase_core.dart';

// For dark mode
bool dark_bool = true;
var global_color;

//the main function
void main() => runApp(MyApp());

//My App Prelim Function
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
    //MaterialApp
  }
}

//Defining the HomePage
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

//Defining the Home Page
class _HomePageState extends State<HomePage> {
// Accessing the image
  //State variable

  Future getImage(ImageSource source) async {
    //accessing the image
    // accessing imageQuality 1
    File _image = await ImagePicker.pickImage(source: source, imageQuality: 98);
    //checking the null image
    if ( _image != null) {
      //Cropping image Window
      File cropped = await ImageCropper.cropImage(
          sourcePath: _image.path,
          maxHeight: 1080,
          maxWidth:  1920,
          compressFormat: ImageCompressFormat.png,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.white,
            toolbarTitle: 'Cropping',
            statusBarColor: Colors.white70,
            toolbarWidgetColor: Colors.lightBlueAccent,
          ));

      await GallerySaver.saveImage(cropped.path);
      // Showing User Toast Message
      Fluttertoast.showToast(msg: "Photo Saved");

    }
  }
  @override

  Widget build(BuildContext context) {

    // Switch Theme Function and colors Selection
    void switch_theme(){
      if(dark_bool == true)
        setState(() {
          dark_bool = false;
          global_color = Colors.black;
        });
      else
        setState(() {
          dark_bool = true;
          global_color = Colors.lightBlueAccent;
        });
      print("Theme Changed to $dark_bool");
    }



    future: Firebase.initializeApp();
    return Scaffold(
      //Making a AppBar
      appBar: AppBar(
        backgroundColor: global_color,
        title: Text(''),
        leading: GestureDetector(
          onTap: switch_theme,
          child: Icon( (dark_bool == true ) ? Icons.wb_sunny : Icons.wb_sunny_outlined),
        ),

      ),
      //Background Color
      backgroundColor: Colors.white,
      // For Scrollable Content
      body: ListView.separated(
        //For Even Spacing of Rows
        padding: const EdgeInsets.all(32),
        //How many copies of Tiles
        itemCount: 1,
        //required constructor
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //For Divider
              Divider(),
              //For Images Upload
              GestureDetector(
                onTap: () {
                  //Rerouting to Ans_Key_Screen file
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Pushing to Stack Builder
                      builder: (context) => multiple_image(),
                    ),
                  );
                },
                child: Container(
                  //Area of the Box
                  height: 185,
                  width: 185,
                  alignment: Alignment.bottomLeft,
                  //Inserting the logo
                  decoration: BoxDecoration(
                    //Shaping thr Box
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    //shadow for the box
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                    image: DecorationImage(
                      image: AssetImage('images/image_upload.png'),
                    ),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 55, top: 0, right: 0, bottom: 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Upload',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //For Divider
              Divider(),
              //Container#2
              //making a clickable button
              GestureDetector(
                onTap: () {
                  //Accessing Image from Camera
                  getImage(ImageSource.camera);

                },
                child: Container(
                  //Area of the Box
                  height: 185,
                  width: 185,
                  //Text Alignment
                  alignment: Alignment.bottomLeft,

                  //Image for Logo
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    //shadow for the box
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],

                    image:
                    DecorationImage(image: AssetImage('images/camera.png')),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 55, top: 0, right: 0, bottom: 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Scanner',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  //Making the button Pressable
                ),
              ),

              //For Divider
              Divider(),
              //Container#3
              //navigating to Answer Key Screen
              GestureDetector(
                onTap: () {
                  //Rerouting to Ans_Key_Screen file
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Pushing to Stack Builder
                      builder: (context) => firstscreen(),
                    ),
                  );
                },
                child: Container(
                  //Area of the Box
                  height: 185,
                  width: 185,
                  //Text Alignment
                  alignment: Alignment.bottomLeft,

                  //Image for Logo
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    //shadow for the box
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],

                    image: DecorationImage(
                        image: AssetImage('images/answer_key.png')),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 45, top: 0, right: 0, bottom: 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Answer Key',
                          style: TextStyle(fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //Container#4
              Divider(),
              GestureDetector(
                onTap: () {

                  //Rerouting to Ans_Key_Screen file
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Pushing to Stack Builder
                      builder: (context) => Graph_Main_Screen(),
                    ),
                  );
                },
                child: Container(
                  //Area of the Box
                  height: 185,
                  width: 185,
                  //Text Alignment
                  alignment: Alignment.bottomLeft,

                  //Image for Logo
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    //shadow for the box
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],

                    image: DecorationImage(
                        image: AssetImage('images/Analytics.png')),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 55, top: 0, right: 0, bottom: 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Analytics',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        // For spacing between widgets
        separatorBuilder: (BuildContext context, int index) =>
        const Divider(height: 15, thickness: 5, indent: 15, endIndent: 15),
      ),
    );
  }
}
