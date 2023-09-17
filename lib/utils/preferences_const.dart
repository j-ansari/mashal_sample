class Preferences {
  static String accessToken = 'accessToken';

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() => _instance;

  Preferences._internal();
}
