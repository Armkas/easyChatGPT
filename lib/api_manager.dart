import 'package:http/http.dart' as http;
import 'dart:convert';

class APIManager {
  String apiKey = "";

  void setApiKey(String key) {
    apiKey = key;
  }

  Future<String> askGPT(String prompt) async {
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
    } else {
      throw Exception('Failed to load data');
    }
  }
}


