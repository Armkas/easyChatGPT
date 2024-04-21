import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class APIManager {
  String apiKey = "";

  void setApiKey(String key) {
    apiKey = key;
  }

  Future<String> askGPT(String prompt) async {
    var url = Uri.parse(
        'https://api.openai.com/v1/engines/davinci-codex/completions');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        'prompt': prompt,
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['choices'][0]['text'] as String;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Unauthorized: Check your API Key');
    } else {
      throw Exception(
          'Failed to load data with status code: ${response.statusCode}');
    }
  }
}

class ChatModel with ChangeNotifier {
  APIManager _apiManager;
  List<String> _messages = [];

  ChatModel(this._apiManager);

  List<String> get messages => _messages;

  void updateAPIManager(APIManager apiManager) {
    _apiManager = apiManager;
    notifyListeners();
  }

  void sendMessage(String text) {
    _messages.add("User: $text");
    notifyListeners();
    _apiManager.askGPT(text).then((response) {
      _messages.add("GPT: $response");
      notifyListeners();
    }).catchError((error) {
      _messages.add("Error: $error");
      notifyListeners();
    });
  }
}
