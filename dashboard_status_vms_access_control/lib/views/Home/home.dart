// import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Client client = Client();

  void initState() {
    super.initState();

    // client.setEndpoint('http://localhost/v1').setProject('6131d01cc9329');
    // .setSelfSigned(); // Remove in production

    // final channels = ['documents.6131e9815b9ac', 'collections'];
    // final realtime = Realtime(client);
    // final subscription = realtime.subscribe(channels);

    // subscription.stream.listen((response) {
    //   print("********************");
    //   if (response.payload.containsKey("msg")) {
    //     print(response.payload['wildcard']);
    //     print(response.payload['msg']);
    //   }
    //   print("********************");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  @override
  void dispose() {
    super.dispose();

    // subscription.close();
  }
}
