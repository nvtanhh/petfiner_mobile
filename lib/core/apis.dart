class Apis {
  static final String API_BASE_URL = 'http://192.168.1.214:51117';
  static String root = '$API_BASE_URL/api';

  static String getLoginUrl = '$root/account/login';
  static String getSignUpUrl = '$root/account/register';
}
