import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aplikasi_gudang/main.dart';
import 'package:aplikasi_gudang/data/rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aplikasi_gudang/models/jenisdatabase.dart';
import 'package:aplikasi_gudang/dbhelper/dbhelper.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  double screenHeight;
  JenisDatabase dropdownValue;

  String _valDropdown;

  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<JenisDatabase> jenisdbList;  
  JenisDatabase jenisDatabase;
  // List dropdownValue2 = [];
  List<JenisDatabase> dropdownValue2 = [];
  RestDatasource restDS = new RestDatasource();

  String error='';
  // @override
  void initState() {
    super.initState();
    this.updateListView();
  }

  void showCenterShortToast(text) {
      Fluttertoast.showToast(
          msg: text,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          timeInSecForIosWeb: 1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.teal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: (loginCard(context)),
        ),
      ),
    );
  }


Widget loginCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          // margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(top: screenHeight / 4, left: 10, right: 10),
          child: Card(
            color: Colors.blue[50].withOpacity(0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Login Apps Gudang",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //       labelText: "Your Email", hasFloatingPlaceholder: true),
                  // ),
                  new TextFormField(
                    controller: emailController,
                    decoration: new InputDecoration(
                      hintText: "Username",
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //       labelText: "Password", hasFloatingPlaceholder: true),
                  // ),
                  new TextFormField(
                    controller: passwordController,
                    decoration: new InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pilih Database:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  new DropdownButton<JenisDatabase>(
                      hint: Text('Select Database'),
                      onChanged: (JenisDatabase changedValue) {
                        dropdownValue = changedValue;
                        setState(() {
                          dropdownValue;
                          // print(dropdownValue);
                        });
                      },
                      value: dropdownValue,
                      items: dropdownValue2.map((JenisDatabase value) {
                        return new DropdownMenuItem<JenisDatabase>(
                          value: value,
                          child: new Text(value.namagudang),
                        );
                      }).toList()),
                  SizedBox(
                    height: 20,
                  ),
                  new Text(this.error),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        child: Text("Login"),
                        color: Colors.grey[800],
                        textColor: Colors.white,
                        padding: EdgeInsets.only(left: 38, right: 38, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        onPressed: emailController.text == "" || passwordController.text == "" ? null
                            : () {
                                setState(() {
                                  _isLoading = true;
                                });
                                signIn(emailController.text, passwordController.text, dropdownValue);
                              },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  void updateListView() async {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) async {
      final List<JenisDatabase> jenisdbListFuture = await dbHelper.getJenisdbList();
        // print(jenisdbListFuture.length);
        setState(() {
          dropdownValue2.add(new JenisDatabase('SPAREPART-RUKO','gudang','localhost', 'gudang','http://10.1.0.46:90/GudangAPI/GudangRuko'));

          for(var item in jenisdbListFuture) {
              dropdownValue2.add(new JenisDatabase(item.jenisgudang,item.namagudang,item.servergudang, item.databasegudang,item.apigudang));
              // print(item.id);
          } 
            print(dropdownValue2);
          if(jenisdbListFuture.length==0){
            tambahServertDialog(context);
          }
          // print(dropdownValue2);
        });
    });
  }

  signIn(String email, pass, JenisDatabase dropdownValue) async {
    if(dropdownValue==null){
      showCenterShortToast("Pilih Database nya!");
      return;
    }
    Map<String,dynamic> dropdownValueMap = dropdownValue.toMap();
    // print(dropdownValueMap);
    String dropdownValueJson = jsonEncode(dropdownValueMap);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("database", dropdownValueJson);
    
    var jsonResponse;
    // var response = await restDS.login(email, pass, data);

      restDS.login(email, pass).then((res) {
        jsonResponse = res;
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          sharedPreferences.setString("token", jsonResponse['UserId']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => MainPage()),
              (Route<dynamic> route) => false);
        }
    }).catchError((Object error) =>

       setState(() {
        //  print(error);
        //  this.error = error;
        showCenterShortToast(error.toString());
      })
      
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();


  TextEditingController namaGudangController = TextEditingController();
  TextEditingController serverGudangController = TextEditingController();  
  TextEditingController databaseGudangController = TextEditingController();
  TextEditingController apiGudangController = TextEditingController(); 

   tambahServertDialog(BuildContext context) {
        //kondisi
      // if (jenisDatabase != null) {
      //   namaGudangController.text = jenisDatabase.namagudang;
      //   serverGudangController.text = jenisDatabase.servergudang;
      //   databaseGudangController.text = jenisDatabase.databasegudang;
      //   apiGudangController.text = jenisDatabase.apigudang;
      // }
      _valDropdown=null;
      namaGudangController.text = '';
      serverGudangController.text = '';
      databaseGudangController.text = '';
      apiGudangController.text = '';

        // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed:  () {
          Navigator.of(context).pop();
        },
      );
      Widget saveButton = FlatButton(
        child: Text("Save"),
        onPressed:  () {
          jenisDatabase = JenisDatabase(_valDropdown, namaGudangController.text,serverGudangController.text,databaseGudangController.text, apiGudangController.text);
          addDb(jenisDatabase);
          // this.showAlertDialog2(context);
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Tambah server"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {

          return Container(
            height:400,
            width:400,
            child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: double.infinity),
                                child: new DropdownButton(
                                      isExpanded: true,
                                      hint: Text('Jenis Gudang'),
                                      underline: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(bottom: BorderSide(color: Colors.black))
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                      onChanged: (String changedValue) {
                                        // _valDropdown = changedValue;
                                        setState(() {
                                        _valDropdown = changedValue;
                                        });
                                      },
                                      value: _valDropdown,
                                      items: <String>['PRODUK', 'SPAREPART', 'SPAREPART-RUKO'].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                    ),
                              ),
                              SizedBox(
                              height: 15,
                            ),
                          new TextFormField(
                            controller: namaGudangController,
                              decoration: new InputDecoration(
                                hintText: "Nama Gudang",
                                filled: true,
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                            //fillColor: Colors.green
                          ),
                        ),
                        SizedBox(
                              height: 15,
                            ),
                          new TextFormField(
                            controller: serverGudangController,
                          decoration: new InputDecoration(
                            hintText: "Server Gudang",
                            filled: true,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                        SizedBox(
                              height: 15,
                            ),
                          new TextFormField(
                            controller: databaseGudangController,
                          decoration: new InputDecoration(
                            hintText: "Database Gudang",
                            filled: true,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                        SizedBox(
                              height: 15,
                            ),
                          new TextFormField(
                            controller: apiGudangController,
                          decoration: new InputDecoration(
                            hintText: "API Gudang",
                            filled: true,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                    ],
              ),
              )
          );
         }
        ),
        actions: [
          cancelButton,
          saveButton,
        ],
      );

      // show the dialog
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }


  void addDb(JenisDatabase object) async {
    int result = await dbHelper.insert(object);
    if (result > 0) {
      updateListView();
    }
  }

}
