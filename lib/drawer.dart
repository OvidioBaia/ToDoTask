import 'package:flutter/material.dart';

class ItemMenu extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  ItemMenu(this.icon,this.text, this.controller,this.page);


  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Container(
          color: Color.fromRGBO(70, 168, 177, 1),
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(icon, size:32,color: Colors.white),
              SizedBox(width:32.0),
              Text(
                text,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}