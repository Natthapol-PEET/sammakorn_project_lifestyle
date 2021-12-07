import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/models/screenArg.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import 'package:registerapp_flutter/screens/ShowQrcode/showQrCodeScreen.dart';
import '../../constance.dart';
import 'components/bottom_nav_bar.dart';
import 'components/card_list_timeline.dart';
import 'components/card_title.dart';
import 'components/dialog_cancel.dart';
import 'components/dialog_cancel_request.dart';
import 'components/dialog_delete.dart';
import 'components/dialog_send_admin.dart';
import 'components/dialog_show.dart';
import 'components/dialog_stamp.dart';
import 'components/dialoog_delete_whiteblack.dart';
import 'model/TimelineItem.dart';

class ShowDetailScreen extends StatefulWidget {
  const ShowDetailScreen({
    Key key,
  }) : super(key: key);

  @override
  _ShowDetailScreenState createState() => _ShowDetailScreenState();
}

class _ShowDetailScreenState extends State<ShowDetailScreen> {
  Services services = Services();

  List itemcard = [];
  String titleButton;
  IconData iconButton;

  List<bool> isEnableList = [];
  List<Function> pass = [];

  bool disNavButton = false;

  final controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments as Map;

    // initState get data from key
    getCardItems(arguments);

    return Scaffold(
      appBar: AppBar(
          title: Text('Timeline', style: TextStyle(color: goldenSecondary)),
          centerTitle: true,
          backgroundColor: darkgreen),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardTitle(arguments: arguments),
            build_timeline(context, itemcard),
          ],
        ),
      ),
      bottomNavigationBar:
          // arguments['select'] == 'Admin done' ||
          // arguments['select'] == 'Leaving' ||
          // arguments['select'] == 'history' ||
          // titleButton == "Admin disapprove" ||
          disNavButton
              // || arguments['select'] == "blacklist and whitelist"
              ? null
              : BottomNavBar(
                  titleButton: titleButton,
                  iconButton: iconButton,
                  pass: () {
                    if (arguments['select'] == 'Invite') {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return DialogDelete(
                              id: arguments['visitor_id'].toString());
                        },
                      );
                    } else if (arguments['select'] == 'coming_walk') {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return DialogStamp(
                            press: () async {
                              // var socket = SocketManager();
                              // socket.send_message('RESIDENT_STAMP', 'web');
                              // socket.send_message('RESIDENT_STAMP', 'app');

                              services.resident_stamp(
                                  arguments['log_id'].toString());

                              controller.publishMqtt("app-to-web", "RESIDENT_STAMP");
                              Get.toNamed('/home');
                            },
                          );
                        },
                      );
                    } else if (arguments['select'] == 'Resident stamp') {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return DialogSendAdmin(
                              id: arguments['log_id'].toString());
                        },
                      );
                    } else if (arguments['select'] == 'Wait Admin') {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return DialogCancel(
                              id: arguments['log_id'].toString());
                        },
                      );
                    } else if (arguments['select'] ==
                            "blacklist and whitelist" &&
                        titleButton == "Cancel Request") {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return DialogCancelRequest(
                            resident_remove_reason:
                                arguments['resident_remove_reason'],
                            type: arguments['type'],
                            id: arguments['id'].toString(),
                          );
                        },
                      );
                    } else if (arguments['select'] ==
                            "blacklist and whitelist" &&
                        arguments['admin_approve'] == true) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return DialogSendDeleteWhiteBlack(
                            type: arguments['type'],
                            id: arguments['id'].toString(),
                          );
                        },
                      );
                    }
                  },
                ),
      backgroundColor: darkgreen200,
    );
  }

  ListView build_timeline(context, lists) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: lists.length,
      itemBuilder: (context, index) {
        return CardListTimeline(
          itemcard: lists,
          index: index,
          isEnable: isEnableList[index],
          pass: pass[index],
        );
      },
    );
  }

  getCardItems(Map arguments) {
    List items = [];

    if (arguments.containsKey('invite') && arguments['invite'] != null) {
      items.add(TimeLineItem('Invite', arguments['invite']));

      setState(
        () {
          disNavButton = false;
          titleButton = 'Delete';
          iconButton = Icons.delete;
          isEnableList.add(true);
          pass.add(
            () => {
              Get.off(
                ShowQrcodeScreen(
                  data: ScreenArguments(
                    "Visitor",
                    arguments['license_plate'],
                    arguments['invite'].split('T')[0],
                    arguments['fullname'].split('  ')[0],
                    arguments['fullname'].split('  ')[1],
                    arguments['qr_gen_id'],
                    true,
                  ),
                ),
              ),
            },
          );
        },
      );
    }

    if (arguments.containsKey('datetime_in') &&
        arguments['datetime_in'] != null) {
      items.add(TimeLineItem(arguments['status'], arguments['datetime_in']));

      setState(() {
        disNavButton = false;
        titleButton = 'Stamp for visitor';
        iconButton = Icons.approval;
        isEnableList.add(false);
        pass.add(null);
      });
    }

    if (arguments.containsKey('resident_stamp') &&
        arguments['resident_stamp'] != null) {
      items.add(TimeLineItem('Villagers Stamp', arguments['resident_stamp']));

      setState(() {
        disNavButton = false;
        titleButton = 'Send request to juristic';
        iconButton = Icons.send;
        isEnableList.add(false);
        pass.add(null);
      });
    }

    if (arguments.containsKey('resident_send_admin') &&
        arguments['resident_send_admin'] != null) {
      items.add(TimeLineItem(
          'Send request to juristic', arguments['resident_send_admin']));

      setState(() {
        disNavButton = false;
        titleButton = 'Cancel Request';
        iconButton = Icons.cancel;
        isEnableList.add(true);
        pass.add(() => showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogShow(
                  key1: "resident_reason",
                  value1: arguments['resident_reason'],
                );
              },
            ));
      });
    }

    if (arguments.containsKey('admin_datetime') &&
        arguments['admin_datetime'] != null &&
        arguments['select'] != "blacklist and whitelist") {
      items.add(TimeLineItem('Juristic done', arguments['admin_datetime']));

      setState(() {
        disNavButton = true;
        isEnableList.add(true);
        pass.add(() => showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogShow(
                  key1: "admin_approve",
                  value1: arguments['admin_approve'] ? 'Stamp' : 'No stamp',
                  key2: "admin_reason",
                  value2: arguments['admin_reason'],
                );
              },
            ));
      });
    }

    // Leave the project
    if (arguments.containsKey('datetime_out') &&
        arguments['datetime_out'] != null) {
      items.add(TimeLineItem('Leave the project', arguments['datetime_out']));

      setState(() {
        disNavButton = true;
        isEnableList.add(false);
        pass.add(null);
      });
    }

    // List Item || Blacklist || Whitelist
    if (arguments.containsKey('resident_add_reason') &&
        arguments['resident_add_reason'] != null) {
      if (arguments['type'] == 'White List') {
        items.add(
            TimeLineItem('Sing whitelist', arguments['resident_datetime']));
      } else {
        items.add(
            TimeLineItem('Sing blacklist', arguments['resident_datetime']));
      }

      setState(() {
        disNavButton = false;
        titleButton = 'Cancel Request';
        iconButton = Icons.cancel;
        isEnableList.add(true);
        pass.add(() => showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogShow(
                  key1: "resident_add_reason",
                  value1: arguments['resident_add_reason'],
                );
              },
            ));
      });

      // admin approve or disapprove whitelist and blacklist
      if (arguments['select'] == 'blacklist and whitelist') {
        if (arguments['admin_approve'] != null) {
          if (arguments['admin_approve'] == true) {
            items.add(
                TimeLineItem('Admin approve', arguments['admin_datetime']));

            setState(() {
              disNavButton = false;
              titleButton = "Delete ${arguments['type']}";
              iconButton = Icons.delete;
              isEnableList.add(true);

              // go to qr-code screen
              pass.add(() => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowQrcodeScreen(
                            data: ScreenArguments(
                          "Whitelist",
                          arguments['license_plate'],
                          arguments['resident_datetime'].split('T')[0],
                          arguments['fullname'].split('  ')[0],
                          arguments['fullname'].split('  ')[1],
                          arguments['qr_gen_id'],
                          true,
                        )),
                      ),
                    )
                  });

              // popup reason
              // pass.add(() => showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return DialogShow(
              //           key1: "admin_reason",
              //           value1: arguments['admin_reason'],
              //         );
              //       },
              //     ));
            });
          } else {
            items.add(
                TimeLineItem('Admin disapprove', arguments['admin_datetime']));

            setState(() {
              disNavButton = true;
              titleButton = "Admin disapprove";
              isEnableList.add(true);
              pass.add(() => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogShow(
                        key1: "admin_reason",
                        value1: arguments['admin_reason'],
                      );
                    },
                  ));
            });
          }

          // remove whitelist and blacklist -> send to juristic
          if (arguments['resident_remove_reason'] != '-') {
            items.add(TimeLineItem(
                'Send to juristic', arguments['resident_remove_datetime']));

            setState(() {
              disNavButton = false;
              titleButton = "Cancel Request";
              iconButton = Icons.cancel;
              isEnableList.add(true);
              pass.add(() => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogShow(
                        key1: "resident_remove_reason",
                        value1: arguments['resident_remove_reason'],
                      );
                    },
                  ));
            });
          }
        }
      }
    }

    setState(() => itemcard = items);
  }
}
