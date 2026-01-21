class RoomFeaturesModel {
  int? featureId;
  String? featureName;
  String? featureDescription;
  int? roomId;

  RoomFeaturesModel(
      {this.featureId, this.featureName, this.featureDescription, this.roomId});

  RoomFeaturesModel.fromJson(Map<String, dynamic> json) {
    featureId = json['feature_id'];
    featureName = json['feature_name'];
    featureDescription = json['feature_description'];
    roomId = json['room_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feature_id'] = this.featureId;
    data['feature_name'] = this.featureName;
    data['feature_description'] = this.featureDescription;
    data['room_id'] = this.roomId;
    return data;
  }
}