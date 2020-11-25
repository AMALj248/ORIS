import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;
import 'main.dart';

List url_list = [];
List classes = [];
List num_of_stud =[];

// Class name Variable
var class_name;
// Button flag
bool button_pressed = false;
// Total Students Variable
var tot_stud;
var inp1;
class multiple_image extends StatefulWidget {

  @override
  _multiple_imageState createState() => _multiple_imageState();
}


class _multiple_imageState extends State<multiple_image> {
  List<Asset> images = List<Asset>();
  String _error;
  var first_click = false;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      //storing all the images
      resultList = await MultiImagePicker.pickImages(
        maxImages: 100,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      // changing first click to true
      first_click = true;
      if (error == null) _error = 'No Error Detected';
    });
  }

  void upload_selected() async {

    // Uploading User Data to Firebase

    try{

      // Creating a new Reference
      firebase_storage.Reference ref_txt =
      firebase_storage.FirebaseStorage.instance.ref('class_data/');
      String text = 'Hello World!';
      List<int> encoded = utf8.encode(text);
      Uint8List data = Uint8List.fromList(encoded);

      // Pushing the data
      await firebase_storage
          .FirebaseStorage.instance
          .ref('class_data/$data').putData(data);

      // Getting the data from Firebase
      Uint8List downloadedData =  await firebase_storage
          .FirebaseStorage.instance
          .ref('class_data/$data').getData();

      print("decoded data ${utf8.decode(downloadedData)}");
      Fluttertoast.showToast(msg: "Data Saved", backgroundColor: Colors.pink[400]);


    }

    on firebase_storage.FirebaseException catch(e)
    {
      print(e);
    }

    // Image Part


    print("Number of Images Selected ${images.length}");
    print("File Name ${images[0].name}");
    print("Number of Images Selected ${images.length}");

    // Initalizing Storage Bucket
    firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instanceFor(bucket: 'gs://omr-scanner-b2999.appspot.com');

    // Initialize Firebase
    await Firebase.initializeApp();
    print("Button Pressed");

    // Looping though List of Images
    url_list=[];
    for (var i=0;i<images.length;i++) {

      var img_pth = await FlutterAbsolutePath.getAbsolutePath(
          images[i].identifier);
      print("Path ${img_pth}");

      // Converting the Image_Path to File
      File file  = new File( img_pth);


      try {
        // Uploading to Firebase and taking a ref snapshot
        firebase_storage.TaskSnapshot snapshot = await firebase_storage
            .FirebaseStorage.instance
            .ref('uploads/${images[i].name}')
            .putFile(file);
        // print the progress
        print('Progress: ${(snapshot.totalBytes / snapshot.bytesTransferred) * 100} %');

        // Getting the Image URL
        var img_url = await firebase_storage.FirebaseStorage.instance.ref('uploads/${images[i].name}').getDownloadURL();
        print("Download URL for Image $i--> ${img_url.toString()}");
        // To Append to List .insert
        // To make List of strings/Bracket problem, .toString()
        url_list.insert(i, img_url.toString());
        Fluttertoast.showToast(msg: "Photo ${i+1} Uploaded", backgroundColor: Colors.pink[400]);

      }
      on firebase_storage.FirebaseException catch(e){
        print(e);
      }
    }
    print("Final Image URL List $url_list");
    // Showing User Toast Message
    setState(() {
      url_list;
    });

  }

  // Selecting the Images Button

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          backgroundColor: global_color,
          leading: IconButton(
            // Back Arrow
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Upload Images"),
          centerTitle: true,
        ),
        body: Column(
          // Placement of Buttons
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[


            // Total Students Box
            Container(
                color: Colors.orange ,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.07,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.1,
                padding: EdgeInsets.only(left: 5, top: 10),
                child: (
                    TextField(
                        controller: inp1,
                        obscureText: false,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Total Students ',
                            hintStyle: TextStyle(color: Colors.white))))

            ),

            // Upload Selected Button if Pick Images was clicked Once
            // Also Display the Class name Column
            if (first_click != true)
              GestureDetector(
                onTap:() {
                  setState(() {
                    button_pressed = true;
                  });
                },
                child: Container(
                    color: Colors.green,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.07,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.1,
                    padding: EdgeInsets.only(left: 5, top: 10),
                    child: (
                        TextField(
                            controller: class_name,
                            obscureText: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Classroom Name',
                                hintStyle: TextStyle(color: Colors.white))))
                ),
              ),


            // Giving Smart Buttons for Select & Upload
            first_click != true
                ? FloatingActionButton.extended(
              backgroundColor: global_color,
                label: Text("Pick images"), onPressed: loadAssets)
                : Expanded(child: buildGridView()),

            if (first_click == true)
              FloatingActionButton.extended(
                  backgroundColor: global_color,
                  label: Text('Upload Selected'), onPressed: upload_selected),



          ],
        ),
      ),
    );
  }
}