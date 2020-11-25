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
  List Marks ;
  List Percentage;
  List Ned_Ques ;
  List DFA;
  List Ques_No;
  List Accuracy;
  List Difficulty;
  var Avg_Marks;
  var Top;
  var Weak;
  var Class_Accuracy;


  json_frmt_big(this.Enroll_id,this.Right_Answers, this.Marks, this.Percentage, this.Ned_Ques, this.DFA, this.Ques_No, this.Accuracy, this.Difficulty, this.Avg_Marks, this.Top, this.Weak, this.Class_Accuracy);

  json_frmt_big.fromJson (Map <String, dynamic> json ) :

        Enroll_id = json["Enroll_id"],
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
        Class_Accuracy = json["Class_Accuracy"];

}

// Api Async Function with flag
Future <void>  ans_get() async {

  print("API CALLED");
  print("Receiving Analytics");
  // API URL
  final String url_anaytics = 'https://915278655145.ngrok.io/analytics/';


  // Post Request
  try {
    final response_big = await http.post(url_anaytics);

    print("Response Code from Server ${response_big.statusCode}");
    //print("Response data ${response.body}");

    // Decoding data form JSON
    print("After Decoding ${jsonDecode(response_big.body)}");

    analysis_data =  jsonDecode(response_big.body);
    print("OMR VALUE = ${analysis_data['OMR_Efficiency']}");
    length_data_pts = analysis_data['Right_Answers'].length;

    //length_data_pts == null ? 0: length_data_pts;

    // Toast Messages
    Fluttertoast.showToast(msg: "Analytics Received", backgroundColor: Colors.lightGreen[400]);
    print("Length of data ${length_data_pts}");


  }
  catch(e)
  {
    // Remove this in production
    analysis_data=   { "Enroll_id": [1],
      "Right_Answers": [
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        0,
        0,
        0,
        0,
        0
      ],
      "Marks": [
        30
      ],
      "Percentage": [
        150.0
      ],
      "OMR_Error": [
        0
      ],
      "DFA": [
        0.0
      ],
      "Ques_No": [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
      ],
      "Accuracy": [
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        100.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0
      ],
      "Difficulty": [
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        3,
        3,
        3,
        3,
        3
      ],
      "Avg_Marks": 1.5,
      "Top": 1,
      "Weak": 1,
      "Class_Accuracy": 75.0,
      "OMR_Efficiency": 100.0
    };
    print("Error Default Value Assigned");
    throw e;

  }


}


