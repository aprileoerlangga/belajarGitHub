import 'package:flutter/material.dart';
import 'calculator_tab.dart';
import 'temperature_converter_tab.dart';

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