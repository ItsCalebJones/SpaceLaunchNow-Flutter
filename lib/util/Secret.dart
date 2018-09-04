class Secret {
  final String apiKey;
  Secret({this.apiKey = ""});
  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(apiKey: jsonMap["api_key"]);
  }
}