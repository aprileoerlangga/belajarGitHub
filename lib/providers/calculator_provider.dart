import 'package:flutter/material.dart';
import 'dart:math' as math;

class CalculatorProvider with ChangeNotifier {
  String _expression = '';
  String _display = '0';
  bool _shouldResetDisplay = false;
  bool _isCalculating = false;

  String get expression => _expression;
  String get display => _display;

  void onDigitPress(String digit) {
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
    notifyListeners();
  }

  void onOperatorPress(String operator) {
    if (_isCalculating) {
      // Calculate the current result
      calculateResult();
      // Start a new calculation with the result
      _expression = _display + operator;
    } else {
      _expression = (_expression.isEmpty ? _display : _expression) + operator;
    }
    
    _shouldResetDisplay = false;
    _isCalculating = true;
    notifyListeners();
  }

  void calculateResult() {
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
        
        // Format the result to remove unnecessary decimal places
        _display = result.toString();
        if (_display.endsWith('.0')) {
          _display = _display.substring(0, _display.length - 2);
        }
        notifyListeners();
      }
    } catch (e) {
      _display = 'Error';
      notifyListeners();
    }
  }

  void onClearPress() {
    _display = '0';
    _expression = '';
    _shouldResetDisplay = false;
    _isCalculating = false;
    notifyListeners();
  }

  void onDecimalPress() {
    if (_shouldResetDisplay) {
      _display = '0.';
      _expression += '0.';
      _shouldResetDisplay = false;
    } else if (!_display.contains('.')) {
      _display += '.';
      _expression += '.';
    }
    notifyListeners();
  }

  void onPlusMinusPress() {
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
    notifyListeners();
  }
}