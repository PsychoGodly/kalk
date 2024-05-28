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

class _CalculatorPageState extends State<CalculatorPage> {
  int equalPressedCounter = 0; // Add this line

  // Rest of the class code...
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
    Future.delayed(Duration.zero, () {
      showPinGenerationDialog(context);
    });
  }

  Future<void> showPinGenerationDialog(BuildContext context) async {
    TextEditingController pinController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Generate PIN'),
          content: TextFormField(
            controller: pinController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter PIN (4 digits)'),
            maxLength: 4,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                pin = pinController.text;
                pinGenerated = true;
                Navigator.of(context).pop();
              },
              child: Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  void buttonPressed(String text) {
  setState(() {
    if (text == 'C') {
      expression = '';
      result = '0';
    } else if (text == '=') {
      if (enteredPin == pin && expression.isEmpty) {
        accessGranted = true;
      } else {
        enteredPin = '';
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = exp.evaluate(EvaluationType.REAL, cm).toString();
        } catch (e) {
          result = 'Error';
        }
        expression = '';
      }
    } else if (RegExp(r'[0-9]').hasMatch(text) && !accessGranted) {
      enteredPin += text;
      expression += text;
    } else if (text == 'E' && expression.isEmpty && enteredPin == pin) {
      equalPressedCounter++;
      if (equalPressedCounter >= 4) {
        accessGranted = true;
        enteredPin = '';
      }
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
