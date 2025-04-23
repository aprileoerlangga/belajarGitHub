import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';

class CalculatorTab extends StatelessWidget {
  const CalculatorTab({Key? key}) : super(key: key);

  Widget _buildButton(BuildContext context, String text, {Color color = Colors.white, Color textColor = Colors.black}) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
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
              calculatorProvider.onClearPress();
            } else if (text == '=') {
              calculatorProvider.calculateResult();
            } else if (text == '.') {
              calculatorProvider.onDecimalPress();
            } else if (text == '+/-') {
              calculatorProvider.onPlusMinusPress();
            } else if ('+-×÷%^'.contains(text)) {
              calculatorProvider.onOperatorPress(text);
            } else {
              calculatorProvider.onDigitPress(text);
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
    
    return Consumer<CalculatorProvider>(
      builder: (context, calculatorProvider, child) {
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
                    calculatorProvider.expression,
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 8),
                  Text(
                    calculatorProvider.display,
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
                          _buildButton(context, 'C', 
                            color: isDarkMode ? Colors.grey[800]! : Colors.red.shade100, 
                            textColor: isDarkMode ? Colors.green : Colors.red),
                          _buildButton(context, '^', 
                            color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                            textColor: isDarkMode ? Colors.blue : Colors.blue),
                          _buildButton(context, '%', 
                            color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                            textColor: isDarkMode ? Colors.blue : Colors.blue),
                          _buildButton(context, '÷', 
                            color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                            textColor: isDarkMode ? Colors.blue : Colors.blue),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton(context, '7', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '8', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '9', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '×', 
                            color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                            textColor: isDarkMode ? Colors.blue : Colors.blue),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton(context, '4', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '5', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '6', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '-', 
                            color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                            textColor: isDarkMode ? Colors.blue : Colors.blue),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton(context, '1', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '2', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '3', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '+', 
                            color: isDarkMode ? Colors.grey[800]! : Colors.blue.shade100, 
                            textColor: isDarkMode ? Colors.blue : Colors.blue),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton(context, '00', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '0', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '.', 
                            color: isDarkMode ? Colors.grey[900]! : Colors.white, 
                            textColor: isDarkMode ? Colors.white : Colors.black),
                          _buildButton(context, '=', 
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
      },
    );
  }
}