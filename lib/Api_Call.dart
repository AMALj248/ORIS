import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'Ans_Key_Screen.dart';

// Making a Global data to pass on
var analysis_data;
var length_data_pts;

// For the JSON Format Encoding
class json_frmt_big {
  List Enroll_id;
  List Right_Answers;
  List Marks;
  List Percentage;
  List Ned_Ques;
  List DFA;
  List Ques_No;
  List Accuracy;
  List Difficulty;
  var Avg_Marks;
  var Top;
  var Weak;
  var Class_Accuracy;
  var stud_response;
  List answ_key;

  json_frmt_big(
      this.Enroll_id,
      this.Right_Answers,
      this.Marks,
      this.Percentage,
      this.Ned_Ques,
      this.DFA,
      this.Ques_No,
      this.Accuracy,
      this.Difficulty,
      this.Avg_Marks,
      this.Top,
      this.Weak,
      this.Class_Accuracy,
      this.stud_response,
      this.answ_key);

  json_frmt_big.fromJson(Map<String, dynamic> json)
      : Enroll_id = json["Enroll_id"],
        Right_Answers = json["Right_Answers"],
        Marks = json["Marks"],
        Percentage = json["Percentage"],
        Ned_Ques = json["Ned_Ques"],
        DFA = json["DFA"],
        Ques_No = json["Ques_No"],
        Accuracy = json["Accuracy"],
        Difficulty = json["Difficulty"],
        Avg_Marks = json["Avg_Marks"],
        Top = json["Top"],
        Weak = json["Weak"],
        Class_Accuracy = json["Class_Accuracy"],
        stud_response = json["stud_response"],
        answ_key = json['answ_key'];

}

// Api Async Function with flag
Future<void> ans_get() async {
  print("API CALLED");
  print("Receiving Analytics");
  // API URL
  final String url_anaytics = 'https://coderino.team/analytics/';

  // Post Request
  try {
    final response_big = await http.post(url_anaytics);

    print("Response Code from Server ${response_big.statusCode}");
    //print("Response data ${response.body}");

    // Decoding data form JSON
    print("After Decoding ${jsonDecode(response_big.body)}");

    analysis_data = jsonDecode(response_big.body);
    print("OMR VALUE = ${analysis_data['OMR_Efficiency']}");
    length_data_pts = analysis_data['Right_Answers'].length;

    //length_data_pts == null ? 0: length_data_pts;

    // Toast Messages
    Fluttertoast.showToast(
        msg: "Analytics Received", backgroundColor: Colors.lightGreen[400]);
    print("Length of data ${length_data_pts}");
    print("User Anw ${analysis_data['answ_key']}");
  } catch (e) {
    Text('Please Upload an Answer Key');
    throw e;
  }
}
