class PotongStockModel {
  String id;
  String noBukti;
  String kdPlg;
  String nmPlg;
  String kdSparepart;
  int qty;
  bool checked;

  //BUAT CONSTRUCTOR AGAR KETIKA CLASS INI DILOAD, MAKA DATA YANG DIMINTA HARUS DIPASSING SESUAI TIPE DATA YANG DITETAPKAN
  PotongStockModel({
    this.id,
    this.noBukti,
    this.kdPlg,
    this.nmPlg,
    this.kdSparepart,
    this.qty,
    this.checked
  });
  
   PotongStockModel.fromJson(Map json)
      : id = json['id'],
        noBukti = json['No_Bukti'],
        kdPlg = json['Kd_Plg'],
        nmPlg = json['Nm_Plg'],
        kdSparepart = json['Kd_Sparepart'],
        qty = json['Qty'],
        checked = false;

  Map toJson() {
    return {'id': id, 'noBukti': noBukti, 'kdPlg': kdPlg, 'nmPlg': nmPlg, 'kdSparepart': kdSparepart, 'qty': qty, 'checked': checked};
  }

  //FUNGSI INI UNTUK MENGUBAH FORMAT DATA DARI JSON KE FORMAT YANG SESUAI DENGAN EMPLOYEE MODEL
  // factory PotongStockModel.fromJson(Map<String, dynamic> json) => PotongStockModel(
  //   id: json['id'],
  //   noBukti: json['No_Bukti'],
  //   checked: false,
  // );
}