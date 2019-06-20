import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateLink extends StatefulWidget {
  final route;
  final _instanceID;
  final _index;
  final customWhiteColor;
  final customBlackColor;

  CreateLink(this.route, this._instanceID, this._index, this.customWhiteColor, this.customBlackColor);
  @override
    State<StatefulWidget> createState() {
      return CreateLinkState(this.route, this._instanceID, this._index, this.customWhiteColor, this.customBlackColor);
    }
}

class CreateLinkState extends State<CreateLink> {
  final route;
  final _instanceID;
  final _index;
  Color customWhiteColor;
  Color customBlackColor;

  List<Map> _newArray = List();
  String url;

  CreateLinkState(this.route, this._instanceID, this._index, this.customWhiteColor, this.customBlackColor);

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_setLinkName);
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
      DeviceOrientation.portraitDown
    ]);
    _controller.dispose();
    super.dispose();
  }

  _setLinkName() {
    url = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color:customBlackColor),
          backgroundColor: customWhiteColor,
          title: Text("Добавить URL", style: TextStyle(fontSize: 16.0, color:customBlackColor))),
        body: StreamBuilder(stream: route.snapshots(), builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 50.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Введите URL",
                    fillColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customBlackColor, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  controller: _controller,
                ),
              ),
              ButtonTheme(
                  child: RaisedButton(
                child: Text("OK", style:TextStyle(color:customBlackColor)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                color: customWhiteColor,
                onPressed: () {
                  if (!(url == null)) {
                    var map = {'URL': url};
                    for (var i in snapshot.data.documents[_index]['list_of_links']) {
                      _newArray.add(i);
                    }
                    _newArray.add(map);
                    this.route.document(this._instanceID).updateData({'list_of_links': _newArray});
                    Navigator.pop(context);
                  }
                },
              )),
            ]);
        }));
  }

}

class UpdateLink extends StatefulWidget {
  final route;
  final linkToChange; // значение "URl"а, т.е. та ссылка которую мы хотим изменить
  final _index;
  final customWhiteColor;
  final index;
  final customBlackColor;

  UpdateLink(this.route, this.linkToChange, this._index, this.index, this.customWhiteColor, this.customBlackColor);

  @override
    State<StatefulWidget> createState() {
      return UpdateLinkState();
    }
}

class UpdateLinkState extends State<UpdateLink> {
  var route;
  int _index;
  Color customWhiteColor;
  int index;
  Color customBlackColor;

  List<Map> _newArray = List();
  String url;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    route = widget.route;
    _index = widget._index;
    index = widget.index;
    customWhiteColor = widget.customWhiteColor;
    customBlackColor = widget.customBlackColor;
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.addListener(_setLinkName);
    _controller.text = widget.linkToChange;
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

  _setLinkName() {
    url = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color:customBlackColor),
          backgroundColor: customWhiteColor,
          title: Text("Изменить URL", style: TextStyle(fontSize: 16.0, color:customBlackColor))),
        body: StreamBuilder(stream: route.snapshots(), builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 50.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Введите URL",
                    fillColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customBlackColor, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  controller: _controller,
                  onChanged: (text) {
                    url = text;
                  },
                ),
              ),
              ButtonTheme(
                  child: RaisedButton(
                child: Text("OK", style:TextStyle(color:customBlackColor)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                color: customWhiteColor,
                onPressed: () {
                  if (!(url == '')) {
                    for (var i in snapshot.data.documents[_index]['list_of_links']) {
                      _newArray.add(i);
                    }
                    _newArray[index]['URL'] = url;
                    this.route.document(snapshot.data.documents[_index].documentID).updateData({'list_of_links': _newArray});
                    Navigator.pop(context);
                  }
                },
              )),
            ]);
        }));
  }
}