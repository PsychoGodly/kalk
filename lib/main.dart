import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import 'dart:math';

void main() {
  runApp(Kalk());
}

class Kalk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String expression = '';
  String result = '0';
  String pin = '';
  String enteredPin = '';
  bool pinGenerated = false;
  bool accessGranted = false;

  @override
  void initState() {
    super.initState();
    generatePin();
  }

  void generatePin() {
    if (!pinGenerated) {
      Random random = Random();
      for (int i = 0; i < 4; i++) {
        pin += random.nextInt(10).toString();
      }
      pinGenerated = true;
      print("Generated PIN: $pin"); // For testing purposes
    }
  }

  void buttonPressed(String text) {
    setState(() {
      if (text == 'C') {
        expression = '';
        result = '0';
      } else if (text == '=') {
        if (enteredPin == pin) {
          accessGranted = true;
        } else {
          enteredPin = '';
          expression += '=';
          try {
            Parser p = Parser();
            Expression exp = p.parse(expression);
            ContextModel cm = ContextModel();
            result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          } catch (e) {
            result = 'Error';
          }
          expression = '';
        }
      } else if (RegExp(r'[0-9]').hasMatch(text) && !accessGranted) {
        enteredPin += text;
        expression += text;
      } else {
        expression += text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalk'),
      ),
      body: accessGranted ? SecretPage() : buildCalculator(),
    );
  }

  Widget buildCalculator() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.bottomRight,
            child: Text(
              expression,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.bottomRight,
            child: Text(
              result,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Column(
          children: [
            buildButtonRow(['7', '8', '9', '/']),
            buildButtonRow(['4', '5', '6', '*']),
            buildButtonRow(['1', '2', '3', '-']),
            buildButtonRow(['C', '0', '=', '+']),
          ],
        ),
      ],
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        return ElevatedButton(
          onPressed: () => buttonPressed(button),
          child: Text(
            button,
            style: TextStyle(fontSize: 24),
          ),
        );
      }).toList(),
    );
  }
}

class SecretPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secret Files & Memos'),
      ),
      body: Center(
        child: Text(
          'Store your secret files and memos here.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
