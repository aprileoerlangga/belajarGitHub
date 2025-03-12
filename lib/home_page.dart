import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator & Converter'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
            Tab(icon: Icon(Icons.thermostat), text: 'Temperature'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CalculatorTab(),
          TemperatureConverterTab(),
        ],
      ),
    );
  }
}

class CalculatorTab extends StatefulWidget {
  @override
  _CalculatorTabState createState() => _CalculatorTabState();
}

// Updated Calculator Tab with Expression Display
class _CalculatorTabState extends State<CalculatorTab> {
  String _expression = '';
  String _display = '0';
  bool _shouldResetDisplay = false;
  bool _isCalculating = false;

  void _onDigitPress(String digit) {
    setState(() {
      if (_display == '0' || _shouldResetDisplay) {
        _display = digit;
        if (_shouldResetDisplay) {
          _expression += digit;
        } else {
          _expression = digit;
        }
        _shouldResetDisplay = false;
      } else {
        _display += digit;
        _expression += digit;
      }
    });
  }

  void _onOperatorPress(String operator) {
    setState(() {
      if (_isCalculating) {
        // Calculate the current result
        _calculateResult();
        // Start a new calculation with the result
        _expression = _display + operator;
      } else {
        _expression = (_expression.isEmpty ? _display : _expression) + operator;
      }
      
      _shouldResetDisplay = false;
      _isCalculating = true;
    });
  }

  void _calculateResult() {
    if (_expression.isEmpty) return;

    // Parse the expression
    try {
      // Simple expression parser (for demonstration)
      final RegExp regex = RegExp(r'(\d+\.?\d*)([+\-×÷%^])(\d+\.?\d*)');
      final match = regex.firstMatch(_expression);
      
      if (match != null) {
        final firstOperand = double.parse(match.group(1)!);
        final operator = match.group(2)!;
        final secondOperand = double.parse(match.group(3)!);
        
        double result = 0;
        
        switch (operator) {
          case '+':
            result = firstOperand + secondOperand;
            break;
          case '-':
            result = firstOperand - secondOperand;
            break;
          case '×':
            result = firstOperand * secondOperand;
            break;
          case '÷':
            result = firstOperand / secondOperand;
            break;
          case '%':
            result = firstOperand % secondOperand;
            break;
          case '^':
            result = math.pow(firstOperand, secondOperand).toDouble();
            break;
        }
        
        setState(() {
          // Format the result to remove unnecessary decimal places
          _display = result.toString();
          if (_display.endsWith('.0')) {
            _display = _display.substring(0, _display.length - 2);
          }
        });
      }
    } catch (e) {
      setState(() {
        _display = 'Error';
      });
    }
  }

  void _onClearPress() {
    setState(() {
      _display = '0';
      _expression = '';
      _shouldResetDisplay = false;
      _isCalculating = false;
    });
  }

  void _onDecimalPress() {
    setState(() {
      if (_shouldResetDisplay) {
        _display = '0.';
        _expression += '0.';
        _shouldResetDisplay = false;
      } else if (!_display.contains('.')) {
        _display += '.';
        _expression += '.';
      }
    });
  }

  void _onPlusMinusPress() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
        if (_expression.startsWith('-')) {
          _expression = _expression.substring(1);
        }
      } else {
        _display = '-' + _display;
        if (!_isCalculating) {
          _expression = '-' + _expression;
        }
      }
    });
  }

  Widget _buildButton(String text, {Color color = Colors.white, Color textColor = Colors.black}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            if (text == 'C') {
              _onClearPress();
            } else if (text == '=') {
              _calculateResult();
            } else if (text == '.') {
              _onDecimalPress();
            } else if (text == '+/-') {
              _onPlusMinusPress();
            } else if ('+-×÷%^'.contains(text)) {
              _onOperatorPress(text);
            } else {
              _onDigitPress(text);
            }
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // Expression and Result Display
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          color: isDarkMode ? Colors.black : Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _expression,
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 8),
              Text(
                _display,
                style: TextStyle(
                  fontSize: 48, 
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        Divider(height: 1),
        // Buttons
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            color: isDarkMode ? Colors.black : null,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('C', 
                        color: isDarkMode ? Colors.grey[800]! : Colors.red.shade100, 
                        textColor: isDarkMode ? Colors.green : Colors.red),
                      _buildButton('^', 
                        color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                        textColor: isDarkMode ? Colors.blue : Colors.blue),
                      _buildButton('%', 
                        color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                        textColor: isDarkMode ? Colors.blue : Colors.blue),
                      _buildButton('÷', 
                        color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                        textColor: isDarkMode ? Colors.blue : Colors.blue),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('7', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('8', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('9', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('×', 
                        color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                        textColor: isDarkMode ? Colors.blue : Colors.blue),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('4', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('5', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('6', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('-', 
                        color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                        textColor: isDarkMode ? Colors.blue : Colors.blue),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('1', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('2', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('3', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('+', 
                        color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                        textColor: isDarkMode ? Colors.blue : Colors.blue),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('00', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('0', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton(',', 
                        color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                        textColor: isDarkMode ? Colors.white : Colors.black),
                      _buildButton('=', 
                        color: isDarkMode ? Colors.grey[800]! : Colors.green.shade300, 
                        textColor: isDarkMode ? Colors.green : Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TemperatureConverterTab extends StatefulWidget {
  @override
  _TemperatureConverterTabState createState() => _TemperatureConverterTabState();
}

class _TemperatureConverterTabState extends State<TemperatureConverterTab> {
  String _display = '0';
  String _activeUnit = 'Celsius'; // Default active unit
  Map<String, double> _temperatures = {
    'Celsius': 0,
    'Fahrenheit': 32,
    'Kelvin': 273.15,
  };
  bool _isNewInput = true;

  void _onDigitPress(String digit) {
    setState(() {
      if (_isNewInput) {
        _display = digit;
        _isNewInput = false;
      } else if (_display == '0' && digit != '00') {
        _display = digit;
      } else {
        _display += digit;
      }
      _updateAllTemperatures();
    });
  }

  void _onDecimalPress() {
    setState(() {
      if (_isNewInput) {
        _display = '0,';
        _isNewInput = false;
      } else if (!_display.contains(',')) {
        _display += ',';
      }
    });
  }

  void _onClearPress() {
    setState(() {
      _display = '0';
      _isNewInput = true;
      _temperatures = {
        'Celsius': 0,
        'Fahrenheit': 32,
        'Kelvin': 273.15,
      };
    });
  }

  void _onBackspacePress() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
        if (_display.isEmpty) {
          _display = '0';
          _isNewInput = true;
        }
      } else {
        _display = '0';
        _isNewInput = true;
      }
      _updateAllTemperatures();
    });
  }

  void _updateAllTemperatures() {
    try {
      // Replace comma with decimal point for parsing
      String parseDisplay = _display.replaceAll(',', '.');
      double value = double.parse(parseDisplay);
      
      // Update the active temperature
      _temperatures[_activeUnit] = value;
      
      // Calculate other temperatures based on active unit
      if (_activeUnit == 'Celsius') {
        _temperatures['Fahrenheit'] = (value * 9 / 5) + 32;
        _temperatures['Kelvin'] = value + 273.15;
      } else if (_activeUnit == 'Fahrenheit') {
        _temperatures['Celsius'] = (value - 32) * 5 / 9;
        _temperatures['Kelvin'] = _temperatures['Celsius']! + 273.15;
      } else if (_activeUnit == 'Kelvin') {
        _temperatures['Celsius'] = value - 273.15;
        _temperatures['Fahrenheit'] = (_temperatures['Celsius']! * 9 / 5) + 32;
      }
    } catch (e) {
      // Handle invalid input
    }
  }

  void _setActiveUnit(String unit) {
    setState(() {
      _activeUnit = unit;
      _display = _formatTemperature(_temperatures[unit]!);
      _isNewInput = true;
    });
  }

  String _formatTemperature(double value) {
    // Format with comma as decimal separator
    String formatted = value.toStringAsFixed(2).replaceAll('.', ',');
    // Remove trailing zeros
    if (formatted.endsWith('0')) {
      formatted = formatted.replaceAll(RegExp(r',?0+$'), '');
    }
    // Remove trailing comma if it ends with comma
    if (formatted.endsWith(',')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
    return formatted;
  }

  Widget _buildKeypadButton(String text, {bool isAccent = false, bool isBackspace = false}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode 
        ? (isAccent ? Colors.grey[800] : Colors.grey[900]) 
        : (isAccent ? Colors.blue.shade100 : Colors.white);
    final textColor = isDarkMode
        ? (isAccent ? Colors.blue : Colors.white)
        : (isAccent ? Colors.blue : Colors.black);
    
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: EdgeInsets.all(10),  // Reduced padding for better visibility
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (text == 'AC') {
              _onClearPress();
            } else if (text == '⌫') {
              _onBackspacePress();
            } else if (text == ',') {
              _onDecimalPress();
            } else {
              _onDigitPress(text);
            }
          },
          child: Center(
            child: isBackspace
              ? Icon(Icons.backspace, color: textColor, size: 20)  // Smaller icon
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,  // Reduced font size
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final displayBgColor = isDarkMode ? Colors.black : Colors.grey[200];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final accentColor = isDarkMode ? Colors.blue : Colors.blue;
    
    return Column(
      children: [
        // Display area showing all three temperatures
        Container(
          padding: EdgeInsets.all(16),
          color: displayBgColor,
          child: Column(
            children: [
              ListTile(
                title: Text('Celsius (°C)', 
                  style: TextStyle(fontSize: 16, color: textColor)),
                trailing: Text(
                  _formatTemperature(_temperatures['Celsius']!),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: _activeUnit == 'Celsius' ? FontWeight.bold : FontWeight.normal,
                    color: _activeUnit == 'Celsius' ? accentColor : (isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                ),
                onTap: () => _setActiveUnit('Celsius'),
              ),
              Divider(color: isDarkMode ? Colors.grey[800] : Colors.grey[300]),
              ListTile(
                title: Text('Fahrenheit (°F)', 
                  style: TextStyle(fontSize: 16, color: textColor)),
                trailing: Text(
                  _formatTemperature(_temperatures['Fahrenheit']!),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: _activeUnit == 'Fahrenheit' ? FontWeight.bold : FontWeight.normal,
                    color: _activeUnit == 'Fahrenheit' ? accentColor : (isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                ),
                onTap: () => _setActiveUnit('Fahrenheit'),
              ),
              Divider(color: isDarkMode ? Colors.grey[800] : Colors.grey[300]),
              ListTile(
                title: Text('Kelvin (K)', 
                  style: TextStyle(fontSize: 16, color: textColor)),
                trailing: Text(
                  _formatTemperature(_temperatures['Kelvin']!),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: _activeUnit == 'Kelvin' ? FontWeight.bold : FontWeight.normal,
                    color: _activeUnit == 'Kelvin' ? accentColor : (isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                ),
                onTap: () => _setActiveUnit('Kelvin'),
              ),
            ],
          ),
        ),
        
        // Current active input with large display
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),  // Reduced vertical padding
          color: displayBgColor,
          child: Text(
            _display,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),  // Smaller font size
            textAlign: TextAlign.right,
          ),
        ),
        
        // Numeric keypad with consistent theme
        Expanded(
          child: Container(
            color: isDarkMode ? Colors.black : null,
            padding: EdgeInsets.all(4),  // Reduced padding
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildKeypadButton('7'),
                      _buildKeypadButton('8'),
                      _buildKeypadButton('9'),
                      _buildKeypadButton('AC', isAccent: true),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildKeypadButton('4'),
                      _buildKeypadButton('5'),
                      _buildKeypadButton('6'),
                      _buildKeypadButton('⌫', isAccent: true, isBackspace: true),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildKeypadButton('1'),
                      _buildKeypadButton('2'),
                      _buildKeypadButton('3'),
                      Expanded(child: Container()),  // Empty space instead of empty button
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildKeypadButton('00'),
                      _buildKeypadButton('0'),
                      _buildKeypadButton(','),
                      Expanded(child: Container()),  // Empty space instead of empty button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}