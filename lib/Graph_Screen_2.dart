import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_full_app/Api_Call.dart';
import 'Api_Call.dart';



// Parent Class
class Second_Screen extends StatefulWidget {
  @override
  createState() => _Second_Screen();
}

//Making the DataTable Rows Template
class Stud_data {
  var id;
  var marks;
  var Score_perc;
  var mistake_data;
  var devi_scr;

  Stud_data({this.id, this.marks, this.Score_perc, this.mistake_data, this.devi_scr });

  // A function that returns Student Data for Rows
static List<Stud_data> getData() {
  return <Stud_data>[
    // Looping through Values
    for(var i=0; i<analysis_data['Enroll_id'].length; i++)
    Stud_data(id: analysis_data['Enroll_id'][i], marks:  analysis_data['Marks'][i], Score_perc: analysis_data['Percentage'][i], mistake_data: analysis_data['Ned_Ques'][i], devi_scr: analysis_data['DFA'][i] ),

  ];
}
}

// Datable
SingleChildScrollView databody() {

  // Testing The Scope of Analysis_Data
  print("Data in Page 2 ${analysis_data}");
  print("Length ${analysis_data['Enroll_id'].length}");

  // Getting the DataRows
  var users = Stud_data.getData();
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,

      child: DataTable(
        // Spacing Between Columns
        columnSpacing: 30,

        // Columns
        columns: [
          DataColumn(
            label: Text("ID"),
            numeric: false,
            tooltip: 'This is column 1',

          ),

          DataColumn(
            label: Text("Marks"),
            numeric: false,
            tooltip: 'Marks Scored',
          ),

          DataColumn(
            label: Text("%"),
            numeric: false,
            tooltip: 'Score Percentage',
          ),

          DataColumn(
            label: Text("-ve Attempt"),
            numeric: false,
            tooltip: 'OMR Filling Error Made',
          ),

          DataColumn(
            label: Text("+/- Avg"),
            numeric: true,
            tooltip: 'Deviation from Average Marks',
          ),
        ],

        // Rows
        rows: users.map(
            (user) =>DataRow(
               cells: [
                 // Cell 1
                 DataCell(
                   Text(user.id.toString())
                 ),

                 // Cell 1
                 DataCell(
                    Text (user.marks.toString()),
                 ),

                 // Cell 1
                 DataCell(
                     Text(user.Score_perc.toString())
                 ),

                 // Cell 1
                 DataCell(
                     Text(user.mistake_data.toString())
                 ),

                 // Cell 1
                 DataCell(
                     Text(user.devi_scr.toString())
                 ),

               ],
        ),
          // To Iterate & Map very important
        ).toList(),
       ),

  );
}

// Main Screen Class
class _Second_Screen extends State<Second_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: AppBar(
        title: Text("Student Analysis"),
        backgroundColor: Colors.lightGreen,
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
