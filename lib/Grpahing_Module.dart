import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_full_app/Api_Call.dart';
import 'Api_Call.dart';
import 'Graph_Screen_1.dart';
import 'Graph_Screen_2.dart';
import 'Graph_Screen_3.dart';




// Parent Class
class Graph_Main_Screen extends StatefulWidget {

  @override
  createState() => _Graph_ScreenState();


}

// Main Screen Class
class _Graph_ScreenState extends State<Graph_Main_Screen> {

  // For Swiping between Pages
  PageController _controller = PageController(initialPage: 0);
  @override

 Widget build(BuildContext context) {


     return PageView(
       controller: _controller,
       children: [
         Grapher(),
         Second_Screen(),
         Third_Screen(),
       ],
     );
  }
}
