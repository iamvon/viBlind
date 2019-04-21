import 'package:flutter/material.dart';

class TextView extends StatefulWidget {
  _TextViewState createState() => _TextViewState();
}

final objectText = "Hello";

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final objectsText = new Container(
        padding: const EdgeInsets.all(10.0),
        width: screenWidth,
        margin: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 40,
        ),

        decoration: new BoxDecoration(
          color: Color.fromRGBO(211, 211, 211, 0.85),
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 10.0),
            )
          ],
        ),

        child: new Text(
          objectText,
          style: const TextStyle(
            color: Colors.black87,
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ));

    return new Container(
      alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        vertical: 30.0,
        horizontal: 24.0,
      ),
      child: new Stack(
        children: <Widget>[
          objectsText,
        ],
      ),
    );

  }
}
