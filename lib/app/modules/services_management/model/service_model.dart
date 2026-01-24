class ServiceModel {
  int? serviceId;
  String? serviceName;
  String? serviceDescription;
  String? serviceType;
  bool? isAvailable;
  double? servicePrice;
  int? dakliaId;

  ServiceModel(
      {this.serviceId,
      this.serviceName,
      this.serviceDescription,
      this.serviceType,
      this.isAvailable,
      this.servicePrice,
      this.dakliaId});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    serviceDescription = json['service_description'];
    serviceType = json['service_type'];
    isAvailable = json['isAvailable'];
    servicePrice = json['service_price'];
    dakliaId = json['daklia_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['service_description'] = this.serviceDescription;
    data['service_type'] = this.serviceType;
    data['isAvailable'] = this.isAvailable;
    data['service_price'] = this.servicePrice;
    data['daklia_id'] = this.dakliaId;
    return data;
  }
}
