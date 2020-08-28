import 'package:aplikasi_gudang/screens/collect-items/detail_collect_items/detail_collect_items.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:aplikasi_gudang/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:aplikasi_gudang/models/jenisdatabase.dart';
import 'package:aplikasi_gudang/models/collectitems.dart';
import 'package:aplikasi_gudang/dbhelper/dbhelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aplikasi_gudang/data/rest_ds.dart';

// This app is a stateful, it tracks the user's current choice.
class CollectItems extends StatefulWidget {
   CollectItems({Key key, this.title}) : super(key: key);
  final String title;

  @override
  CollectItemsState createState() => CollectItemsState();
}

class CollectItemsState extends State<CollectItems> {
  // implements AuthStateListener{
  BuildContext _ctx;
  static double screenHeight;
  SharedPreferences sharedPreferences;
  String database;
  Future panggilData;
  dynamic hasil;
  dynamic res;

  static List items = new List<CollectItemsModel>();

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
    if(items[i].checked == true){
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
        if(items[i].checked == true){
          nomors.add(items[i].noBukti);
        }
      }
      
    });
  }

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
      
      res =  await restDS.collectItem(type_trans);
// print(res);
      setState(() {
        Iterable result = res['data'];
        
        items = result.map((model) => CollectItemsModel.fromJson(model)).toList();
        
      });
      return items;
      //     showCenterShortToast("Gagal Load Settings!");
    }
  }

//   Future saveCollectItems() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     database = sharedPreferences.getString("database");

//         final String jsonNomors = json.encode(nomors);
//         Map data = {
//           'key': 'APITES',
//           'nomors': jsonNomors,
//           'database': sharedPreferences.getString("database")
//         };
//         // print(data);
        
//       // var response = await http.post("http://10.0.2.2:90/GudangAPI/GudangRuko/UpdateCollected", body: data);
// var response = await http.post("http://10.1.0.46:90/GudangAPI/GudangRuko/UpdateCollected", body: data);
// // print(response);
//   if (response.statusCode == 200) {
//     hasil = response.body;
//     // print(hasil);
//     // _futureSave = hasil;
//     showCenterShortToast("Berhasil Update!");
//     fetchData();
//     // return hasil;
//   } else {
//     throw Exception('Failed to save collect items');
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
          title: new Text("Collect Items (" + items.length.toString()+ ")"),
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
                  // print('masuk');
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
                                    MaterialPageRoute(builder: (context) => DetailCollectItems(dataDetail: snapshot.data[index])),
                                  ).then((val)=> check());
                              }
                          )
                          ),
                          
                        ],
                      );

                    // return new Column(
                    //     children: <Widget>[
                    //       new Container(
                    //           padding: new EdgeInsets.all(8.0),
                    //           color: index % 2 == 0 ? Colors.white : Colors.blueGrey[200],
                    //           child:  new CheckboxListTile(
                    //               value: items[index].checked,
                    //               title: new Text(items[index].noBukti),
                    //               controlAffinity: ListTileControlAffinity.leading,
                    //               onChanged:(dynamic val)
                    //               {
                    //                 ItemChange(val, index);
                    //               },
                    //               activeColor: Colors.green,
                    //               checkColor: Colors.black,
                    //           )
                    //       )
                    //     ],
                    //   );
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
              // if (snapshot.hasData) {
              //   return new ListView.builder(
              //     scrollDirection: Axis.vertical,
              //     shrinkWrap: true,
              //     itemCount: snapshot.data.length,
              //     itemBuilder: (BuildContext context, int index){

              //       return new Column(
              //         children: <Widget>[
              //           new Container(
              //             padding: new EdgeInsets.all(8.0),
              //             color: index % 2 == 0 ? Colors.white : Colors.blueGrey[200],
              //             child: new ListTile(
              //               title: new Text(snapshot.data[index].noBukti),
              //               subtitle: new Text(snapshot.data[index].nmPlg),
              //               onTap: () {
              //                 // Navigator.of(context).pop();
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(builder: (context) => DetailCollectItems(dataDetail: snapshot.data[index])),
              //                   ).then((val)=> check());
              //               }
              //           )
              //           ),
                        
              //         ],
              //       );

              //     // return new Column(
              //     //     children: <Widget>[
              //     //       new Container(
              //     //           padding: new EdgeInsets.all(8.0),
              //     //           color: index % 2 == 0 ? Colors.white : Colors.blueGrey[200],
              //     //           child:  new CheckboxListTile(
              //     //               value: items[index].checked,
              //     //               title: new Text(items[index].noBukti),
              //     //               controlAffinity: ListTileControlAffinity.leading,
              //     //               onChanged:(dynamic val)
              //     //               {
              //     //                 ItemChange(val, index);
              //     //               },
              //     //               activeColor: Colors.green,
              //     //               checkColor: Colors.black,
              //     //           )
              //     //       )
              //     //     ],
              //     //   );
              //     }
              //   );
              // } else {
              //   return new Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: <Widget>[
              //       new Text('Some data here'),
              //       new Text('More stuff here'),
              //     ],
              //   );
                
              // }
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
//               FutureBuilder(
//                   future: saveCollectItems(),
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
//               //  setState(() {
//               //     _futureSave = saveCollectItems();
//               //   });
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


 
  



