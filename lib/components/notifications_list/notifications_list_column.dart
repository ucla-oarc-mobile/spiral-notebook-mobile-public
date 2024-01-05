import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/models/notifications_list/notifications_list_item.dart';
import 'package:spiral_notebook/screens/parking_lot_screen.dart';
import 'package:spiral_notebook/screens/shared_artifact_details_screen.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';

class NotificationsListColumn extends ConsumerStatefulWidget {
  const NotificationsListColumn({
    Key? key,
    required this.notificationsList,
  }) : super(key: key);

  final List<NotificationsListItem> notificationsList;

  @override
  _NotificationsListColumnState createState() =>
      _NotificationsListColumnState();
}

class _NotificationsListColumnState
    extends ConsumerState<NotificationsListColumn> {
  @override
  Widget build(BuildContext context) {
    final DateFormat dayFormat = DateFormat.yMMMMd('en_US');
    final DateFormat timeFormat = DateFormat.jm();
    DateTime prevNotificationDay = DateTime.fromMillisecondsSinceEpoch(0);

    final List<Artifact> artifacts = ref.watch(filteredArtifactsProvider);

    Widget getSeperator(DateTime curNotificationDay) {
      bool sameDate = (curNotificationDay.year == prevNotificationDay.year &&
          curNotificationDay.month == prevNotificationDay.month &&
          curNotificationDay.day == prevNotificationDay.day);

      prevNotificationDay = curNotificationDay;

      return (sameDate)
          ? Divider(
              color: Color(0xFF656565),
              height: 20,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            )
          : Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Color(0xFF656565)),
                  bottom: BorderSide(width: 1.0, color: Color(0xFF656565)),
                ),
                color: Color(0xFFEEEEEE),
              ),
              width: double.infinity,
              child: Text(
                dayFormat.format(curNotificationDay),
                style: TextStyle(fontSize: 12.0, height: 1.55),
              ),
            );
    }

    Widget getRowTitle(String title) {
      return Flexible(
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Padding(
              padding: EdgeInsets.only(left: 21.0),
              child: Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
        ),
      );
    }

    Widget getRowTime(DateTime time) {
      return Padding(
        padding: EdgeInsets.only(right: 22.0),
        child: Align(
          alignment: Alignment.topRight,
          child: Text(timeFormat.format(time), style: TextStyle(fontSize: 12)),
        ),
      );
    }

    Widget getRowBody(String body) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Stack(
          children: [
            Row(
              children: [
                Flexible(
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Padding(
                        padding: EdgeInsets.only(left: 21.0, right: 32.0),
                        child: Text(body,
                            style: TextStyle(fontSize: 12, height: 1.25))),
                  ),
                )
              ],
            ),
            Positioned.fill(
              // This Positioned.fill is combined with a Stack
              // to ensure the "next" icon is always in the same place
              // while not breaking the "columns" of the layout.
              child: Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.keyboard_arrow_right,
                      color: primaryButtonBlue, size: 20),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget getParkingLotInfo() {
      String countSuffix = (artifacts.length > 1) ? 's' : '';

      return (artifacts.isEmpty)
          ? SizedBox()
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pushNamed(context, ParkingLotScreen.id);
              },
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(top: 9.0, bottom: 7.0),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getRowTitle(
                              "${artifacts.length} Item$countSuffix in the Parking Lot"),
                        ],
                      ),
                    ],
                  ),
                ),
                getRowBody(
                    "Remember to complete the artifacts in the parking lot!")
              ]));
    }

    void gotoDestination(NotificationsListItem notificationsListItem) {
      try {
        final Map<String, dynamic> desination =
            jsonDecode(notificationsListItem.destination);
        final Map<String, dynamic> params;

        if (!desination.containsKey('screen') ||
            !desination.containsKey('params')) {
          throw new FormatException(
              "Error loading destination screen and params.");
        }

        params = desination['params'];

        switch (desination['screen']) {
          case 'SharedArtifactDetailsScreen':
            int aId, pId;

            if (!params.containsKey('sharedArtifactId') ||
                !params.containsKey('sharedPortfolioId')) {
              throw new FormatException(
                  "Error loading parameters for ${desination['screen']}.");
            }

            aId = params['sharedArtifactId'];
            pId = params['sharedPortfolioId'];

            if (aId < 1 || pId < 1) {
              throw new FormatException(
                  "Error loading parameters for ${desination['screen']}.");
            }

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SharedArtifactDetailsScreen(
                      sharedArtifactId: aId.toString(),
                      sharedPortfolioId: pId.toString(),
                    )));

            break;
          default:
            break;
        }
      } catch (e) {
        print(e);
        showSnackAlert(context, "Error loading notification.");
      }
    }

    Widget getRow(NotificationsListItem notificationsListItem) {
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            gotoDestination(notificationsListItem);
          },
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 9.0, bottom: 7.0),
              child: Stack(
                children: [
                  (!notificationsListItem.isRead)
                      ? Positioned.fill(
                          // This Positioned.fill is combined with a Stack
                          // to ensure the "next" icon is always in the same place
                          // while not breaking the "columns" of the layout.
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.0, top: 6.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.fiber_manual_record_rounded,
                                  color: primaryButtonBlue, size: 10),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getRowTitle(notificationsListItem.title),
                      getRowTime(notificationsListItem.timestamp),
                    ],
                  ),
                ],
              ),
            ),
            getRowBody(notificationsListItem.body)
          ]));
    }

    return Column(children: [
      getParkingLotInfo(),
      (widget.notificationsList.isEmpty)
          ? SizedBox()
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.notificationsList.length,
              itemBuilder: (context, index) {
                NotificationsListItem notificationsListItem =
                    widget.notificationsList[index];

                return Column(
                  children: [
                    getSeperator(notificationsListItem.timestamp),
                    getRow(notificationsListItem),
                    (index == widget.notificationsList.length - 1)
                        ? Divider(thickness: 2.0)
                        : SizedBox(),
                  ],
                );
              },
            )
    ]);
  }
}
