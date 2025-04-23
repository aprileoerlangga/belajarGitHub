import 'package:flutter/material.dart';

class TemperatureProvider with ChangeNotifier {
  String _display = '0';
  String _activeUnit = 'Celsius'; // Default active unit
  Map<String, double> _temperatures = {
    'Celsius': 0,
    'Fahrenheit': 32,
    'Kelvin': 273.15,
  };
  bool _isNewInput = true;

  String get display => _display;
  String get activeUnit => _activeUnit;
  Map<String, double> get temperatures => _temperatures;

  void onDigitPress(String digit) {
    if (_isNewInput) {
      _display = digit;
      _isNewInput = false;
    } else if (_display == '0' && digit != '00') {
      _display = digit;
    } else {
      _display += digit;
    }
    _updateAllTemperatures();
    notifyListeners();
  }

  void onDecimalPress() {
    if (_isNewInput) {
      _display = '0,';
      _isNewInput = false;
    } else if (!_display.contains(',')) {
      _display += ',';
    }
    notifyListeners();
  }

  void onClearPress() {
    _display = '0';
    _isNewInput = true;
    _temperatures = {
      'Celsius': 0,
      'Fahrenheit': 32,
      'Kelvin': 273.15,
    };
    notifyListeners();
  }

  void onBackspacePress() {
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
    notifyListeners();
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
      notifyListeners();
    } catch (e) {
      // Handle invalid input
    }
  }

  void setActiveUnit(String unit) {
    _activeUnit = unit;
    _display = formatTemperature(_temperatures[unit]!);
    _isNewInput = true;
    notifyListeners();
  }

  String formatTemperature(double value) {
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
}