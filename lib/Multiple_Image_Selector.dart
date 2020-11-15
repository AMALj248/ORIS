import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';



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
