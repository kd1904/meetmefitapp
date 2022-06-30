class UserModel {
  String? uid;
  String? email;
  String? name;
  String? about;
  String? profilePic;

  UserModel({this.uid, this.email, this.name, this.about, this.profilePic});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      about: map['about'],
      profilePic: map['profilePic'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'about': about,
      'profilePic': profilePic,
    };
  }
}
