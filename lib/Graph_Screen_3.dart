import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'Api_Call.dart';

// Parent Class
class Third_Screen extends StatefulWidget {
  @override
  createState() => _Third_Screen();
}

//Making the DataTable Rows Template
class Stud_data_2 {
  var qno;
  var Accuracy;
  var Difficulty;

  Stud_data_2({this.qno, this.Accuracy, this.Difficulty});

  // A function that returns Student Data for Rows
  static List<Stud_data_2> getData() {
    return <Stud_data_2>[
    // Looping through Values
    for(var i=0; i<length_data_pts; i++)
      Stud_data_2(qno: analysis_data['Ques_No'][i], Accuracy: analysis_data['Accuracy'][i], Difficulty:analysis_data['Difficulty'][i]),

    ];
  }
}

// Datable
SingleChildScrollView databody() {
  // Getting the DataRows
  var users = Stud_data_2.getData();
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,

    child: DataTable(
      // Spacing Between Columns
      columnSpacing: 30,

      // Columns
      columns: [
        DataColumn(
          label: Text("Q.No"),
          numeric: false,
          tooltip: 'Question Numbers',

        ),

        DataColumn(
          label: Text("Accuracy"),
          numeric: false,
          tooltip: 'Marks Scored',
        ),

        DataColumn(
          label: Text("Difficulty"),
          numeric: false,
          tooltip: 'Score Percentage',
        ),

      ],

      // Rows
      rows: users.map(
            (user) =>DataRow(
          cells: [
            // Cell 1
            DataCell(
                Text(user.qno.toString())
            ),

            // Cell 2
            DataCell(
              Text (user.Accuracy.toStringAsFixed(2)),
            ),

            // Cell 2
            DataCell(
                Text(user.Difficulty.toString())
            ),

          ],
        ),
        // To Iterate & Map very important
      ).toList(),
    ),

  );
}

// Main Screen Class
class _Third_Screen extends State<Third_Screen> {
  @override
  Widget build(BuildContext context) {

    // Testing The Scope of Analysis_Data
    print("Data in Page 3 ${analysis_data}");




    return Scaffold(
      //AppBar
      appBar: AppBar(
        title: Text("Paper Analysis"),
        backgroundColor: Colors.deepOrangeAccent,
      ),

      // Body as Row
      body: ListView.separated(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            // Main Container
            children: [
              // Class Average
              Divider(),
              // Making the Data Table
              databody(),
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
