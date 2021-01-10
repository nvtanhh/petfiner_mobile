class User {
  String id, name, email, bio, phoneNumber, avatar;
  User(this.id, this.name, this.bio, this.phoneNumber, this.avatar);

  User.empty() {
    this.id = '';
    this.name = 'Empty User';
    this.email = '';
    this.bio = '';
    this.phoneNumber = '';
    this.avatar = 'assets/images/sample/avt.jpg';
  }
}
