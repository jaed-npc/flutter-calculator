import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // External package for expression evaluation

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NameInputScreen(),
    );
  }
}

// Initial screen for user to input their name
class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _goToCalculator() {
    if (_nameController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CalculatorScreen(name: _nameController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Name'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Please enter your name:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _goToCalculator,
              child: const Text('Go to Calculator'),
            ),
          ],
        ),
      ),
    );
  }
}

// Calculator screen that displays the user's name on the AppBar
class CalculatorScreen extends StatefulWidget {
  final String name;

  const CalculatorScreen({super.key, required this.name});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  // Button press handling: append to the expression
  void _onButtonPressed(String value) {
    setState(() {
      _expression += value;
    });
  }

  // Clear the expression and result
  void _clear() {
    setState(() {
      _expression = '';
      _result = '';
    });
  }

  // Evaluate the expression using the `expressions` package
  void _calculate() {
    try {
      final expression = Expression.parse(_expression);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      setState(() {
        _result = result.toString();
        _expression += ' = $_result';
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  // Custom logic for squaring a number
  void _square() {
    try {
      final expression = Expression.parse(_expression);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {});

      setState(() {
        _result = (result * result).toString(); // Square the result
        _expression = '$_expression² = $_result';
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildButton(String value, {Color? color}) {
    return ElevatedButton(
      onPressed: () {
        if (value == 'C') {
          _clear();
        } else if (value == '=') {
          _calculate();
        } else if (value == 'x²') {
          _square(); // Custom square logic
        } else {
          _onButtonPressed(value);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.grey[850],
        padding: const EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name}\'s Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerRight,
                color: Colors.black87,
                child: Text(
                  _expression,
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                  maxLines: 2,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              flex: 6,
              child: Column(
                children: <Widget>[
                  _buildRow(['7', '8', '9', '/']),
                  _buildRow(['4', '5', '6', '*']),
                  _buildRow(['1', '2', '3', '-']),
                  _buildRow(['C', '0', '=', '+']),
                  _buildRow(['x²', '%']), // New row with square and modulo buttons
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a row of buttons
  Widget _buildRow(List<String> values) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: values.map((value) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildButton(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
