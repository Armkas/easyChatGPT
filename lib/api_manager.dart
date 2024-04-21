import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class APIManager {
  String apiKey = "";
  static const int maxTokens = 100;  // 示例中的最大令牌数，根据需要调整

  void setApiKey(String key) {
    apiKey = key;
  }

  Future<String> askGPT(String prompt, [int start = 0]) async {
    if (prompt.length <= maxTokens) {
      return _sendRequest(prompt);
    } else {
      String part = prompt.substring(start, start + maxTokens);
      int lastSpace = part.lastIndexOf(' ');
      part = part.substring(0, lastSpace); // 尽可能按完整的单词分割

      return _sendRequest(part).then((response) {
        return askGPT(prompt, start + lastSpace + 1).then((nextResponse) {
          return response + nextResponse;
        });
      });
    }
  }

  Future<String> _sendRequest(String prompt) async {
    var url = Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions');
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
      throw Exception('Failed to load data with status code: ${response.statusCode}');
    }
  }
}

class ChatModel with ChangeNotifier {
  final APIManager _apiManager;
  List<String> _messages = [];

  ChatModel(this._apiManager);

  List<String> get messages => _messages;

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

