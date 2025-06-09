class GetnetDeviceInfo {
  final String seriallNumber;
  final String deviceModel;

  GetnetDeviceInfo({required this.seriallNumber, required this.deviceModel});

  static GetnetDeviceInfo fromJson({required Map json}) {
    return GetnetDeviceInfo(seriallNumber: json['serialNumber'], deviceModel: json['deviceModel']);
  }

  Map<String, dynamic> toJson() {
    return {'serialNumber': seriallNumber, 'deviceModel': deviceModel};
  } 
}
