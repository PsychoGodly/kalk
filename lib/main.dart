import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';
  String result = '0';

  void buttonPressed(String text) {
    setState(() {
      if (text == 'C') {
        expression = '';
        result = '0';
      } else if (text == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = exp.evaluate(EvaluationType.REAL, cm).toString();
        } catch (e) {
          result = 'Error';
        }
        expression = '';
      } else {
        expression += text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
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
      ),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Store your secret files and memos here.',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Back'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CalculatorScreen(),
  ));
}
