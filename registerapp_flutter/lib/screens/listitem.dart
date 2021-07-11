import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/register.dart';
import 'package:http/http.dart' as http;

class ListItem extends StatefulWidget {
  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  void initState() {
    super.initState();

    get_data();
  }

  List items = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[300],
          title: Text("List Item"),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              color: items[index]["class"] == "Visitor"
                  ? Colors.green[200]
                  : items[index]["class"] == "Whitelist"
                      ? Colors.orange[200]
                      : Colors.red[200],
              child: Column(
                children: [
                  Text("\n${items[index]["license_plate"]}",
                      style: TextStyle(fontSize: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${items[index]["class"]}",
                          style: TextStyle(fontSize: 16)),
                      items[index]["start_time"] != null
                          ? Text(
                              "${items[index]["start_time"]} - ${items[index]["end_time"]}",
                              style: TextStyle(fontSize: 16))
                          : Text("any time"),
                    ],
                  ),
                  Text("\n"),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Register()),
            );
          },
          tooltip: 'Register',
          child: Icon(Icons.add),
          backgroundColor: Colors.orange[300],
        ),
      ),
    );
  }

  Future get_data() async {
    var url = Uri.parse('http://192.168.1.177:8000/get_all_items');
    var response = await http.get(url);

    String body = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      List data_list = json.decode(body);
      items = [];

      for (int i = 0; i < data_list.length; i++) {
        for (int j = 0; j < data_list[i].length; j++) {
          Map data_map = data_list[i][j];

          setState(() {
            if (i == 0) {
              data_map["class"] = "Visitor";
            } else if (i == 1) {
              data_map["class"] = "Whitelist";
            } else {
              data_map["class"] = "Blacklist";
            }
            items.add(data_map);
          });
        }
      }
    }
  }
}
