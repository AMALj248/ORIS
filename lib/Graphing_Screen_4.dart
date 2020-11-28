import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'Api_Call.dart';
import 'main.dart';


// Student ID
var cur_stud_id=0;
// Parent Class
class Fourth_Screen extends StatefulWidget {
  @override
  createState() => _Fourth_Screen();
}

//Making the DataTable Rows Template
class Stud_data_2 {
  var qno;
  var Marked;
  var act_ans;


  Stud_data_2({this.qno, this.Marked, this.act_ans});

  // A function that returns Student Data for Rows
  static List<Stud_data_2> getData() {
    return <Stud_data_2>[
      // Looping through Values for Student Responses

        for(var j=1;j<=analysis_data['answ'][cur_stud_id].length;j++)
              (
            Stud_data_2(qno: j, Marked: analysis_data['answ'][cur_stud_id]['$j'], act_ans: analysis_data['answ_key'][0]['$j'])
                    )
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
          tooltip: 'Question Number',

        ),

        DataColumn(
          label: Text("Marked"),
          numeric: false,
          tooltip: 'Student Selected',
        ),

        DataColumn(
          label: Text("Answer Key"),
          numeric: false,
          tooltip: 'Answer Key Options',
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
              Text (user.Marked.toString()),
            ),

            // Cell 3
            DataCell(
              Text (user.act_ans.toString()),
            ),

          ],
        ),
        // To Iterate & Map very important
      ).toList(),
    ),

  );
}

// Main Screen Class
class _Fourth_Screen extends State<Fourth_Screen> {
  // Scrollable Student ID

  showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context)
        {
          return CupertinoPicker(
            backgroundColor: Colors.white,
            onSelectedItemChanged: (value) {
              setState(() {
                cur_stud_id = value ;
              });
            },
            itemExtent: 32.0,
            children:   [
              for (var i=1;i<=analysis_data['answ'].length;i++)
                Text('$i'),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    print('Current Id $cur_stud_id');
    print("Amal ${analysis_data['answ'][0]['5']}");
    // Next student
    void  stud_next(){
      setState(() {
        if(cur_stud_id<analysis_data['Enroll_id'].length-1) {
          print("Next Student = $cur_stud_id");
          cur_stud_id++;
        }
        else
          cur_stud_id=0;
      });
    }

// Previous student
    void  stud_prev(){
      setState(() {
        // Range Problem
        if(cur_stud_id>0) {
          cur_stud_id--;
          print("previous Student = $cur_stud_id");
        }
        else
        cur_stud_id=0;
      });
    }

    // Testing The Scope of Analysis_Data
    print("Data in Page 4 ${analysis_data}");


    return Scaffold(
      //AppBar
      appBar: AppBar(
        title: Text("Student Responses"),
        backgroundColor: global_color,
      ),

      //  Floating Action Button
      floatingActionButton: Stack(

        children: <Widget>[

          // Button for Marks+
          Padding(padding: EdgeInsets.all(10)),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              label: Text(''),
              heroTag: null,
              onPressed: stud_prev,
              backgroundColor: global_color,
              icon: Icon(Icons.arrow_back_ios_sharp),),
          ),


          // Button for Upload
          Padding(padding: EdgeInsets.all(10)),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              label: Text(''),
              heroTag: null,
              onPressed: stud_next,
              backgroundColor: global_color,
              icon: Icon(Icons.arrow_forward_ios_sharp),),
          ),


          // Button for Marks-
          Padding(padding: EdgeInsets.all(10)),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton.extended(
              label: Text('Find'),
              heroTag: null,
              backgroundColor: global_color,
              onPressed: showPicker,
              icon: Icon(Icons.person),),
          ),

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,



      // Body as Row
      body: ListView.separated(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            // Main Container
            children: [
              // Making the Data Table
              databody(),
              Divider(),
              Divider(),
            ],
          );
        },
        // For spacing between widgets
        separatorBuilder: (BuildContext context, int index) =>
        const Divider(height: 15, thickness: 10, indent: 15, endIndent: 15),
      ),
    );
  }
}
