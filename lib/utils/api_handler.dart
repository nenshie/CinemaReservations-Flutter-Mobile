class BaseAPI {
  static const String ipPort = "10.0.2.2:7039";
  static const String base = "https://$ipPort";

  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}
