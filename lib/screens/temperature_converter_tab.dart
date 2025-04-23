import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/temperature_provider.dart';


class TemperatureConverterTab extends StatelessWidget {
  const TemperatureConverterTab({Key? key}) : super(key: key);

  Widget _buildKeypadButton(BuildContext context, String text, {bool isAccent = false, bool isBackspace = false}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode 
        ? (isAccent ? Colors.grey[800] : Colors.grey[900]) 
        : (isAccent ? Colors.blue.shade100 : Colors.white);
    final textColor = isDarkMode
        ? (isAccent ? Colors.blue : Colors.white)
        : (isAccent ? Colors.blue : Colors.black);
    
    final temperatureProvider = Provider.of<TemperatureProvider>(context, listen: false);
    
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
              temperatureProvider.onClearPress();
            } else if (text == '⌫') {
              temperatureProvider.onBackspacePress();
            } else if (text == ',') {
              temperatureProvider.onDecimalPress();
            } else {
              temperatureProvider.onDigitPress(text);
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
    
    return Consumer<TemperatureProvider>(
      builder: (context, temperatureProvider, child) {
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
                      temperatureProvider.formatTemperature(temperatureProvider.temperatures['Celsius']!),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: temperatureProvider.activeUnit == 'Celsius' ? FontWeight.bold : FontWeight.normal,
                        color: temperatureProvider.activeUnit == 'Celsius' ? accentColor : (isDarkMode ? Colors.white70 : Colors.black87),
                      ),
                    ),
                    onTap: () => temperatureProvider.setActiveUnit('Celsius'),
                  ),
                  Divider(color: isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                  ListTile(
                    title: Text('Fahrenheit (°F)', 
                      style: TextStyle(fontSize: 16, color: textColor)),
                    trailing: Text(
                      temperatureProvider.formatTemperature(temperatureProvider.temperatures['Fahrenheit']!),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: temperatureProvider.activeUnit == 'Fahrenheit' ? FontWeight.bold : FontWeight.normal,
                        color: temperatureProvider.activeUnit == 'Fahrenheit' ? accentColor : (isDarkMode ? Colors.white70 : Colors.black87),
                      ),
                    ),
                    onTap: () => temperatureProvider.setActiveUnit('Fahrenheit'),
                  ),
                  Divider(color: isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                  ListTile(
                    title: Text('Kelvin (K)', 
                      style: TextStyle(fontSize: 16, color: textColor)),
                    trailing: Text(
                      temperatureProvider.formatTemperature(temperatureProvider.temperatures['Kelvin']!),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: temperatureProvider.activeUnit == 'Kelvin' ? FontWeight.bold : FontWeight.normal,
                        color: temperatureProvider.activeUnit == 'Kelvin' ? accentColor : (isDarkMode ? Colors.white70 : Colors.black87),
                      ),
                    ),
                    onTap: () => temperatureProvider.setActiveUnit('Kelvin'),
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
                temperatureProvider.display,
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
                          _buildKeypadButton(context, '7'),
                          _buildKeypadButton(context, '8'),
                          _buildKeypadButton(context, '9'),
                          _buildKeypadButton(context, 'AC', isAccent: true),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildKeypadButton(context, '4'),
                          _buildKeypadButton(context, '5'),
                          _buildKeypadButton(context, '6'),
                          _buildKeypadButton(context, '⌫', isAccent: true, isBackspace: true),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildKeypadButton(context, '1'),
                          _buildKeypadButton(context, '2'),
                          _buildKeypadButton(context, '3'),
                          Expanded(child: Container()),  // Empty space instead of empty button
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildKeypadButton(context, '00'),
                          _buildKeypadButton(context, '0'),
                          _buildKeypadButton(context, ','),
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
      },
    );
  }
}