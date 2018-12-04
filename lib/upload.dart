import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';



class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

Future<bool> saveNamePreferences(String count) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("count", count);
  return pref.commit();
}

class _UploadState extends State<Upload> {
  GlobalKey<FormState> key = new GlobalKey();
  TextEditingController code = new TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var count;
  File _image;
  var tex=0;
  var cat, rack, shelf;
  Future getNamePref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      this.cat = pref.getString("cat");
      this.rack = pref.getString("rack");
      this.shelf = pref.getString("shelf");
    });
  }
 getImageCamera() async {
   setState(() {
      this.tex = 1;
    });
    var imagefile = await ImagePicker.pickImage(source: ImageSource.camera);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    img.Image image = img.decodeImage(imagefile.readAsBytesSync());
    img.Image smallerImage = img.copyResize(image, 500);
    var compressImgCam = new File("$path/${this.cat}_${this.code.text}.jpg")
      ..writeAsBytesSync(img.encodeJpg(smallerImage, quality: 50));

    setState(() {
this.tex=2;
      _image = compressImgCam;
    });
  }
  @override
  void initState() {
    super.initState();
    getNamePref();
  }
show(){
  setState(() {
      count = code.text;
    });
}


 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("upload"),
      ),
      // body: 
      body:new SingleChildScrollView(
        child: new Container(
        child: new Column(
          children: <Widget>[
            new Text(this.cat),
            new Text(this.rack),
            new Text(this.shelf),
            new Form(
              key: key,
              child: new TextFormField(
                controller: code,
                decoration: new InputDecoration(labelText: "book code"),
                validator: (String value) {
                  if (value.length<=0) {
                    return "Enter code";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
              ),

            ),
            new MaterialButton(
              child: new Text("show"),
              onPressed: show,
            ),
            new Text(count==null?"":count),
             new Center(
                      child: _image == null 
                          ? new Text("No Image Selected")
                          : this.tex == 1
                              ? new Center(
                                  child: new Column(children: <Widget>[
                                  new Text(
                                      "Please wait your image \nis being compressed"),
                                ]))
                              : Image.file(_image),
                    ),
                    new MaterialButton(
                      child: new Text("click"),
                      onPressed: getImageCamera,
                    ),
                    new CupertinoButton(
                      child: new Text("upload"),
                      onPressed: (){
                        upload(_image);
                      },
                    ),
                    
          ],
        ),
      ),
      ),
    );
  }

  Future upload(File imagefile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imagefile.openRead()));
    var length = await imagefile.length();
    var url = Uri.parse("http://bookshareindia.com/imgres.php");

    var request = new http.MultipartRequest("POST", url);
    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imagefile.path));
    request.fields['cat'] = this.cat;
    request.fields['rack'] = this.rack;
    request.fields['shelf'] = this.shelf;
     request.fields['code'] = this.code.text;

    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 200) {
      // print("image uploaded");
     
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Successfully added book to your collection"),
            duration: new Duration(seconds: 3),
          ));
    } else {
      // print("image not uploaded");
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Cannot add book to your collection"),
            duration: new Duration(seconds: 3),
          ));
    }
  }
}
