/// response_code : "1"
/// message : "Get Group Data"
/// status : "success"
/// data : [{"id":"4","name":"fghfgghfgh","title":"fghfgh","pincode":"452002,452005,452009,452013","image":"1678977405Screenshot3.png","status":"1","description":"gfhgfh"},{"id":"6","name":"Newtttt","title":"Test","pincode":"452002,452004,789456","image":"","status":"1","description":""}]

class GroupListModel {
  GroupListModel({
      String? responseCode, 
      String? message, 
      String? status, 
      List<GroupList>? data,}){
    _responseCode = responseCode;
    _message = message;
    _status = status;
    _data = data;
}

  GroupListModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(GroupList.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _message;
  String? _status;
  List<GroupList>? _data;
GroupListModel copyWith({  String? responseCode,
  String? message,
  String? status,
  List<GroupList>? data,
}) => GroupListModel(  responseCode: responseCode ?? _responseCode,
  message: message ?? _message,
  status: status ?? _status,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get message => _message;
  String? get status => _status;
  List<GroupList>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    map['message'] = _message;
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "4"
/// name : "fghfgghfgh"
/// title : "fghfgh"
/// pincode : "452002,452005,452009,452013"
/// image : "1678977405Screenshot3.png"
/// status : "1"
/// description : "gfhgfh"

class GroupList {
  GroupList({
      String? id, 
      String? name, 
      String? title, 
      String? pincode, 
      String? image, 
      String? status, 
      String? description,}){
    _id = id;
    _name = name;
    _title = title;
    _pincode = pincode;
    _image = image;
    _status = status;
    _description = description;
}

  GroupList.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _title = json['title'];
    _pincode = json['pincode'];
    _image = json['image'];
    _status = json['status'];
    _description = json['description'];
  }
  String? _id;
  String? _name;
  String? _title;
  String? _pincode;
  String? _image;
  String? _status;
  String? _description;
GroupList copyWith({  String? id,
  String? name,
  String? title,
  String? pincode,
  String? image,
  String? status,
  String? description,
}) => GroupList(  id: id ?? _id,
  name: name ?? _name,
  title: title ?? _title,
  pincode: pincode ?? _pincode,
  image: image ?? _image,
  status: status ?? _status,
  description: description ?? _description,
);
  String? get id => _id;
  String? get name => _name;
  String? get title => _title;
  String? get pincode => _pincode;
  String? get image => _image;
  String? get status => _status;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['title'] = _title;
    map['pincode'] = _pincode;
    map['image'] = _image;
    map['status'] = _status;
    map['description'] = _description;
    return map;
  }

}