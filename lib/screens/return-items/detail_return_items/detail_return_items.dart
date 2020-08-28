import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:aplikasi_gudang/models/jenisdatabase.dart';
import 'package:aplikasi_gudang/dbhelper/dbhelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aplikasi_gudang/data/rest_ds.dart';
import 'dart:convert';
import 'package:aplikasi_gudang/models/returnitems.dart';

// This app is a stateful, it tracks the user's current choice.
class DetailReturnItems extends StatefulWidget {
  // Declare a field that holds the Todo.
  final dataDetail;
  // In the constructor, require
  DetailReturnItems({Key key, @required this.dataDetail}) : super(key: key);

  @override
  DetailReturnItemsState createState() => DetailReturnItemsState();
}

class DetailReturnItemsState extends State<DetailReturnItems> {
  // implements AuthStateListener{
  BuildContext _ctx;

  RestDatasource restDS = new RestDatasource();

  double screenHeight;
  List dropdownValue = [];
  SharedPreferences sharedPreferences;
  String database='';
  Future panggilDetailReturnItems;
  dynamic hasil;
  dynamic res;

  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<JenisDatabase> jenisdbList;  
  JenisDatabase jenisDatabase;
   String noBukti = '';
   String nmPlg = '';
     static List items = new List<ReturnItemsModel>();
       List nomors=[] ;

  // @override
  void initState() {
    super.initState();
    // this.updateListView();
      panggilDetailReturnItems = fetchDetail();
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

Future fetchDetail() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // database = prefs.getString("database");
 
    if(widget.dataDetail != null)
    {
        noBukti = widget.dataDetail.noBukti;
        nmPlg = widget.dataDetail.nmPlg;
    }
    res =  await restDS.returnItemDetails(noBukti);
    setState(() {
      Iterable result = res['data'];
      
      items = result.map((model) => ReturnItemsModel.fromJson(model)).toList();
      
    });
    return items;

  }

  Future saveReturnItems() async {
    // sharedPreferences = await SharedPreferences.getInstance();
    // database = sharedPreferences.getString("database");

      restDS.saveReturnItems(noBukti).then((res) {
          showCenterShortToast("Berhasil Return item!");
          Navigator.pop(context);
      }).catchError((Object error) => 

        setState(() {
          showCenterShortToast("Gagal Update!");
          throw Exception('Failed to return items');
        })
        
      );

  }

 
validate() {
      for(var i=0; i<items.length;i++){
        if(items[i].checked == false){
          return true;
        }
      }
      return false;
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

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    const color = const Color(0xFF55A97A);
    screenHeight = MediaQuery.of(context).size.height;
    
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
           leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ), 
          title: new Text("Detail Return Items"),
          backgroundColor: color,
        ),
        body: 
        SingleChildScrollView(
          child:
           Container(
            height: screenHeight - 100,
            // color: Colors.amber,
            // child:(_futureSave == null)
              // ?  
              child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: Card(
                      color: Colors.blueGrey[300].withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Nomor Faktur: " + noBukti,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Nama Dealer: " + nmPlg,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                new Text('SPAREPART',
                style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                  )
                ),
                 Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                 middleSection(context),
                // Expanded(child: Container(
                //   // color: Colors.green,
                // )),
                // SizedBox(
                //               height: screenHeight/3.8,
                //             ),
               
                ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
                    child: RaisedButton(
                                    onPressed: validate() ? null
                            : () {
                                      // FutureBuilder(
                                      //     future: saveSettings(_faktur,_mutasi),
                                      //     builder: (context, snapshot) {
                                      //       // if (snapshot.hasData) {
                                      //       //   showAlertDialog2(context);
                                      //       // } else if (snapshot.hasError) {
                                      //       //   return Text("${snapshot.error}");
                                      //       // }

                                      //      return Center(
                                      //         child: CircularProgressIndicator()
                                      //       );
                                      //     },
                                      //   );
                                       setState(() {
                                          saveReturnItems();
                                        });
                                    },
                                    child: const Text('Simpan',
                                        style: TextStyle(fontSize: 20)),
                                    color: Colors.grey[800],
                                    textColor: Colors.white,
                                    elevation: 5,
                                  ),
                )
              ],
            )
            // : FutureBuilder(
            //       future: _futureSave,
            //       builder: (context, snapshot) {
            //         // if (snapshot.hasData) {
            //         //   return Text(snapshot.data);
            //         // } else
            //          if (snapshot.hasError) {
            //           return Text("${snapshot.error}");
            //         }

            //         return CircularProgressIndicator();
            //       },
            //     ),
         )
        )
        );
  }

 Widget middleSection(BuildContext context) =>  new Expanded(
  child: new Container (
      padding: new EdgeInsets.only(left:3.0 , right:3.0),
      // color: Colors.amber,
        child: FutureBuilder(
            future: panggilDetailReturnItems,
            builder: (context, snapshot) {
              // print(snapshot.data);
              if (snapshot.hasData) {
                return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return new Column(
                          children: <Widget>[
                            new Container(
                              padding: new EdgeInsets.all(8.0),
                              color: index % 2 == 0 ? Colors.grey : Colors.white,
                              child:  new CheckboxListTile(
                                  value: items[index].checked,
                                  title: new Text(items[index].kdSparepart),
                                  subtitle: new Text('Qty: '+items[index].qty.toString()),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged:(dynamic val)
                                  {
                                    ItemChange(val, index);
                                  },
                                  activeColor: Colors.green,
                                  checkColor: Colors.black,
                              )
                            ),
                            
                          ],
                        );
                  }
                );
              } else {
                return new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Text('Some data here'),
                    new Text('More stuff here'),
                  ],
                );
                // new ListView.builder(
                //   scrollDirection: Axis.vertical,
                //   shrinkWrap: true,
                //   itemBuilder: (BuildContext context, int index){
                //     return new Column(
                //         children: <Widget>[
                //         new ListTile(
                //           title: new Text('No Data added yet!',style: TextStyle(fontSize: 17, color: Colors.black)),
                //           onTap: () {},
                //         )
                //     ],
                //   );
                //   }
                // );
                
              }
            },
          )
          
    ),
  );
  

  showAlertDialog2(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("Berhasil."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeleteDialog(BuildContext context, int val) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Ya"),
      onPressed: () {
        // this.deleteDb(val);
        Navigator.of(context).pop();
      },
    );
    Widget noButton = FlatButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.of(context).pop();
       },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("Yakin untuk menghapus?"),
      actions: [
        okButton,
        noButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
