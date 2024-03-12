import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_cafe/screens/accompaniments_dart.dart';
import 'package:food_cafe/screens/breakfast_screen.dart';
import 'package:food_cafe/screens/offer_screen.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _allPages = <Widget>[
    OfferScreen(),
    AccompanimentsScreen(),
    BreakfastScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _allPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Offer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_sharp),
            label: 'Accompanies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_sharp),
            label: 'Breakfast',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchData() async {
  String url = 'https://develop.heartinz.in/api/get-store-digital-menu';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  Map<String, dynamic> data = {
    "storeid": "61cf00f1747cb740a3bf00b6",
    "zoneid": ""
  };

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw 'Failed to load data';
    }
  } catch (e) {
    throw 'Error: $e';
  }
}
