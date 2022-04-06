
// Automatic FlutterFlow imports
import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '../actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
//import 'package:flutter/material.dart';
// Begin custom widget code

import 'dart:io';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import 'package:hail_repair/backend/firebase_storage/storage.dart';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
//import '../../backend/firebase_storage/storage.dart';

//import '../../flutter_flow/flutter_flow_icon_button.dart';
//import '../../flutter_flow/flutter_flow_theme.dart';
//import '../../flutter_flow/upload_media.dart';
import 'package:web_socket_channel/io.dart';

class StockQuotes extends StatefulWidget {
  const StockQuotes({
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  _StockQuotesState createState() => _StockQuotesState();
}

class _StockQuotesState extends State<StockQuotes> {
  IOWebSocketChannel channel;
  Map myjson;

  @override
  void initState() {

    channel = IOWebSocketChannel.connect('wss://ws.finnhub.io?token=c96b3iiad3icjtt5n0a0');
    channel.sink.add(json.encode({'type': 'subscribe', 'symbol': 'AAPL'}));
    channel.sink.add(json.encode({'type': 'subscribe', 'symbol': 'AMZN'}));
    channel.sink.add(json.encode({'type': 'subscribe', 'symbol': 'GOOG'}));
    /*channel.stream.listen((message) {
      print(message.toString());
      //String fixed = message.replaceAll("\'", "'");
      myjson = json.decode(message);
      //print(fixed.toString());
      //myjson = jsonDecode(fixed);
      doValues(myjson);
    });*/
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          return Text(snapshot.data ? '${snapshot.data}' : '');
        });

  }
}
