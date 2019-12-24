import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LED Controls',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(title: 'LED Controls'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _powerOn = false;
  Color _color = Colors.blue[500];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Transform.scale(
            scale: 1.5,
            child: FloatingActionButton(
              backgroundColor: _powerOn ? Colors.yellow[400] : Colors.grey,
              child: Icon(Icons.lightbulb_outline),
              onPressed: () {
                setState(() {
                  _powerOn = !_powerOn;
                });
              },
            ),
          ),
          ColorPicker(
            color: _color,
            onChanged: (value) { 
              _color = value;
            }
          ),
        ],
      ),
    );
  }
}
