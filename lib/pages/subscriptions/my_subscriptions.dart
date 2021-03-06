import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/managers/subscription_manager.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/subscription.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/subscriptions/widgets/subscription_widget.dart';
import 'package:trenstop/pages/home/widgets/information.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

class MySubscriptionsPage extends StatefulWidget {
  static const String TAG = "MY_SUBSCRIPTIONS_PAGE";
  final User user;

  MySubscriptionsPage(this.user);

  @override
  _MySubscriptionsPageState createState() => _MySubscriptionsPageState();
}

class _MySubscriptionsPageState extends State<MySubscriptionsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SubscriptionManager _subscriptionManager = SubscriptionManager.instance;
  ChannelManager _channelManager = ChannelManager.instance;
  Translation translation;

  _showSnackBar(String message) {
    if (mounted && message != null && message.isNotEmpty)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
  }

  _onTapSubscription(Subscription subscription) async {
    Snapshot snap =
        await _channelManager.getChannelFromId(subscription.channelId);
    if (snap.error != null) {
      _showSnackBar(snap.error);
      return;
    }
    WidgetUtils.showChannelDetails(context, widget.user, snap.data);
  }

  _onUnsubscribe(Subscription subscription) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Unsubscribe"),
              content: Text(
                  "Do you want to unsubscribe from ${subscription.channelName} you still have ${subscription.expiryDate.difference(DateTime.now()).inDays} day(s) Left.\n\nYou are not able to view the videos once you unsubscribe."),
              actions: <Widget>[
                FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _subscriptionManager.doUnSubscribe(subscription);
                    }),
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot,
      Animation animation, int index) {
    final subscription = Subscription.fromDocumentSnapshot(snapshot);

    return FadeTransition(
      opacity: animation,
      child: subscription != null
          ? SubscriptionWidget(
              subscription: subscription,
              onTap: _onTapSubscription,
              onUnsubscribe: _onUnsubscribe,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: WhiteAppBar(
        title: Text(translation.mySubscriptions),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: widget.user == null
            ? CircularProgressIndicator()
            : FirestoreAnimatedList(
                query: _subscriptionManager
                    .mySubscriptionsQuery(widget.user.uid)
                    .snapshots(),
                errorChild: InformationWidget(
                  icon: Icons.error,
                  subtitle: translation.errorLoadSubscriptions,
                ),
                emptyChild: Center(
                  child: Text("Join the communities to see them here"),
                ),
                // Image.asset(
                //   'res/icons/empty-subscribe.png',
                //   fit: BoxFit.fill,
                // ),
                itemBuilder: _buildItem,
              ),
      ),
    );
  }
}
