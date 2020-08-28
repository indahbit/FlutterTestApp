import 'dart:async';

import 'package:aplikasi_gudang/utils/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:aplikasi_gudang/models/jenisdatabase.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();

 // static final BASE_URL = "http://10.0.2.2:90/GudangAPI/GudangRuko";
  //  static final BASE_URL = "http://10.1.0.46:90/GudangAPI/GudangRuko";
  String _namagudang;
  String _baseurl;
  String _serverdatabase;
  String _namadatabase;
  String _jenisgudang ;
  String _database = "";
  static final APIkey = "APITES"; 

  String get namagudang {
    return _namagudang;
  }

  String get baseurl {
    return _baseurl;
  }

  String get serverdatabase {
    return _serverdatabase;
  }

  String get namadatabase {
    return _namadatabase;
  }

  String get jenisgudang {
    return _jenisgudang;
  }

  // int get count {
  //   return _count;
  // }
  
//get value from shared preferences
  getDatabase() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    
    _database = pref.getString("database");

    dynamic databaseDecode = jsonDecode(_database);
    final databaseValue = JenisDatabase.fromMap(databaseDecode);

    _namagudang = databaseValue.namagudang ?? null;
    _baseurl = databaseValue.apigudang ?? null;
    _serverdatabase = databaseValue.servergudang ?? null;
    _namadatabase = databaseValue.databasegudang ?? null;
    _jenisgudang = databaseValue.jenisgudang ?? null;
  }

//*login*******************************************************************
  Future<dynamic> login(String username, String password) async {
    await getDatabase();

    Map data = {
      'userid': username,
      'password': password,
      'key': APIkey,
      'database': _namadatabase,
      'server' : _serverdatabase,
      'jenisgudang' : _jenisgudang
    };
    return _netUtil.post(_baseurl + "/Login", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res['error']==true) throw new Exception(res['error_msg']);
        
        return res;
    });
  }

//******************************************************************* */

//*Setting*****************************************************************
  Future<dynamic> saveSettings(isFaktur, isMutasi) async {
  await getDatabase();

    Map data = {
      'key': APIkey,
      'isFaktur': isFaktur,
      'isMutasi': isMutasi,
      'database': _namadatabase,
      'server' : _serverdatabase,
      'jenisgudang' : _jenisgudang
    };

    return _netUtil.post(_baseurl + "/SaveSettings", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
  }

  Future<dynamic> fetchSettings() async {
  await getDatabase();

      Map data = {
        'key': APIkey,
        'database': _namadatabase,
        'server' : _serverdatabase,
        'jenisgudang' : _jenisgudang
      };

    return await _netUtil.post(_baseurl + "/GetSettings", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
  }
//*************************************************************************** */

//*Dashboard*****************************************************************

  Future<dynamic> fetchDashboard() async {
  await getDatabase();
      Map data = {
        'key': APIkey,
        'database': _namadatabase,
        'server' : _serverdatabase,
        'jenisgudang' : _jenisgudang
      };

    return _netUtil.post(_baseurl + "/TotalFakturGantung", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
  }
//*************************************************************************** */

//*Collect Item*****************************************************************
Future<dynamic> collectItem(typetrans) async {
await getDatabase();

    Map data = {
      'key': APIkey,
      'type_trans': typetrans,
      'database': _namadatabase,
      'server' : _serverdatabase,
      'jenisgudang' : _jenisgudang
    };

    return await _netUtil.post(_baseurl + "/CollectItems", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
  }

Future<dynamic> collectItemDetails(noBukti) async {
await getDatabase();

    Map data = {
      'key': APIkey,
      'nomor': noBukti,
      'database': _namadatabase,
      'server' : _serverdatabase,
      'jenisgudang' : _jenisgudang
    };

    return await _netUtil.post(_baseurl + "/CollectItemDetails", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
  }

  Future<dynamic> saveCollectItems(noBukti) async {
  await getDatabase();

    Map data = {
      'key': APIkey,
      'nomor': noBukti,
      'database': _namadatabase,
      'server' : _serverdatabase,
      'jenisgudang' : _jenisgudang
    };

    return _netUtil.post(_baseurl + "/UpdateCollected", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
  }

//****************************************************************************** */

//*Return Item*****************************************************************
Future<dynamic> returnItems(typetrans) async {
await getDatabase();

    Map data = {
      'key': APIkey,
      'type_trans': typetrans,
      'database': _namadatabase,
      'server' : _serverdatabase,
      'jenisgudang' : _jenisgudang
    };

    return await _netUtil.post(_baseurl + "/ReturnItems", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
  }

Future<dynamic> returnItemDetails(noBukti) async {
await getDatabase();

    Map data = {
      'key': APIkey,
      'nomor': noBukti,
      'database': _namadatabase,
      'server' : _serverdatabase,
      'jenisgudang' : _jenisgudang
    };

    return await _netUtil.post(_baseurl + "/ReturnItemDetails", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
  }

  Future<dynamic> saveReturnItems(noBukti) async {
  await getDatabase();

    Map data = {
      'key': APIkey,
      'nomor': noBukti,
      'database': _namadatabase,
      'server' : _serverdatabase,
      'jenisgudang' : _jenisgudang
    };

    return _netUtil.post(_baseurl + "/UpdateReturn", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
  }

//****************************************************************************** */

//*Potong Stock*****************************************************************
Future<dynamic> fetchDetailPotongStock(nobukti) async {
await getDatabase();

      Map data = {
        'nomor': nobukti,
        'key': APIkey,
        'database': _namadatabase,
        'server' : _serverdatabase,
        'jenisgudang' : _jenisgudang
      };

    return _netUtil.post(_baseurl + "/PotongStockItemDetails", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
}

Future<dynamic> listPotongStock() async {
await getDatabase();

      Map data = {
        'key': APIkey,
        'database': _namadatabase,
        'server' : _serverdatabase,
        'jenisgudang' : _jenisgudang
      };

    return _netUtil.post(_baseurl + "/ListPotongStock", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
}

Future<dynamic> potongStock(noBukti) async {
await getDatabase();

    Map data = {
      'key': APIkey,
      'nomor': noBukti,
      'database': _namadatabase,
      'server' : _serverdatabase,
      'jenisgudang' : _jenisgudang
    };

    return _netUtil.post(_baseurl + "/PotongStock", headers: {
      "Content-Type":"application/json",
      "Accept": "application/json"
      },
      body: data).then((dynamic res) {
        if(res["error"]==true) throw new Exception(res["error_msg"]);
        return res;
    });
  }
//*************************************************************************** */

}