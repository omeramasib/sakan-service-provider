class DakliaLawsModel {
  int? lawId;
  String? lawDescription;
  String? punishmentDescription;
  int? dakliaId;

  DakliaLawsModel(
      {this.lawId,
      this.lawDescription,
      this.punishmentDescription,
      this.dakliaId});

  DakliaLawsModel.fromJson(Map<String, dynamic> json) {
    lawId = json['law_id'];
    lawDescription = json['law_description'];
    punishmentDescription = json['punishment_description'];
    dakliaId = json['daklia_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['law_id'] = this.lawId;
    data['law_description'] = this.lawDescription;
    data['punishment_description'] = this.punishmentDescription;
    data['daklia_id'] = this.dakliaId;
    return data;
  }
}