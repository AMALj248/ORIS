import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Multiple_Image_Selector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Api_Call.dart';

// Marks Variable
var pos_mark=0, neg_mark=0;

//for Storing  Globally MCQ Answers
List A_selectedIndexs = [];
List B_selectedIndexs = [];
List C_selectedIndexs = [];
List D_selectedIndexs = [];
List Neg_selectedIndex = [];



// For the JSON Format Encoding
class json_frmt {
  List a_opt=[];
  List b_opt=[];
  List c_opt=[];
  List d_opt=[];
  List neg_q=[];
  var ps_mrk;
  var ng_mrk;
  List url_lst=[];


  json_frmt(this.a_opt, this.b_opt, this.c_opt, this.d_opt, this.neg_q, this.ps_mrk, this.ng_mrk, this.url_lst);

  Map toJson() => {
    'A': a_opt,
    'B': b_opt,
    'C':c_opt,
    'D':d_opt,
    'Neg_Ques': neg_q,
    'Neg_Mrk': ng_mrk,
    'Pos_Mrk': ps_mrk,
    'Url_List': url_lst

  };
}

// Main Parent Class
class firstscreen extends StatefulWidget {
  @override
  _firstscreenState createState() => _firstscreenState();
}




// Main Class
class _firstscreenState extends State<firstscreen> {

// To increase Marks
void marks_inc()
{
  setState(() {
    if(pos_mark<4)
    pos_mark++;
    else
      pos_mark=0;
  });

}


// To decrease Marks
  void marks_dec()
  {
    setState(() {
      if(neg_mark<4)
      neg_mark++;
      else
        neg_mark=0;
    });

  }

 Future<void> ans_upload() async {
   print("Button Pressed");

   print("Final A {$A_selectedIndexs}");
   print("Final B {$B_selectedIndexs}");
   print("Final C {$C_selectedIndexs}");
   print("Final D {$D_selectedIndexs}");
   print("Final Neg {$Neg_selectedIndex}");

   // Enconding tp Seperate JSON List
   var a_list = A_selectedIndexs;
   var b_list = B_selectedIndexs;
   var c_list = C_selectedIndexs;
   var d_list = D_selectedIndexs;
   var neg_list = Neg_selectedIndex;


   final String url = 'https://89d54b366843.ngrok.io/answ/';

   // Converting to JSON Format
   json_frmt data = json_frmt(
       a_list,
       b_list,
       c_list,
       d_list,
       neg_list,
       pos_mark,
       neg_mark,
       url_list);

   // Encoding to JSON
   String json_data = jsonEncode(data);

   print("Send ${json_data}");

   // Post Request
   try {
     var response = await http.post(url, body: json_data);

     // Successful API CALL
       print("Response from Server ${response.statusCode}");
       // Calling Anlaytics getting function

       await ans_get();
     Fluttertoast.showToast(msg: "Answer Key Uploaded", backgroundColor: Colors.greenAccent[400]);

   }
   // Exception
  catch(e) {
    throw Exception(e);
   }


}

  @override
  Widget build(BuildContext context) {
    //Parent Scaffold
    return Scaffold(
      //AppBar
      appBar: AppBar(
        title: Text("Answer Key"),
      ),

      //  Floating Action Button
      floatingActionButton: Stack(

        children: <Widget>[

          // Button for Marks+

          Padding(padding: EdgeInsets.all(10)),
           Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              label: Text('Marks'),
              heroTag: null,
              onPressed: marks_inc,
              icon: Icon(Icons.add),),
          ),


          // Button for Upload
          Padding(padding: EdgeInsets.all(10)),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              label: Text('Marks'),
              heroTag: null,
              onPressed: marks_dec,
              icon: Icon(Icons.remove),),
          ),


          // Button for Marks-
          Padding(padding: EdgeInsets.all(10)),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton.extended(
              label: Text('Upload'),
              heroTag: null,
              onPressed: ans_upload,
              icon: Icon(Icons.storage),),
          ),

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      //Main Body
      body: ListView.separated(
        //For Even Spacing of Rows
        padding: const EdgeInsets.only(left: 0, top: 40, right: 6,bottom: 70),
        //How many copies of Answers
        itemCount: 20,
        //required constructor
        itemBuilder: (BuildContext context, int index) {
          // Since index starts from 0
          index = index+1;


          //final boolean values of touches
          final A_isSelected = A_selectedIndexs.contains(index);
          final B_isSelected = B_selectedIndexs.contains(index);
          final C_isSelected = C_selectedIndexs.contains(index);
          final D_isSelected = D_selectedIndexs.contains(index);
          final neg_isSelected = Neg_selectedIndex.contains(index);


          return Row(


            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

          // for questions
              Divider(),
              Container(
                //Area of the Box
                height: 20,
                width: 30,
                alignment: Alignment.center,
                //Inserting the logo
                decoration: BoxDecoration(
                  //Shaping thr Box
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey,
                ),

                child: Row(
                  children: <Widget>[
                    Text(
                      'Q${index}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),

              //For Options ABCD
              //For Divider
              Divider(),
              GestureDetector(
                onTap: () {
                  //to register touch
                  setState(() {
                    if (A_isSelected) {
                      A_selectedIndexs.remove(index);
                      print("Removed A : $A_selectedIndexs");
                    } else {
                      A_selectedIndexs.add(index);
                      print("Added  A : $A_selectedIndexs");
                    }
                  });
                },
                child: Container(
                  //Area of the Box
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  //Inserting the logo
                  decoration: BoxDecoration(
                    //Shaping thr Box
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    //shadow for the box
                    boxShadow: [
                      BoxShadow(
                        //dynamic click color
                        color: A_isSelected
                            ? Colors.lightBlueAccent
                            : Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'A',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //For Divider
              Divider(),
              GestureDetector(
                onTap: () {
                  //to register touch
                  setState(() {
                    if (B_isSelected) {
                      B_selectedIndexs.remove(index);
                      print("Removed B : $B_selectedIndexs");
                    } else {
                      B_selectedIndexs.add(index);
                      print("Added B : $B_selectedIndexs");
                    }
                  });
                },
                child: Container(
                  //Area of the Box
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  //Inserting the logo
                  decoration: BoxDecoration(
                    //Shaping thr Box
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    //shadow for the box
                    boxShadow: [
                      BoxShadow(
                        //dynamic click color
                        color: B_isSelected
                            ? Colors.lightBlueAccent
                            : Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'B',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //For Divider
              Divider(),
              GestureDetector(
                onTap: () {
                  //to register touch
                  setState(() {
                    if (C_isSelected) {
                      C_selectedIndexs.remove(index);
                      print("Removed C : $C_selectedIndexs");
                    } else {
                      C_selectedIndexs.add(index);
                      print("Added C : $C_selectedIndexs");
                    }
                  });
                },
                child: Container(
                  //Area of the Box
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  //Inserting the logo
                  decoration: BoxDecoration(
                    //Shaping thr Box
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    //shadow for the box
                    boxShadow: [
                      BoxShadow(
                        //dynamic click color
                        color: C_isSelected
                            ? Colors.lightBlueAccent
                            : Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'C',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //For Divider
              Divider(),
              GestureDetector(
                onTap: () {
                  //to register touch
                  setState(() {
                    if (D_isSelected) {
                      D_selectedIndexs.remove(index);
                      print("Removed D : $D_selectedIndexs");
                    } else {
                      D_selectedIndexs.add(index);
                      print("Added D : $D_selectedIndexs");
                    }
                  });
                },
                child: Container(
                  //Area of the Box
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  //Inserting the logo
                  decoration: BoxDecoration(
                    //Shaping thr Box
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    //shadow for the box
                    boxShadow: [
                      BoxShadow(
                        //dynamic click color
                        color: D_isSelected
                            ? Colors.lightBlueAccent
                            : Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'D',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //For + Marks
              //For Divider
              Divider(),
              GestureDetector(
                onTap: () {
                  //to register touch
                  setState(() {
                    if (neg_isSelected) {
                      Neg_selectedIndex.remove(index);
                      print("Removed Marks for : $Neg_selectedIndex");
                    } else {
                      Neg_selectedIndex.add(index);
                      print("Added Marks for : $Neg_selectedIndex");
                    }
                  });
                },
                child: Container(
                  //Area of the Box
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  //Inserting the logo
                  decoration: BoxDecoration(
                    //Shaping thr Box
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    //shadow for the box
                    boxShadow: [
                      BoxShadow(
                        //dynamic click color
                        color: neg_isSelected ? Colors.red : Colors.greenAccent,
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 0,
                      top: 0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          //for dynamic text based on click
                          neg_isSelected ? neg_mark.toString() : pos_mark.toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          );

          // Uploading the Answer Key
        },
        // For spacing between widgets
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 20, endIndent: 1),
      ),
    );

}

}
