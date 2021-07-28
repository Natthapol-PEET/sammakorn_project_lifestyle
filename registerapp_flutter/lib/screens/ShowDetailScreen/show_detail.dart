import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Home/components/popup_body.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import '../../constance.dart';
import 'components/bottom_nav_bar.dart';
import 'components/card_list_timeline.dart';
import 'components/card_title.dart';
import 'components/dialog_cancel.dart';
import 'components/dialog_delete.dart';
import 'components/dialog_send_admin.dart';
import 'components/dialog_show.dart';
import 'components/dialog_stamp.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments as Map;
    getCardItems(arguments);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          title: Text('Timeline'),
          centerTitle: true,
          backgroundColor: darkgreen),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardTitle(arguments: arguments),
            build_timeline(),
          ],
        ),
      ),
      bottomNavigationBar: arguments['select'] == 'Admin done' ||
              arguments['select'] == 'Leaving' ||
              arguments['select'] == 'history'
          ? null
          : BottomNavBar(
              titleButton: titleButton,
              iconButton: iconButton,
              pass: () {
                if (arguments['select'] == 'Invite') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogDelete(
                          id: arguments['visitor_id'].toString());
                    },
                  );
                } else if (arguments['select'] == 'coming_walk') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogStamp(id: arguments['log_id'].toString());
                    },
                  );
                } else if (arguments['select'] == 'Resident stamp') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogSendAdmin(
                          id: arguments['log_id'].toString());
                    },
                  );
                } else if (arguments['select'] == 'send to admin') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogCancel(id: arguments['log_id'].toString());
                    },
                  );
                }
              },
            ),
      backgroundColor: darkgreen200,
    );
  }

  ListView build_timeline() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemcard.length,
      itemBuilder: (context, index) {
        return CardListTimeline(
          itemcard: itemcard,
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
      items.add(TimeLineItem(
          'ลูกบ้านลงทะเบียน', arguments['invite'], Icons.how_to_reg));

      setState(() {
        titleButton = 'ลบรายการ';
        iconButton = Icons.delete;
        isEnableList.add(false);
        pass.add(null);
      });
    }

    if (arguments.containsKey('datetime_in')) {
      items.add(TimeLineItem('ผู้เข้าพบมาถึงป้อม รปภ.',
          arguments['datetime_in'], Icons.arrow_downward));

      setState(() {
        titleButton = 'สแสมป์ให้ผู้เข้าพบ';
        iconButton = Icons.approval;
        isEnableList.add(false);
        pass.add(null);
      });
    }

    if (arguments.containsKey('resident_stamp')) {
      items.add(TimeLineItem('ลูกบ้านสแตมป์ยอมรับ', arguments['resident_stamp'],
          Icons.verified_user));

      setState(() {
        titleButton = 'ส่งคำขอเพื่อให้นิติสแตมป์';
        iconButton = Icons.approval;
        isEnableList.add(false);
        pass.add(null);
      });
    }

    if (arguments.containsKey('resident_send_admin')) {
      items.add(TimeLineItem('ส่งคำขอถึงนิติบุลคล',
          arguments['resident_send_admin'], Icons.verified_user));

      setState(() {
        titleButton = 'ยกเลิกคำขอ';
        iconButton = Icons.cancel;
        isEnableList.add(true);
        pass.add(() => showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogShow(
                  key1: "resident_reason",
                  value1: arguments['resident_reason'].toString(),
                  key2: "",
                  value2: "",
                );
              },
            ));
      });
    }

    if (arguments.containsKey('admin_datetime')) {
      items.add(TimeLineItem('นิติบุลคลดำเนินการแล้ว',
          arguments['admin_datetime'], Icons.verified_user));

      setState(() {
        isEnableList.add(true);
        pass.add(() => showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogShow(
                  key1: "admin_approve",
                  value1: arguments['admin_approve'] ? 'true' : 'false',
                  key2: "admin_reason",
                  value2: arguments['admin_reason'].toString(),
                );
              },
            ));
      });
    }

    if (arguments.containsKey('datetime_out')) {
      items.add(TimeLineItem(
          'ออกจากโครงการแล้ว', arguments['datetime_out'], Icons.verified_user));

      setState(() {
        isEnableList.add(false);
        pass.add(null);
      });
    }

    setState(() => itemcard = items);
  }
}
