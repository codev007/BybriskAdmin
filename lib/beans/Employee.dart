class Employee {
  String id;
  String name;
  String email;
  String mobile;
  String address;
  String status;
  List<PincodeList> pincodeList;

  Employee(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.address,
        this.status,
        this.pincodeList});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    address = json['address'];
    status = json['status'];
    if (json['pincodeList'] != null) {
      pincodeList = new List<PincodeList>();
      json['pincodeList'].forEach((v) {
        pincodeList.add(new PincodeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['status'] = this.status;
    if (this.pincodeList != null) {
      data['pincodeList'] = this.pincodeList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PincodeList {
  String pincode;
  int id;

  PincodeList({this.pincode, this.id});

  PincodeList.fromJson(Map<String, dynamic> json) {
    pincode = json['pincode'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pincode'] = this.pincode;
    data['id'] = this.id;
    return data;
  }
}