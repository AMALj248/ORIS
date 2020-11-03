import 'package:flutter/material.dart';

class firstscreen extends StatefulWidget{
  @override
  _firstscreenState createState() => _firstscreenState();
}



class _firstscreenState extends State<firstscreen> {
  //for regestering the MCQ Answers
  List A_selectedIndexs=[];
  List B_selectedIndexs=[];
  List C_selectedIndexs=[];
  List D_selectedIndexs=[];

  @override  
  Widget build(BuildContext context)

  {
    //Parent Scaffold
    return Scaffold(


       //Main Body
          body: ListView.separated(
            //For Even Spacing of Rows
            padding: const EdgeInsets.only( left: 0,top: 80,right: 15),
            //How many copies of Answers
            itemCount: 10,
            //required constructor
            itemBuilder: (BuildContext context, int index) {
              //final boolean values of touches
              final A_isSelected=A_selectedIndexs.contains(index);
              final B_isSelected=B_selectedIndexs.contains(index);
              final C_isSelected=C_selectedIndexs.contains(index);
              final D_isSelected=D_selectedIndexs.contains(index);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  
                  // for questions
                  Divider(),
                  Container(
                    //Area of the Box
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    //Inserting the logo
                    decoration: BoxDecoration(
                      //Shaping thr Box
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey,
                      ),

                      child: Row(
                        children: <Widget>[
                          Text('Q$index', style: TextStyle(fontSize: 17),),
                        ],
                      ),
                    ),



                  //For Options ABCD
                  //For Divider
                  Divider(),
                  GestureDetector(
                    onTap: (){
                      //to register touch
                      setState(() {
                        if(A_isSelected){

                          A_selectedIndexs.remove(index);
                          print("Removed A : $A_selectedIndexs");

                        }else{
                          A_selectedIndexs.add(index);
                          print("Added  A : $A_selectedIndexs");

                        }
                      });
                    },
                    child: Container(
                        //Area of the Box
                        height: 40,
                        width: 60,
                        alignment: Alignment.center,
                        //Inserting the logo
                        decoration: BoxDecoration(
                          //Shaping thr Box
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          //shadow for the box
                          boxShadow: [
                            BoxShadow(
                              //dynamic click color
                              color:A_isSelected ?Colors.lightBlueAccent: Colors.grey.withOpacity(0.3),
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
                              Text('A', style: TextStyle(fontSize: 20),),
                            ],
                          ),
                        ),
                      ),
                  ),


                  //For Divider
                  Divider(),
                  GestureDetector(
                    onTap: (){
                      //to register touch
                      setState(() {
                        if(B_isSelected){

                          B_selectedIndexs.remove(index);
                          print("Removed B : $B_selectedIndexs");

                        }else{
                          B_selectedIndexs.add(index);
                          print("Added B : $B_selectedIndexs");

                        }
                      });
                    },
                    child: Container(
                      //Area of the Box
                      height: 40,
                      width: 60,
                      alignment: Alignment.center,
                      //Inserting the logo
                      decoration: BoxDecoration(
                        //Shaping thr Box
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        ),
                        //shadow for the box
                        boxShadow: [
                          BoxShadow(
                            //dynamic click color
                            color:B_isSelected ?Colors.lightBlueAccent: Colors.grey.withOpacity(0.3),
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
                            Text('B', style: TextStyle(fontSize: 20),),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //For Divider
                  Divider(),
                  GestureDetector(
                    onTap: (){
                      //to register touch
                      setState(() {
                        if(C_isSelected){

                          C_selectedIndexs.remove(index);
                          print("Removed C : $C_selectedIndexs");

                        }else{
                          C_selectedIndexs.add(index);
                          print("Added C : $C_selectedIndexs");

                        }
                      });
                    },
                    child: Container(
                      //Area of the Box
                      height: 40,
                      width: 60,
                      alignment: Alignment.center,
                      //Inserting the logo
                      decoration: BoxDecoration(
                        //Shaping thr Box
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        ),
                        //shadow for the box
                        boxShadow: [
                          BoxShadow(
                            //dynamic click color
                            color:C_isSelected ?Colors.lightBlueAccent: Colors.grey.withOpacity(0.3),
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
                            Text('C', style: TextStyle(fontSize: 20),),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //For Divider
                  Divider(),
                  GestureDetector(
                    onTap: (){
                      //to register touch
                      setState(() {
                        if(D_isSelected){

                          D_selectedIndexs.remove(index);
                          print("Removed D : $D_selectedIndexs");

                        }else{
                          D_selectedIndexs.add(index);
                          print("Added D : $D_selectedIndexs");

                        }
                      });
                    },
                    child: Container(
                      //Area of the Box
                      height: 40,
                      width: 60,
                      alignment: Alignment.center,
                      //Inserting the logo
                      decoration: BoxDecoration(
                        //Shaping thr Box
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        ),
                        //shadow for the box
                        boxShadow: [
                          BoxShadow(
                            //dynamic click color
                            color:D_isSelected ?Colors.lightBlueAccent: Colors.grey.withOpacity(0.3),
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
                            Text('D', style: TextStyle(fontSize: 20),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            // For spacing between widgets
            separatorBuilder: (BuildContext context, int index) => const Divider( height:20 , thickness : 1 ,indent: 1, endIndent: 5),
          ),
    );

  }
}