class DakliaInfoModel {
  int? userId;
  String? dakliaImage;
  String? dakliaDescription;
  int? numberOfRooms;
  int? dakliaId;

  DakliaInfoModel(
      {this.userId,
      this.dakliaImage,
      this.dakliaDescription,
      this.numberOfRooms,
      this.dakliaId});

  DakliaInfoModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    dakliaImage = json['daklia_image'];
    dakliaDescription = json['daklia_description'];
    numberOfRooms = json['numberOfRooms'];
    dakliaId = json['Daklia_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['daklia_image'] = this.dakliaImage;
    data['daklia_description'] = this.dakliaDescription;
    data['numberOfRooms'] = this.numberOfRooms;
    data['Daklia_id'] = this.dakliaId;
    return data;
  }
}