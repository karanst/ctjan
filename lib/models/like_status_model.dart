/// response_code : "1"
/// message : "get data succesfully"
/// status : "success"
/// data : [{"id":"7","name":"2","description":"2","date":"0000-00-00","img":"","group_id":"5","user_id":"2","like_status":"0","end_date":"","start_date":"","post_type":"3"}]

class LikeStatusModel {
  LikeStatusModel({
      String? responseCode, 
      String? message, 
      String? status, 
      List<Data>? data,}){
    _responseCode = responseCode;
    _message = message;
    _status = status;
    _data = data;
}

  LikeStatusModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _message;
  String? _status;
  List<Data>? _data;
LikeStatusModel copyWith({  String? responseCode,
  String? message,
  String? status,
  List<Data>? data,
}) => LikeStatusModel(  responseCode: responseCode ?? _responseCode,
  message: message ?? _message,
  status: status ?? _status,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get message => _message;
  String? get status => _status;
  List<Data>? get data => _data;

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

/// id : "7"
/// name : "2"
/// description : "2"
/// date : "0000-00-00"
/// img : ""
/// group_id : "5"
/// user_id : "2"
/// like_status : "0"
/// end_date : ""
/// start_date : ""
/// post_type : "3"

class Data {
  Data({
      String? id, 
      String? name, 
      String? description, 
      String? date, 
      String? img, 
      String? groupId, 
      String? userId, 
      String? likeStatus, 
      String? endDate, 
      String? startDate, 
      String? postType,}){
    _id = id;
    _name = name;
    _description = description;
    _date = date;
    _img = img;
    _groupId = groupId;
    _userId = userId;
    _likeStatus = likeStatus;
    _endDate = endDate;
    _startDate = startDate;
    _postType = postType;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _date = json['date'];
    _img = json['img'];
    _groupId = json['group_id'];
    _userId = json['user_id'];
    _likeStatus = json['like_status'];
    _endDate = json['end_date'];
    _startDate = json['start_date'];
    _postType = json['post_type'];
  }
  String? _id;
  String? _name;
  String? _description;
  String? _date;
  String? _img;
  String? _groupId;
  String? _userId;
  String? _likeStatus;
  String? _endDate;
  String? _startDate;
  String? _postType;
Data copyWith({  String? id,
  String? name,
  String? description,
  String? date,
  String? img,
  String? groupId,
  String? userId,
  String? likeStatus,
  String? endDate,
  String? startDate,
  String? postType,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  date: date ?? _date,
  img: img ?? _img,
  groupId: groupId ?? _groupId,
  userId: userId ?? _userId,
  likeStatus: likeStatus ?? _likeStatus,
  endDate: endDate ?? _endDate,
  startDate: startDate ?? _startDate,
  postType: postType ?? _postType,
);
  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get date => _date;
  String? get img => _img;
  String? get groupId => _groupId;
  String? get userId => _userId;
  String? get likeStatus => _likeStatus;
  String? get endDate => _endDate;
  String? get startDate => _startDate;
  String? get postType => _postType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['date'] = _date;
    map['img'] = _img;
    map['group_id'] = _groupId;
    map['user_id'] = _userId;
    map['like_status'] = _likeStatus;
    map['end_date'] = _endDate;
    map['start_date'] = _startDate;
    map['post_type'] = _postType;
    return map;
  }

}