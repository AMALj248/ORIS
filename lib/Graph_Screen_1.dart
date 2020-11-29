import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'Api_Call.dart';
import 'Multiple_Image_Selector.dart';
import 'main.dart';

// Color Gradient for Bell Curve
List<Color> gradient_clr = [Color(0xff23b6eb), Color(0xff02d39a)];

// Title for Bell Curve
class LineTitles {
  static getTitles() => FlTitlesData(
    show: true,

    // X Axis Title
    bottomTitles: SideTitles(
      showTitles: true,
    ),

    // Y Axis Title
    leftTitles: SideTitles(
      showTitles: true,
    ),
  );
}

//Making the DataTable Rows Template
class Stud_data_graph {
  var x_pt;
  var y_pt;


  Stud_data_graph({this.x_pt, this.y_pt});
  // A function that returns Student Data for Rows
  static List<Stud_data_graph> getData() {
    return <Stud_data_graph>[
      // Looping through Values
      // Looping through Values
      for(var i=0; i<length_data_pts; i++)
        Stud_data_graph(x_pt: analysis_data['Ques_No'][i], y_pt:  analysis_data['Right_Answers'][i]),

    ];
  }
}


// Parent Class
class Grapher extends StatefulWidget {

  @override
  createState() => _GrapherState();
}

// Main Screen Class
class _GrapherState extends State<Grapher> {
var data_points = Stud_data_graph.getData();
  @override

  Widget build(BuildContext context) {
    return Scaffold(

      //AppBar
      appBar: AppBar(
        title: Text("Class Performance"),
        backgroundColor: global_color,

      ),

      // Body as Row
      body: ListView.separated(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(

            // Main Container
            children: [

              // Bell Curve
              Divider(),
              Text("Right Answers Frequency"),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
              ),
              Container(
                color: Colors.white10,
                height: 350,
                width: 350,


                // Bell Curve
                child: LineChart(

                  // Base Data Description
                    LineChartData(
                      titlesData: LineTitles.getTitles(),
                      minX: 0,
                      maxX: length_data_pts.toDouble(),
                      minY: 0.0,
                      maxY: analysis_data['Enroll_id'].length.toDouble()+1,
                      gridData: FlGridData(show: true),
                      lineBarsData: [
                        // DataPoints
                        LineChartBarData(

                 spots: [
                   for(var i=0; i<length_data_pts;i++)

                     // For Plotting the Data
                       FlSpot(data_points[i].x_pt.toDouble() , data_points[i].y_pt.toDouble())

                    ],
                          // To Smooth out curve
                          isCurved: false,
                          // Color of Line
                          colors: gradient_clr,
                          // Thickness of Line
                          barWidth: 5,
                        ),
                      ],
                    )),
              ),

              // Class Average
              Divider(),
              Container(
                  color: Colors.greenAccent[100],
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.1,
                  width: MediaQuery
                      .of(context)
                      .size
                      .height * 0.4,
                  padding: EdgeInsets.only(left: 5, top: 35),
                  child: (
                      Text("Class Average: ${analysis_data['Avg_Marks'].toString()}")

                  )

              ),

              // Class Accuracy
              Divider(),
              Container(
                  color: Colors.lightBlueAccent[100],
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.1,
                  width: MediaQuery
                      .of(context)
                      .size
                      .height * 0.4,
                  padding: EdgeInsets.only(left: 5, top: 35),
                  child: (
                      Text("Class Accuracy: ${analysis_data['Class_Accuracy'].toString()}%")
                  )
              ),

              // Total Test Takers
              Divider(),
              Container(
                  color: Colors.yellow[300],
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.1,
                  width: MediaQuery
                      .of(context)
                      .size
                      .height * 0.4,
                  padding:EdgeInsets.only(left: 5, top: 35),
                  child: (
                      Text("Total Test Takers: ${analysis_data['Enroll_id'].length.toString()}")


                  )
              ),

              // Api Call Button
          FloatingActionButton.extended(
          label: Text('Get Analytics'),
          heroTag: null,
          onPressed: (ans_get) ,
          backgroundColor: global_color,
          icon: Icon(Icons.padding),),

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

