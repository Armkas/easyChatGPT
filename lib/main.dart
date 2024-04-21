import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // 这是你的应用程序的主题。
        //
        // 尝试使用 "flutter run" 运行你的应用程序。你会看到
        // 应用程序有一个蓝色的工具栏。然后，在不退出应用的情况下，尝试
        // 将下面的 primarySwatch 改为 Colors.green，然后调用
        // "hot reload"（在你运行 "flutter run" 的控制台中按 "r"，
        // 或者直接在 Flutter IDE 中保存你的更改以触发 "hot reload"）。
        // 注意，计数器并没有重置回零；应用程序并没有重启。
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // 这个小部件是你的应用程序的主页。它是有状态的，意味着
  // 它有一个状态对象（在下面定义）包含影响其外观的字段。

  // 这个类是状态的配置。它保存了父级（在这种情况下是 App 小部件）提供的值（在这种情况下是标题），
  // 并被状态的 build 方法使用。小部件子类中的字段总是标记为 "final"。

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // 这个对 setState 的调用告诉 Flutter 框架，这个 State 中的某些东西已经改变，
      // 这会导致它重新运行下面的 build 方法，以便显示可以反映更新的值。如果我们改变了
      // _counter 而没有调用 setState()，那么 build 方法将不会再次被调用，因此看起来就像什么都没有发生。
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 每次调用 setState 时，例如上面的 _incrementCounter 方法，此方法都会重新运行。
    //
    // Flutter 框架已经优化了重新运行构建方法的速度，因此你可以重新构建任何需要更新的内容，
    // 而不必单独更改小部件的实例。
    return Scaffold(
      appBar: AppBar(
        // 这里我们从由App.build方法创建的MyHomePage对象中取值，并用它来设置我们的appbar标题。
        title: Text(widget.title),
      ),
      body: Center(
        // Center 是一个布局小部件。它接受一个子元素并将其定位在父元素的中间。
        child: Column(
          // Column 也是一个布局小部件。它接受一个子元素列表并垂直排列它们。默认情况下，它会自适应其子元素的水平大小，并尝试与其父元素一样高。
          //
          // 调用 "debug painting"（在控制台中按 "p"，在 Android Studio 的 Flutter Inspector 中选择 "Toggle Debug Paint" 操作，或在 Visual Studio Code 中选择 "Toggle Debug Paint" 命令）
          // 来查看每个小部件的线框。
          //
          // Column 有各种属性来控制它如何自我调整大小以及如何定位其子元素。这里我们使用 mainAxisAlignment 来垂直居中子元素；这里的主轴是垂直轴，因为 Columns 是垂直的（交叉轴将是水平的）。
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // 这个尾随的逗号使得自动格式化对于构建方法更加友好。
    );
  }
}
