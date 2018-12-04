import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testproj/upload.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}
Future<bool> saveNamePreferences(String category,rack,shelf) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("cat", category);
  pref.setString("rack", rack);
  pref.setString("shelf", shelf);
  return pref.commit();
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _SelectdType,_SelectdType1,_SelectdType2;
  var category,rack,shelf;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title:new Text("upload"),),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new DropdownButton<String>(
  items: <String>['ACADAMIC','COMMERCE','ENGINEERING IT','ENTRANCE','GK','HINDI','KIDS','MANAGEMENT','NON-FICTION ENGLISH','NOVELS ENGLISH','SCIENCE'].map((String value) {
    return new DropdownMenuItem<String>(
      value: value,
      child: new Text(value),
    );
  }).toList(),
  hint:Text(_SelectdType1==null?"":_SelectdType1),
  onChanged: (String val) {
    setState(() {
          this.category=val;
    _SelectdType1=val;
        });
    
  },
),
new DropdownButton<String>(
  items: <String>['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q'].map((String value) {
    return new DropdownMenuItem<String>(
      value: value,
      child: new Text(value),
    );
  }).toList(),
              hint:Text(_SelectdType==null?"":_SelectdType),

  onChanged: (String val) {
    setState(() {
           this.rack=val;
_SelectdType=val;
        });
       
  },
),new DropdownButton<String>(
  items: <String>['1','2','3','4','5'].map((String value) {
    return new DropdownMenuItem<String>(
      value: value,
      child: new Text(value),
    );
  }).toList(),
  hint:Text(_SelectdType2==null?"":_SelectdType2),
  onChanged: (String val) {
    setState(() {
          this.shelf=val;
_SelectdType2=val;
        });
        
  },
),
new MaterialButton(
  child: new Text("submit"),
  onPressed: (){
setState(() {
  saveNamePreferences(this.category, this.rack, this.shelf);
});
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new Upload()));
  },
),
          ],
        ),
      ),
    );
  }
}
