class Apis {
//   static final String baseUrlOnline =
//       'https://petfinderapi20210113144843.azurewebsites.net';
  static final String baseURL = 'http://192.168.1.17:51117';
  // static final String baseURL = baseUrlOnline;
  static String root = '$baseURL/api';

  static String getLoginUrl = '$root/account/login';
  static String getSignUpUrl = '$root/account/register';
  static String forgotPassUrl = '$root/account/forgotpassword';
  static String changePasswordUrl = '$root/account/changepass';

  static String getPostUrl = '$root/posts';
  static String getUserInfo = '$root/account/getuser';
  static String getMyPets = '$root/users/pets';
  static String getMyPosts = '$root/posts/foruser';

  static String avatarDirUrl = '$baseURL/Content/img/uploads/';

  static var uploadImageUrl = '$root/images/post/';
  static var uploadAvatarUrl = '$root/images/avatar/';

  static var uploadPost = '$root/posts/foruser/';
  static var deletePost = '$root/posts/'; // DELETE
  static var editPost = '$root/posts/foruser/'; // PUT

  static var createPet = '$root/users/pets'; // POST
  static var deletePet = '$root/users/pets/'; // DELETE
  static var editPet = '$root/users/pets/'; // PUT
}
