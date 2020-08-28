class JenisDatabase {
  int _id;
  String _jenisgudang;
  String _namagudang;
  String _servergudang;
  String _databasegudang;
  String _apigudang;
  JenisDatabase(this._jenisgudang, this._namagudang, this._servergudang, this._databasegudang, this._apigudang);

  JenisDatabase.fromMap(Map<String, dynamic> obj) {
    this._id = obj["id"];
    this._jenisgudang = obj["JenisGudang"];
    this._namagudang = obj["NamaGudang"];
    this._servergudang = obj["ServerGudang"];
    this._databasegudang = obj["DatabaseGudang"];
    this._apigudang = obj["ApiGudang"];
  }

  int get id => _id;
  String get jenisgudang => _jenisgudang;
  String get namagudang => _namagudang;
  String get servergudang => _servergudang;
  String get databasegudang => _databasegudang;
  String get apigudang => _apigudang;

 // setter  

  set jenisgudang(String value) {
    _jenisgudang = value;
  }

  set namagudang(String value) {
    _namagudang = value;
  }

  set servergudang(String value) {
    _servergudang = value;
  }

  set databasegudang(String value) {
    _databasegudang = value;
  }

  set apigudang(String value) {
    _apigudang = value;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    // map["id"] = _id;
    map["JenisGudang"] = _jenisgudang;
    map["NamaGudang"] = _namagudang;
    map["ServerGudang"] = _servergudang;
    map["DatabaseGudang"] = _databasegudang;
    map["ApiGudang"] = _apigudang;

    return map;
  }
}