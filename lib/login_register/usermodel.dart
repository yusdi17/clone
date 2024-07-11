class UserModel {
  String? id;
  String? username;
  String? email;
  String? password;
  String? namaDepan;
  String? namaBelakang;
  String? bio;
  String? createdAt;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.namaDepan,
      this.namaBelakang,
      this.bio,
      this.createdAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    namaDepan = json['nama_depan'];
    namaBelakang = json['nama_belakang'];
    bio = json['bio'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['nama_depan'] = namaDepan;
    data['nama_belakang'] = namaBelakang;
    data['bio'] = bio;
    data['created_at'] = createdAt;
    return data;
  }
}

List<UserModel> userList = [];