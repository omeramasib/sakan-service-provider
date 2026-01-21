class DakliaVerifyAccountModel {
  int? dakliaId;
  String? dakliaLicense;
  String? ownerIdenficationCard;

  DakliaVerifyAccountModel(
      {this.dakliaId, this.dakliaLicense, this.ownerIdenficationCard});

  DakliaVerifyAccountModel.fromJson(Map<String, dynamic> json) {
    dakliaId = json['Daklia_id'];
    dakliaLicense = json['daklia_license'];
    ownerIdenficationCard = json['owner_idenfication_card'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Daklia_id'] = this.dakliaId;
    data['daklia_license'] = this.dakliaLicense;
    data['owner_idenfication_card'] = this.ownerIdenficationCard;
    return data;
  }
}