import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:aplikasi_gudang/models/jenisdatabase.dart';
import 'package:aplikasi_gudang/dbhelper/dbhelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aplikasi_gudang/data/rest_ds.dart';

// This app is a stateful, it tracks the user's current choice.
class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  // implements AuthStateListener{
  BuildContext _ctx;

  RestDatasource restDS = new RestDatasource();

  double screenHeight;
  bool _faktur = false;
  bool _mutasi = false;
  List dropdownValue = [];
  String _valDropdown;
  SharedPreferences sharedPreferences;
  String database='';
  Future panggilData;
  Future panggilSettings;
  dynamic hasil;

  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<JenisDatabase> jenisdbList;  
  JenisDatabase jenisDatabase;

  TextEditingController namaGudangController = TextEditingController();
  TextEditingController serverGudangController = TextEditingController();  
  TextEditingController databaseGudangController = TextEditingController();
  TextEditingController apiGudangController = TextEditingController();  


  // @override
  void initState() {
    super.initState();
    this.updateListView();
      panggilSettings = fetchSettings();
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

  Future fetchSettings() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // database = prefs.getString("database");
    
      await restDS.getDatabase();
      database = restDS.namagudang;
      
      restDS.fetchSettings().then((res) {
        setState(() {
          hasil = res;
        });

        if(hasil["isMutasi"]==1){
          _mutasi = true;
        }else{
          _mutasi = false;
        }
        if(hasil["isFaktur"]==1){
          _faktur = true;
        }else{
          _faktur = false;
        }
        return hasil;
      }).catchError((Object error) => 

        setState(() {
          showCenterShortToast("Gagal Load Settings!");
          throw Exception('Failed to fetch settings');
        })
        
      );
  }

  Future saveSettings(bool _isFaktur, bool _isMutasi) async {
    var isFaktur;
    var isMutasi;

      if(_isFaktur==true){
        isFaktur = "1";
      }else{
        isFaktur = "0";
      }
      if(_isMutasi==true){
        isMutasi = "1";
      }else{
        isMutasi = "0";
      }
      restDS.saveSettings(isFaktur, isMutasi).then((res) {
          showCenterShortToast("Berhasil Update!");
      }).catchError((Object error) => 

        setState(() {
          showCenterShortToast("Gagal Update!");
          throw Exception('Failed to save settings');
        })
        
      );
}
 

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    const color = const Color(0xFF55A97A);
    screenHeight = MediaQuery.of(context).size.height;
    
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Setting"),
          backgroundColor: color,
          actions: <Widget>[
          FlatButton(
            onPressed: () {
            },
            child: 
             Text(
                database,
                style: TextStyle(
                  color: Colors.white
                ),
              )
          ),
        ],
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
                      color: Colors.blue[50].withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 8,
                      margin: const EdgeInsets.all(15.0),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Sistem Pengambilan Barang",
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SwitchListTile(
                                title: const Text('Faktur'),
                                value: _faktur,
                                onChanged: (bool value) { setState(() { _faktur = value; }); },
                                secondary: const Icon(Icons.note),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                             Align(
                              alignment: Alignment.centerLeft,
                              child: SwitchListTile(
                                title: const Text('Mutasi'),
                                value: _mutasi,
                                onChanged: (bool value) { setState(() { _mutasi = value; }); },
                                secondary: const Icon(Icons.note),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.blue[50].withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 8,
                    margin: const EdgeInsets.all(15.0),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Align(
                            alignment: Alignment.topCenter,
                            child: RaisedButton(
                              onPressed: () {
                                tambahServertDialog(_ctx);
                              },
                              child: const Text('Tambah Server, Database',
                                  style: TextStyle(fontSize: 17)),
                              color: Colors.blue[500],
                              textColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: FutureBuilder<List>(
                              future: dbHelper.getJenisdbList(),
                              initialData: List(),
                              builder: (context, snapshot) {
                                  return snapshot.data.isEmpty ?
                                    new ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(10.0),
                                      itemCount: 1,
                                      itemBuilder: (BuildContext context, int index) {
                                        return new Column(
                                          children: <Widget>[
                                            new Container(
                                              decoration: 
                                                ShapeDecoration(
                                                  color: index % 2 == 0 ? Colors.grey : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                              ),
                                              padding: new EdgeInsets.all(8.0),
                                              // color: index % 2 == 0 ? Colors.grey : Colors.white,
                                              child: new ListTile(
                                                title: new Text('Belum ada Data!',style: TextStyle(fontSize: 17)),
                                                onTap: () {},
                                              ),
                                            ),
                                          ]
                                        );
                                      },
                                    )
                                  : 
                                    new ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(10.0),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return new Column(
                                          children: <Widget>[
                                            new Container(
                                              padding: new EdgeInsets.all(8.0),
                                              // color: index % 2 == 0 ? Colors.grey[400] : null,
                                              decoration: 
                                                ShapeDecoration(
                                                  color: index % 2 == 0 ? Colors.grey[400] : null,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                              ),
                                              child: _buildRow(snapshot.data[index])
                                            ),
                                          ]
                                        );
                                      },
                                    );
                              },
                            )
                          ),
                           ),
                          ]
                        )
                      )
                ),
              ),
                ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
                    child: RaisedButton(
                                    onPressed: () {
                                       setState(() {
                                          saveSettings(_faktur,_mutasi);
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
         )
        )
        );
  }

  //buat DB
  void addDb(JenisDatabase object) async {
    int result = await dbHelper.insert(object);
    if (result > 0) {
      updateListView();
    }
  }

  void deleteDb(int id) async {
    int result = await dbHelper.delete(id);
    if (result > 0) {
      updateListView();
    }
  }

  //buat DB
  void updateDb(int id,JenisDatabase object) async {
    int result = await dbHelper.update(id,object);
    if (result > 0) {
      updateListView();
    }
  }

  void dropDb() async {
    int result = await dbHelper.dropDb();
    if (result > 0) {
      showCenterShortToast('Berhasil drop table');
    }
  }
      //update isi
  void updateListView() async {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) async {
      final List<JenisDatabase> jenisdbListFuture = await dbHelper.getJenisdbList();
        setState(() {
          dropdownValue = [];
         for(var item in jenisdbListFuture ) {
            dropdownValue.add(item.namagudang);
          } 
        });
    });
  }

  Widget _buildRow(JenisDatabase jenis) {
    return new ListTile(
      title: new Text(jenis.namagudang,style: TextStyle(fontSize: 17)),
      trailing: ButtonTheme(
            minWidth: 30.0,
            height: 30.0,
              child:RaisedButton(
                onPressed: () {
                  showDeleteDialog(_ctx, jenis.id);
                },
                child: const Text('X',
                    style: TextStyle(fontSize: 17)),
                color: Colors.red[500],
                textColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
         ),
         
      onTap: () {
        updateServertDialog(_ctx, jenis);
      },
    );
  }

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

  updateServertDialog(BuildContext context, JenisDatabase jenisDatabase) {
        //kondisi
      // if (jenisDatabase != null) {
      //   namaGudangController.text = jenisDatabase.namagudang;
      //   serverGudangController.text = jenisDatabase.servergudang;
      //   databaseGudangController.text = jenisDatabase.databasegudang;
      //   apiGudangController.text = jenisDatabase.apigudang;
      // }
      JenisDatabase editedJenisDatabase;
      
      _valDropdown = jenisDatabase.jenisgudang;
      namaGudangController.text = jenisDatabase.namagudang;
      serverGudangController.text = jenisDatabase.servergudang;
      databaseGudangController.text = jenisDatabase.databasegudang;
      apiGudangController.text = jenisDatabase.apigudang;

        // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed:  () {
          Navigator.of(context).pop();
        },
      );
      Widget saveButton = FlatButton(
        child: Text("Update"),
        onPressed:  () {
          editedJenisDatabase = JenisDatabase(_valDropdown, namaGudangController.text,serverGudangController.text,databaseGudangController.text, apiGudangController.text);
          updateDb(jenisDatabase.id,editedJenisDatabase);
          // this.showAlertDialog2(context);
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Update server"),
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }

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
        this.deleteDb(val);
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
