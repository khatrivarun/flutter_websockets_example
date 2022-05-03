import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final IOWebSocketChannel ioWebSocketChannel;

  @override
  void initState() {
    super.initState();

    ioWebSocketChannel =
        IOWebSocketChannel.connect(Uri.parse("ws://10.0.2.2:3000"));

    ioWebSocketChannel.stream.listen((event) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(event.toString())));
    }, onError: (error) {
      print(error);
    });
  }

  void _sendMessage() {
    ioWebSocketChannel.sink.add(json.encode({
      "event": "message",
      "data": {"authenticated": true, "message": "lol whats up"}
    }));
  }

  void _sendError() {
    ioWebSocketChannel.sink.add(json.encode({
      "event": "message",
      "data": {"message": "lol whats up"}
    }));
  }

  @override
  void dispose() {
    super.dispose();

    ioWebSocketChannel.sink.add(status.goingAway);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: _sendMessage,
              child: const Text('Send Message'),
            ),
            TextButton(
              onPressed: _sendError,
              child: const Text('Send Error'),
            ),
          ],
        ),
      ),
    );
  }
}
