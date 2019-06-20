import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'src/folder_operations.dart';
import 'src/link_operations.dart';
import 'src/Dialogs.dart';

import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme:ThemeData(fontFamily: 'OpenSans SemiBold'), home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var route = Firestore.instance.collection('folders');
  Color customWhiteColor = Color(0xfff0f3ed);
  Color customBlackColor = Color(0xff2b4754);
  FolderDeleteDialog folderDeleteDialog = FolderDeleteDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text("To Visit App",
                  style: TextStyle(color: customBlackColor, fontSize: 16.0, fontFamily: 'Montserrat'))),
          backgroundColor: customWhiteColor),
      body: StreamBuilder(
        stream: route.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: Text("Loading..."));
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                int hexColor = int.parse(
                    snapshot.data.documents[index]['folder_background_color']);
                Color folderBackgroundColor = Color(hexColor);
                return Column(children: <Widget>[
                  Container(
                      margin:
                          EdgeInsets.only(top: 7.0, left: 2.0, right: 2.0),
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey[400],
                            offset: Offset(1.0, 1.0),
                            blurRadius: 1.8,
                          ),
                        ],
                      ),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        color: folderBackgroundColor,
                        child: Column(children: <Widget>[
                          Center(
                              heightFactor: 1.7,
                              child: Text(
                                  snapshot.data.documents[index]['name']
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: customBlackColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500))),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                    child: Icon(Icons.edit,
                                        color: (folderBackgroundColor == Color(0xfffaf4c4) || folderBackgroundColor == Color(0xffc3dce8)) ? customBlackColor : customWhiteColor),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UpdateFolder(
                                                  route,
                                                  snapshot.data.documents[index]
                                                      [
                                                      'folder_background_color'],
                                                  customWhiteColor,
                                                  snapshot
                                                      .data.documents[index],
                                                  customBlackColor)));
                                    }),
                                FlatButton(
                                    child: Icon(Icons.delete,
                                        color: (folderBackgroundColor == Color(0xfffaf4c4) || folderBackgroundColor == Color(0xffc3dce8)) ? customBlackColor : customWhiteColor),
                                    onPressed: () {
                                      folderDeleteDialog.confirm(
                                          context,
                                          route,
                                          snapshot.data.documents[index],
                                          'Удалить папку',
                                          'Вы точно хотите удалить папку?');
                                    }),
                              ]),
                          Align(child:Text("Ссылок в папке: ${snapshot.data.documents[index]['list_of_links'].length}", style: TextStyle(fontSize:10.0, fontFamily: 'OpenSans Light')), alignment: Alignment.bottomRight)
                        ]),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LinkList(
                                      route,
                                      folderBackgroundColor,
                                      snapshot.data.documents[index],
                                      customWhiteColor,
                                      index,
                                      customBlackColor)));
                        },
                      ))
                ]);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: customWhiteColor,
          child: Icon(Icons.add, color: customBlackColor),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateFolder(
                        route, customWhiteColor, customBlackColor)));
          }),
    ); // body: ,);
  }
}

class LinkList extends StatelessWidget {
  final route;
  final folderBackgroundColor;
  final _instance;
  final customWhiteColor;
  final _index;
  final customBlackColor;
  LinkList(this.route, this.folderBackgroundColor, this._instance,
      this.customWhiteColor, this._index, this.customBlackColor);

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await launch('https://www.google.com/search?q=$url');
    }
  }

  final _linkDeleteDialog = LinkDeleteDialog();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
            backgroundColor: folderBackgroundColor,
            appBar: AppBar(
                iconTheme: IconThemeData(color: customBlackColor),
                title: Text(_instance['name'],
                    style: TextStyle(fontSize: 16.0, color: customBlackColor)),
                backgroundColor: customWhiteColor),
            body: StreamBuilder(
              stream: route.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: Text("Loading..."));
                return ListView.builder(
                    itemCount:
                        snapshot.data.documents[_index]['list_of_links'] != null ? snapshot.data.documents[_index]['list_of_links'].length : 0,
                    itemBuilder: (context, index) {
                      var url = snapshot.data.documents[_index]['list_of_links'][index]['URL'].toString();
                      return Column(children: <Widget>[
                        Container(
                      margin:
                          EdgeInsets.only(top: 7.0, left: 12.0, right: 12.0),
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey[400],
                            offset: Offset(1.0, 1.0),
                            blurRadius: 1.8,
                          ),
                        ],
                      ),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        color: Colors.white,
                        child: Column(children: <Widget>[
                          Center(
                              heightFactor: 1.7,
                              child: Text(
                                  url,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: customBlackColor,
                                      fontSize: 16.0,
                                      ))),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  child:
                                      Icon(Icons.edit, color: customBlackColor),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateLink(
                                                route,
                                                snapshot.data.documents[_index]
                                                        ['list_of_links'][index]
                                                    ['URL'],
                                                _index,
                                                index,
                                                customWhiteColor,
                                                customBlackColor)));
                                  }),
                                FlatButton(
                                  child: Icon(Icons.delete,
                                      color: customBlackColor),
                                  onPressed: () {
                                    _linkDeleteDialog.confirm(
                                        context,
                                        route,
                                        snapshot,
                                        _instance.documentID,
                                        _index,
                                        index,
                                        'Удалить ссылку',
                                        'Вы точно хотите удалить ссылку?');
                                  })
                              ]),
                        ]),
                        onPressed: () {
                          _launchURL(url);
                        },
                      ))
                      ]   
                      );
                      });
                  
              },
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: customWhiteColor,
                child: Icon(Icons.add, color: customBlackColor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateLink(
                              route,
                              _instance.documentID,
                              _index,
                              customWhiteColor,
                              customBlackColor)));
                })));
  }
}


