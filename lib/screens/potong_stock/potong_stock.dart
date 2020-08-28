import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:aplikasi_gudang/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:aplikasi_gudang/models/jenisdatabase.dart';
import 'package:aplikasi_gudang/models/potongstock.dart';
import 'package:aplikasi_gudang/screens/potong_stock/detail_potong_stock/detail_potong_stock.dart';
import 'package:aplikasi_gudang/dbhelper/dbhelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aplikasi_gudang/data/rest_ds.dart';

// This app is a stateful, it tracks the user's current choice.
class PotongStock extends StatefulWidget {
  @override
  PotongStockState createState() => PotongStockState();
}

class PotongStockState extends State<PotongStock> {
  // implements AuthStateListener{
  BuildContext _ctx;
  static double screenHeight;
  SharedPreferences sharedPreferences;
  String database;
  Future panggilData;
  dynamic hasil;

  static List items = new List<PotongStockModel>();

  // List<dynamic> dropdownlist; 

  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<JenisDatabase> jenisdbList;  
  JenisDatabase jenisDatabase;

  List nomors=[] ;
  dynamic res;
  
  RestDatasource restDS = new RestDatasource();

  // @override
  void initState() {
    super.initState();
     check();
  }

check() {
  panggilData = fetchData();
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

void ItemChange(bool val,int index){
    setState(() {
      items[index].checked = val;
      nomors = [];
      for(var i=0; i<items.length;i++){
        if(items[i].checked == false){
          nomors.add(items[i].noBukti);
        }
      }
    });
  }

Future fetchData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // database = prefs.getString("database");
    

      // await Future.delayed(Duration(seconds: 2));
      res =  await restDS.listPotongStock();

      setState(() {
        Iterable result = res['data'];
        
        items = result.map((model) => PotongStockModel.fromJson(model)).toList();
        
      });
      return items;
      //     showCenterShortToast("Gagal Load Settings!");
    
  }

// Future fetchData() async {
//     sharedPreferences = await SharedPreferences.getInstance();
    
//     database = sharedPreferences.getString("database");
//       // Map data = {
//       //   'key': 'APITES',
//       //   'database': database
//       // };
//       // var responseSetting = await http.post("http://10.0.2.2:90/GudangAPI/GudangRuko/GetSettings", body: data);
//       // // var response = await http.post("http://10.1.0.46:90/GudangAPI/GudangRuko/GetSettings", body: data);

//       // hasil = json.decode(responseSetting.body);
//       //  if(hasil["isMutasi"]==1 && hasil["isFaktur"]==1){
//       //    type_trans = "'FK','MT'";
//       //  }else if(hasil["isMutasi"]==1 && hasil["isFaktur"]==0){
//       //    type_trans = "'MT'";
//       //  }else if(hasil["isMutasi"]==0 && hasil["isFaktur"]==1){
//       //    type_trans = "'FK'";
//       //  }

//     // if(type_trans!="" && type_trans != null){
//         Map data = {
//           'key': 'APITES',
//           'database': sharedPreferences.getString("database")
//         };
//         // var response = await http.post("http://10.0.2.2:90/GudangAPI/GudangRuko/ListPotongStock", body: data);
//         var response = await http.post("http://10.1.0.46:90/GudangAPI/GudangRuko/ListPotongStock", body: data);
     

//       setState(() {
//         Iterable result = json.decode(response.body)['data'];
//         items = result.map((model) => PotongStockModel.fromJson(model)).toList();
//       });
//     // }else{
//     //   items = [];
//     // }
//     return items;
//   }



  @override
  Widget build(BuildContext context) {
    _ctx = context;
    const color = const Color(0xFF55A97A);
    screenHeight = MediaQuery.of(context).size.height;
    // print(screenHeight);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Potong Stok (" + items.length.toString() + ")"),
          backgroundColor: color
        ),
        body: body(_ctx)
      );
  }

 Widget middleSection(BuildContext context) =>  new Expanded(
  child: new Container (
      padding: new EdgeInsets.only(left:3.0 , right:3.0),
        child: FutureBuilder(
            future: panggilData,
            builder: (context, snapshot) {
              Widget widget;
          //  print(snapshot.hasData);
              if (snapshot.connectionState == ConnectionState.done) {
                if(snapshot.data.length>0){
                  return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        return new Column(
                              children: <Widget>[
                                new Container(
                                  padding: new EdgeInsets.all(8.0),
                                  color: index % 2 == 0 ? Colors.white : Colors.blueGrey[200],
                                  child: new ListTile(
                                    title: new Text(snapshot.data[index].noBukti),
                                    subtitle: new Text(snapshot.data[index].nmPlg),
                                    onTap: () {
                                      // Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DetailPotongStock(dataDetail: snapshot.data[index])),
                                        ).then((val)=> check());
                                    }
                                )
                                ),
                                
                              ],
                            );
                      }
                    );
                } else {
                  // print('ga masuk');
                  return new Container(
                    child: Center(child: new Text('Data Kosong'))
                  );
                }
                
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                widget = Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(backgroundColor: Colors.black,),
                  ),
                );
              } 
              return widget;

            },
          )
          
    ),
  );

 
  Widget body(BuildContext context) => new Column(
    // This makes each child fill the full width of the screen
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      middleSection(context),
    ],
  );

}


 
  



