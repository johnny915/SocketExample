class UserModel {
  String uid = '';
  String userName = '';
  String deviceToken = '';
  String caller = '';
  bool isOnline = false;
  String socketId = '';

  UserModel({
    required  this.uid,
    required  this.userName,
    required  this.deviceToken,
    required  this.isOnline,
    required  this.caller,
    required  this.socketId,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    userName = json['user_name'];
    isOnline = json['isOnline'];
    deviceToken = json['device_token'];
    caller = json['caller']??"";
    socketId = json['socketId']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['uid'] = uid;
    data['user_name'] = userName;
    data['isOnline'] = isOnline;
    data['device_token'] = deviceToken;
    data['caller'] = caller;
    data['socketId'] = socketId;
    return data;
  }
}