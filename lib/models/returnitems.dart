class ReturnItemsModel {
  String id;
  String noBukti;
  bool checked;
  String kdPlg;
  String nmPlg;
  String kdSparepart;
  int qty;

  //BUAT CONSTRUCTOR AGAR KETIKA CLASS INI DILOAD, MAKA DATA YANG DIMINTA HARUS DIPASSING SESUAI TIPE DATA YANG DITETAPKAN
  ReturnItemsModel({
    this.id,
    this.noBukti,
    this.checked,
    this.kdPlg,
    this.nmPlg,
    this.kdSparepart,
    this.qty
  });
  
   ReturnItemsModel.fromJson(Map json)
      : id = json['id'],
        noBukti = json['No_Bukti'],
        checked = true,
        kdPlg = json['Kd_Plg'],
        nmPlg = json['Nm_Plg'],
        kdSparepart = json['Kd_Sparepart'],
        qty = json['Qty'];

  Map toJson() {
    return {'id': id, 'noBukti': noBukti, 'checked': checked, 'kdPlg': kdPlg, 'nmPlg': nmPlg, 'kdSparepart': kdSparepart, 'qty': qty};
  }

  //FUNGSI INI UNTUK MENGUBAH FORMAT DATA DARI JSON KE FORMAT YANG SESUAI DENGAN EMPLOYEE MODEL
  // factory ReturnItemsModel.fromJson(Map<String, dynamic> json) => ReturnItemsModel(
  //   id: json['id'],
  //   noBukti: json['No_Bukti'],
  //   checked: false,
  // );
}