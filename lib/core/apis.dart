class Apis {
  static final String baseUrlOnline =
      'https://petfinderapi20210113144843.azurewebsites.net';
  static final String baseURL = 'http://192.168.1.68:51117';
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

  static String avatarDirUrl =
      'https://petfinderapi20210113144843.azurewebsites.net/Content/img/uploads/';
}
