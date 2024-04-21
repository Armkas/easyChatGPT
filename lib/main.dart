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
                itemBuilder: (context, index) {
                  final message = chat.messages[index];
                  final isUserMessage = message.startsWith("User:");
                  return ListTile(
                    title: Align(
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message.substring(5),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Send a message',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        Provider.of<ChatModel>(context, listen: false).sendMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
                ),
              ),
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
