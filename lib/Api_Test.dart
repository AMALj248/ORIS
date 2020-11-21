import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


// Main Class
class Uploader extends StatefulWidget {
  final File file;
  @override

  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploderState();
}

class _UploderState extends  State<Uploader>  {


  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instanceFor(bucket: 'gs://omr-scanner-b2999.appspot.com');

  // Asynchronous Function for Image Selections
  Future<void> img_upload() async{



    await Firebase.initializeApp();
    print("Button Pressed");

    // Picking the Image
    for (var i=0;i<2;i++) {
      File _image = await ImagePicker.pickImage(source: ImageSource.gallery ,imageQuality: 100);

      // Uploading the Images to Frebase

      {
        await firebase_storage.FirebaseStorage.instance
            .ref('uploads/${i}.jpg')
            .putFile(_image);

        // Getting the Image URl
        var img_url = await firebase_storage.FirebaseStorage.instance.ref('uploads/${i}.jpg').getDownloadURL();

       print("Download URL ${img_url.toString()}");
      }

    }

  }



  @override
  Widget build(BuildContext context) {
    //Parent Scaffold
    return Scaffold(
      //AppBar
      appBar: AppBar(
        title: Text("API TEST"),
      ),

      //  Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: img_upload,
        label: Text('Test'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


    );

  }
}

