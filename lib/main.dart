
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aplikasi_gudang/screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_gudang/screens/settings/settings.dart';
import 'package:aplikasi_gudang/screens/collect-items/collect_items.dart';
import 'package:aplikasi_gudang/screens/return-items/return_items.dart';
import 'package:aplikasi_gudang/screens/potong_stock/potong_stock.dart';
import 'package:aplikasi_gudang/data/rest_ds.dart';
import 'package:aplikasi_gudang/models/jenisdatabase.dart';
import 'package:aplikasi_gudang/dbhelper/dbhelper.dart';

void main() => runApp(GudangApp());

class GudangApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aplikasi Gudang",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(accentColor: Colors.white70),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;
  RestDatasource restDS = new RestDatasource();

  double screenWidth;
  
  dynamic hasil;
  Future takeData;
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<JenisDatabase> jenisdbList;  
  JenisDatabase jenisDatabase;
  String database;
  dynamic res = 0;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false
      );
    }else{
      takeData = getData();
    }

  }

  Future getData() async {
    // SharedPreferences prefs  = await SharedPreferences.getInstance();
    // database = prefs.getString("database");

       hasil = await restDS.fetchDashboard();
        setState(() {
          res = hasil["data"].toString();
        });
        return res;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    const color = const Color(0xFF55A97A);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: color,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
             
            },
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: 
      Container(
         child: FutureBuilder(
            future: takeData,
            builder: (context, snapshot) { 
              Widget widget = Container();
              if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(backgroundColor: Colors.black,),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.hasData) {
                     widget = dashboardBody(snapshot.data);
                  }else{
                    return new Container(
                      child: Center(child: new Text('Data Kosong'))
                    );
                  }
               } 
                return widget;
             }
            ),
        ),
      drawer: Drawer(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      DrawerHeader(
                        margin: EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                          color: color,
                        ),
                        child: Center(
                          child: Text(sharedPreferences.getString("token")),
                        ),
                      ),
                      ListTile(
                        // leading: Icon(Icons.home),
                        contentPadding: EdgeInsets.only(left:50),
                        title: Text("Settings"),
                        onTap: () {
                          Navigator.of(context).pop();
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Settings()),
                            );
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left:50),
                        title: Text("Collect Items"),
                        onTap: () {
                          Navigator.of(context).pop();
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CollectItems()),
                            ).then((val)=> checkLoginStatus());
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left:50),
                        title: Text("Return Items"),
                        onTap: () {
                            Navigator.of(context).pop();
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReturnItems()),
                            ).then((val)=> checkLoginStatus());
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left:50),
                        title: Text("Potong Stok"),
                        onTap: () {
                            Navigator.of(context).pop();
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PotongStock()),
                            ).then((val)=> checkLoginStatus());
                        },
                      ),
                      const Expanded(child: SizedBox()),
                      const Divider(height: 1.0, color: Colors.grey),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text("Log Out"),
                        onTap: () {
                          sharedPreferences.clear();
                          sharedPreferences.commit();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => LoginPage()),
                              (Route<dynamic> route) => false);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

   Container dashboardBody(data) {    
    const color = const Color(0xFF1394CE);
    var container = Container(
      color: color,
      width: screenWidth,
      height: 150,
      
      padding: EdgeInsets.only(top: 15),
      child: Center(
        
        child: Column(
        
        children: <Widget>[
           Text("Total Faktur / Mutasi Gantung",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                )
          ), 
          SizedBox(
            height: 15,
          ),
          Text(data,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                )
          ), 
          ]
        )
      )
    );
    return container;
  }

}
