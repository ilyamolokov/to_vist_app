import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateFolder extends StatefulWidget {
  final route;
  final customWhiteColor;
  final customBlackColor;

  CreateFolder(this.route, this.customWhiteColor, this.customBlackColor);

  @override
  State<StatefulWidget> createState() {
    return CreateFolderState(this.route, this.customWhiteColor, this.customBlackColor);
  }
}

class CreateFolderState extends State<CreateFolder> {
  final route;
  Color customWhiteColor;
  Color customBlackColor;

  CreateFolderState(this.route, this.customWhiteColor, this.customBlackColor);


  List<bool> _array = [true,
                      false,
                      false,
                      false,
                      false
                      ];

  static String grey = '0xffc3dce8';
  static String blue = '0xff6699cc';
  static String green = '0xff6fcb9f';
  static String red = '0xffe9a2a7';
  static String yellow = '0xfffaf4c4';  

  List _colors = [grey, blue, green, red, yellow];
  String folderBackgroundColor = grey;


  Widget _colorCircle(String _hexString, int index) {
    Color _color = Color(int.parse(_hexString));
    return Row(children: <Widget>[
      GestureDetector(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: _array[index] == false ? _selectedColorCircle(_color, _array[index]) : _selectedColorCircle(_color, _array[index])),
        onTap: () {
          setState(() {
            _array = List<bool>.generate(5, (int index) => false);
            _array[index] = true;
            folderBackgroundColor = _hexString;
          });
        },
      ),
      Container(width: 10.0)
    ]);
  }

  Widget _selectedColorCircle(Color _color, bool _state) {
    if (_state == false) {
      return Container(width: 50.0, height: 50.0, color: _color);
    } else {
      return Container(width: 55.0, height: 55.0, decoration: BoxDecoration(color: _color, borderRadius:BorderRadius.circular(30.0), border: Border.all(width: 2.5, color:this.customBlackColor)));      
    }
  }

  final _controller = TextEditingController();

  String folderName;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_setFolderName);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    super.dispose();
  }

  _setFolderName() {
    folderName = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color:customBlackColor),
          backgroundColor: customWhiteColor,
          title: Text("Создать папку", style: TextStyle(color:customBlackColor, fontSize: 16.0))),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 37.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Введите имя папки",
                fillColor: Colors.black,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customBlackColor, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              controller: _controller,
            ),
          ),
          Text("Выберите цвет папки", style: TextStyle(fontSize:15.0, color:customBlackColor)),
          Container(height:6.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            _colorCircle(_colors[0], 0),
            _colorCircle(_colors[1], 1),
            _colorCircle(_colors[2], 2),
            _colorCircle(_colors[3], 3),
            _colorCircle(_colors[4], 4)
          ]),
          Container(height: 18.0),
          ButtonTheme(
              child: RaisedButton(
            child: Text(
              "OK",
              style: TextStyle(color: customBlackColor),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            color: customWhiteColor,
            onPressed: () {
              if (!(folderName == null)) {
                this
                    .route
                    .document()
                    .setData({"name": folderName, "list_of_links": [], "folder_background_color": folderBackgroundColor});
                Navigator.pop(context);
              }
            },
          )),
        ]));
  }
}

class UpdateFolder extends StatefulWidget {
  final route;
  final folderBackgroundColor;
  final customWhiteColor;
  final _instance;
  final customBlackColor;

  UpdateFolder(this.route, this.folderBackgroundColor, this.customWhiteColor, this._instance, this.customBlackColor);

  @override
  State<StatefulWidget> createState() {
    return UpdateFolderState(route, folderBackgroundColor, customWhiteColor, _instance, customBlackColor);
  }
}

class UpdateFolderState extends State<UpdateFolder> {
  final route;
  String folderBackgroundColor;
  Color customWhiteColor;
  final _instance;
  Color customBlackColor;

  UpdateFolderState(this.route, this.folderBackgroundColor, this.customWhiteColor, this._instance, this.customBlackColor);

  TextEditingController _controller = TextEditingController();

  String folderName;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_setFolderName);
    _controller.text = _instance['name'];
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    super.dispose();
  }

  _setFolderName() {
    folderName = _controller.text;
  }

  List<bool> _array = [false,
                      false,
                      false,
                      false,
                      false
                      ];


  static String grey = '0xffc3dce8';
  static String blue = '0xff6699cc';
  static String green = '0xff6fcb9f';
  static String red = '0xffe9a2a7';
  static String yellow = '0xfffaf4c4';  


  List _colors = [grey, blue, green, red, yellow];


  Widget _colorCircle(String _hexString, int index) {
    if (_colors.contains(folderBackgroundColor) ) {
      int hexIndex = _colors.indexOf(folderBackgroundColor);
    _array[hexIndex] = true;
    }

    Color _color = Color(int.parse(_hexString));
    return Row(children: <Widget>[
      GestureDetector(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: _array[index] == false ? _selectedColorCircle(_color, _array[index]) : _selectedColorCircle(_color, _array[index])),
        onTap: () {
          setState(() {
            _array = List<bool>.generate(5, (int index) => false);
            _array[index] = true;
            folderBackgroundColor = _hexString;
          });
        },
      ),
      Container(width: 10.0)
    ]);
  }

  Widget _selectedColorCircle(Color _color, bool _state) {
    if (_state == false) {
      return Container(width: 50.0, height: 50.0, color: _color);
    } else {
      return Container(width: 55.0, height: 55.0, decoration: BoxDecoration(color: _color, borderRadius:BorderRadius.circular(30.0), border: Border.all(width: 2.5, color:this.customBlackColor)));      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color:customBlackColor),
          backgroundColor: customWhiteColor,
          title:
              Text("Переименовать папку", style: TextStyle(fontSize: 16.0, color:customBlackColor))),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 37.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Введите новое имя папки",
                    fillColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customBlackColor, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  controller: _controller,
                  // onChanged: (text) {
                  //   folderName = text;
                  // },
                ),
              ),
              Text("Выберите цвет папки", style: TextStyle(fontSize:15.0, color:customBlackColor)),
              Container(height:6.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                _colorCircle(_colors[0], 0),
                _colorCircle(_colors[1], 1),
                _colorCircle(_colors[2], 2),
                _colorCircle(_colors[3], 3),
                _colorCircle(_colors[4], 4)
              ]),
              Container(height:18.0),
              ButtonTheme(
                  child: RaisedButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: customBlackColor),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                color: customWhiteColor,
                onPressed: () {
                  if (!(folderName == '')) {
                    this
                        .route
                        .document(this._instance.documentID)
                        .updateData({"name": folderName, "folder_background_color": folderBackgroundColor});
                    Navigator.pop(context);
                  }
                },
              )),
            ]));
  }
}
