import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
List url_list = [];


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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Giving Descional Buttons for Select & Upload
            first_click != true
                ? FloatingActionButton.extended(
                    label: Text("Pick images"), onPressed: loadAssets)
                : Expanded(child: buildGridView()),

            // Upload Selected Button if Pick Images was clicked Once
            if (first_click == true)
              FloatingActionButton.extended(
                  label: Text('Upload Selected'), onPressed: upload_selected),
          ],
        ),
      ),
    );
  }
}
