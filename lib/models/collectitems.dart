class CollectItemsModel {
  String id;
  String noBukti;
  bool checked;
  String kdPlg;
  String nmPlg;
  String kdSparepart;
  int qty;

  //BUAT CONSTRUCTOR AGAR KETIKA CLASS INI DILOAD, MAKA DATA YANG DIMINTA HARUS DIPASSING SESUAI TIPE DATA YANG DITETAPKAN
  CollectItemsModel({
    this.id,
    this.noBukti,
    this.checked,
    this.kdPlg,
    this.nmPlg,
    this.kdSparepart,
    this.qty
  });
  
   CollectItemsModel.fromJson(Map json)
      : id = json['id'],
        noBukti = json['No_Bukti'],
        checked = false,
        kdPlg = json['Kd_Plg'],
        nmPlg = json['Nm_Plg'],
        kdSparepart = json['Kd_Sparepart'],
        qty = json['Qty'];

  Map toJson() {
    return {'id': id, 'noBukti': noBukti, 'checked': checked, 'kdPlg': kdPlg, 'nmPlg': nmPlg, 'kdSparepart': kdSparepart, 'qty': qty };
  }

  //FUNGSI INI UNTUK MENGUBAH FORMAT DATA DARI JSON KE FORMAT YANG SESUAI DENGAN EMPLOYEE MODEL
  // factory CollectItemsModel.fromJson(Map<String, dynamic> json) => CollectItemsModel(
  //   id: json['id'],
  //   noBukti: json['No_Bukti'],
  //   checked: false,
  // );
}