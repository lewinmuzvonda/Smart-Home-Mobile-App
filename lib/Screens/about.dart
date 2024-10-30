
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class About extends StatefulWidget {
  About(
      // {
      //   required this.balance,
      // }
      );

  // final double balance;

    @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Ark Energy - eWelink', style: TextStyle(fontSize: 24)),
    );
  }

}