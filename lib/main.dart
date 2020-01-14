import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Socket sock = await Socket.connect('10.0.0.116', 80);
  runApp(MyApp(sock));
}

class MyApp extends StatelessWidget {
  Socket socket;

  MyApp(Socket s) {
    this.socket = s;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LED Controls',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(
        title: 'LED Controls',
        channel: socket,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.channel}) : super(key: key);

  final String title;
  final Socket channel;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _powerOn;
  bool _fade;
  Color _color;

  void _changeColor(int r, int g, int b) {
    widget.channel.write("$r $g $b\n");
  }

  void _changePower() {
    widget.channel.write("POWER\n");
  }

  void _changeFade() {
    widget.channel.write("FADE\n");
  }

  void _setPower(bool power) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('power', power);
  }

  Future<bool> _getPower() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool power = prefs.getBool('power') ?? false;
    return power;
  }

  void _setColor(int color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('color', color);
  }

  Future<int> _getColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int color = prefs.getInt('color') ?? 0xFF2197FF;
    return color;
  }

  void _setFade(bool fade) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('fade', fade);
  }

  Future<bool> _getFade() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool fade = prefs.getBool('fade') ?? false;
    return fade;
  }

  @override
  void dispose() {
    widget.channel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FutureBuilder(
            future: _getPower(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _powerOn = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Transform.scale(
                    scale: 1.5,
                    child: FloatingActionButton(
                      backgroundColor: _powerOn ? Colors.yellow[400] : Colors.grey,
                      child: Icon(Icons.lightbulb_outline),
                      onPressed: () {
                        _changePower();
                        setState(() {
                          _powerOn = !_powerOn;
                          _setPower(_powerOn);
                        });
                      },
                    ),
                  ),
                );
              }
              else {
                return Container();
              }
            }
          ),
          FutureBuilder(
            future: _getColor(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _color = Color(snapshot.data);
                return ColorPicker(
                  color: _color,
                  onChanged: (value) { 
                    _color = value;
                    _changeColor(value.red, value.green, value.blue);
                    _setColor(value.value);
                  }
                );
              }
              else {
                return Container();
              }
            }
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text("Fade", style: TextStyle(fontSize: 18.0, color: Colors.grey),),
              ),
              FutureBuilder(
                future: _getFade(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _fade = snapshot.data;
                    return Transform.scale(
                      scale: 1.5,
                      child: Switch(
                        value: _fade,
                        onChanged: (value) {
                          _changeFade();
                          setState(() {
                            _fade = !_fade;
                            _setFade(_fade);
                          });
                        },
                      ),
                    );
                  }
                  else {
                    return Container();
                  }
                }
              ),
            ],
          )
        ],
      ),
    );
  }
}
