import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<APIManager>(create: (_) => APIManager()),
        ChangeNotifierProxyProvider<APIManager, ChatModel>(
          create: (_) => ChatModel(APIManager()),
          update: (_, apiManager, chatModel) => chatModel!..updateAPIManager(apiManager),
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT Queue App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
          title: Text('GPT Queue App'),
        ),
        body: TabBarView(
          children: [
            ChatPage(),
            SettingsPage(),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isKeyValid = Provider.of<APIManager>(context).apiKey.isNotEmpty;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: Provider.of<ChatModel>(context).messages.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(Provider.of<ChatModel>(context).messages[index]),
            ),
          ),
        ),
        TextField(
          enabled: isKeyValid,
          decoration: InputDecoration(
            labelText: 'Send a message',
            hintText: isKeyValid ? 'Type your message...' : 'Invalid API Key',
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              Provider.of<ChatModel>(context, listen: false).sendMessage(value);
            }
          },
        ),
      ],
    );
  }
}


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _keyController = TextEditingController();
  String? _errorText;

  void _validateKey(String key) {
    Provider.of<APIManager>(context, listen: false).setApiKey(key);
    Provider.of<APIManager>(context, listen: false).askGPT("Hello")
      .then((_) => setState(() => _errorText = null))
      .catchError((e) {
        setState(() => _errorText = e.toString());
        Provider.of<APIManager>(context, listen: false).setApiKey(""); // Reset the API Key
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _keyController,
            decoration: InputDecoration(
              labelText: 'Enter your OpenAI API Key',
              errorText: _errorText,
            ),
            onChanged: _validateKey,
          ),
        ],
      ),
    );
  }
}

