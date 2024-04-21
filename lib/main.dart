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
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatModel>(
      builder: (context, chat, child) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chat.messages.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(chat.messages[index]),
                ),
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message',
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Provider.of<ChatModel>(context, listen: false).sendMessage(value);
                  _controller.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter your OpenAI API Key',
            ),
            onChanged: (value) {
              Provider.of<APIManager>(context, listen: false).setApiKey(value);
            },
          ),
        ],
      ),
    );
  }
}
