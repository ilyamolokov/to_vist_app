import 'package:flutter/material.dart';

class FolderDeleteDialog {

  Color customBlackColor = Color(0xff2b4754);

  _deleteFolder(BuildContext context, route, _instance) {
    route.document(_instance.documentID).delete();
    Navigator.pop(context);
  }

  _cancelDelete(BuildContext context) {
    Navigator.pop(context);
  }

  confirm(BuildContext context, var route, var _instance, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title, style: TextStyle(color:customBlackColor)),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[Text(description, style: TextStyle(color:customBlackColor))])),
            actions: <Widget> [
              FlatButton(
                color: Colors.red,
                onPressed:() {
                  _deleteFolder(context, route, _instance);
                },
                child: Text("Удалить", style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0))
              ),
              FlatButton(
                onPressed:() {
                  _cancelDelete(context);
                },
                child: Text("Отмена"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0))
              ),
            ]
          );
        });
  }
}

class LinkDeleteDialog {

  Color customBlackColor = Color(0xff2b4754);

  _cancelDelete(BuildContext context) {
    Navigator.pop(context);
  }

  confirm(BuildContext context, var route, var snapshot, var _instanceID, int _index, int index, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title, style: TextStyle(color:customBlackColor)),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[Text(description, style: TextStyle(color:customBlackColor))])),
            actions: <Widget> [
              FlatButton(
                color: Colors.red,
                onPressed:() {
                  List _newArray = List();
                  for (var i in snapshot.data.documents[_index]['list_of_links']) {
                    _newArray.add(i);
                  }
                  _newArray.remove(_newArray[index]);
                  route.document(_instanceID).updateData({'list_of_links':_newArray});
                  Navigator.pop(context);

                },
                child: Text("Удалить", style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0))
              ),
              FlatButton(
                onPressed:() {
                  _cancelDelete(context);
                },
                child: Text("Отмена"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0))
              ),
            ]
          );
        });
  }
}
