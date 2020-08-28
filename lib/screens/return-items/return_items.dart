import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:aplikasi_gudang/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:aplikasi_gudang/models/jenisdatabase.dart';
import 'package:aplikasi_gudang/models/returnitems.dart';
import 'package:aplikasi_gudang/dbhelper/dbhelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aplikasi_gudang/screens/return-items/detail_return_items/detail_return_items.dart';
import 'package:aplikasi_gudang/data/rest_ds.dart';

// This app is a stateful, it tracks the user's current choice.
class ReturnItems extends StatefulWidget {
   ReturnItems({Key key, this.title}) : super(key: key);
  final String title;

  @override
  ReturnItemsState createState() => ReturnItemsState();
}

class ReturnItemsState extends State<ReturnItems> {
  // implements AuthStateListener{
  BuildContext _ctx;
  static double screenHeight;
  SharedPreferences sharedPreferences;
  String database;
  Future panggilData;
  dynamic hasil;
  dynamic res;

  static List items = new List<ReturnItemsModel>();

  String type_trans;

  // List<dynamic> dropdownlist; 

  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<JenisDatabase> jenisdbList;  
  JenisDatabase jenisDatabase;

  List nomors=[] ;
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

validate() {
    for(var i=0; i<items.length;i++){
      if(items[i].checked == false){
        return false;
      }
    }
    return true;
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

// Future fetchData() async {
  
//     sharedPreferences = await SharedPreferences.getInstance();
    
//     database = sharedPreferences.getString("database");
//       Map data = {
//         'key': 'APITES',
//         'database': database
//       };
//       // var responseSetting = await http.post("http://10.0.2.2:90/GudangAPI/GudangRuko/GetSettings", body: data);
//       var responseSetting = await http.post("http://10.1.0.46:90/GudangAPI/GudangRuko/GetSettings", body: data);

//       hasil = json.decode(responseSetting.body);
//       //  print('tesssss');
//       // print(hasil);
//        if(hasil["token"]["isMutasi"]==1 && hasil["token"]["isFaktur"]==1){
//          type_trans = "'FK','MT'";
//        }else if(hasil["token"]["isMutasi"]==1 && hasil["token"]["isFaktur"]==0){
//          type_trans = "'MT'";
//        }else if(hasil["token"]["isMutasi"]==0 && hasil["token"]["isFaktur"]==1){
//          type_trans = "'FK'";
//        }

//     if(type_trans!="" && type_trans != null){
//         Map data = {
//           'key': 'APITES',
//           'type_trans': type_trans,
//           'database': sharedPreferences.getString("database")
//         };
//         // var response = await http.post("http://10.0.2.2:90/GudangAPI/GudangRuko/ReturnItems", body: data);
//         var response = await http.post("http://10.1.0.46:90/GudangAPI/GudangRuko/ReturnItems", body: data);
      
//       setState(() {
//         Iterable result = json.decode(response.body)['data'];
//         items = result.map((model) => ReturnItemsModel.fromJson(model)).toList();
//       });
//       print(items);
//     }else{
//       print('masuk');
//       items = [];
//     }
//     return items;
//   }


Future fetchData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // database = prefs.getString("database");
    
    hasil = await restDS.fetchSettings();

       if(hasil["isMutasi"]==1 && hasil["isFaktur"]==1){
         type_trans = "'FK','MT'";
       }else if(hasil["isMutasi"]==1 && hasil["isFaktur"]==0){
         type_trans = "'MT'";
       }else if(hasil["isMutasi"]==0 && hasil["isFaktur"]==1){
         type_trans = "'FK'";
       }

    if(type_trans!="" && type_trans != null){
      // await Future.delayed(Duration(seconds: 2));
      res =  await restDS.returnItems(type_trans);

      setState(() {
        Iterable result = res['data'];
        
        items = result.map((model) => ReturnItemsModel.fromJson(model)).toList();
        
      });
      return items;
      //     showCenterShortToast("Gagal Load Settings!");
    }
  }

//   Future saveReturnItems() async {
//     sharedPreferences = await SharedPreferences.getInstance();

//         final String jsonNomors = json.encode(nomors);
//         Map data = {
//           'key': 'APITES',
//           'nomors': jsonNomors,
//           'database': sharedPreferences.getString("database")
//         };
//         // print(data);
        
//       // var response = await http.post("http://10.0.2.2:90/GudangAPI/GudangRuko/UpdateReturn", body: data);
// var response = await http.post("http://10.1.0.46:90/GudangAPI/GudangRuko/UpdateReturn", body: data);
// // print(response);
//   if (response.statusCode == 200) {
//     hasil = response.body;
//     // print(hasil);
//     // _futureSave = hasil;
//     showCenterShortToast("Berhasil Update!");
//     fetchData();
//     // return hasil;
//   } else {
//     throw Exception('Failed to save return items');
//   }
// }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    const color = const Color(0xFF55A97A);
    screenHeight = MediaQuery.of(context).size.height;
    // print(screenHeight);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Return Items (" + items.length.toString() + ")"),
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
                                MaterialPageRoute(builder: (context) => DetailReturnItems(dataDetail: snapshot.data[index])),
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

        }
      )
      
    ),
  );

// Widget saveButton(BuildContext context) =>  new Container (
//     // padding: new EdgeInsets.all(8.0),
//     // color: new Color(0X99CC0000),
//     height: 48.0,
//     // child: new Center(
//       child: RaisedButton(
//             onPressed: validate() ? null :() {
//              FutureBuilder(
//                   future: saveReturnItems(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                      print('berhasil save');
//                     } else if (snapshot.hasError) {
//                       return Text("${snapshot.error}");
//                     }

//                    return Center(
//                       child: CircularProgressIndicator()
//                     );
//                   },
//                 );
//             },
//             child: const Text('Simpan',
//                 style: TextStyle(fontSize: 20)),
//             color: Colors.grey[800],
//             textColor: Colors.white,
//             elevation: 5,
//           ),
//     // ),
//   );
 
  Widget body(BuildContext context) => new Column(
    // This makes each child fill the full width of the screen
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      middleSection(context),
      // saveButton(context),
    ],
  );

}


 
  



