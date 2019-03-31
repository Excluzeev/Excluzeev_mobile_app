import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/managers/like_manager.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/misc/widget_utils.dart';

class LikeDislikeNeutral extends StatefulWidget {
  static const String TAG = "LIKE_DISLIKE_NEUTRAL_WIDGET";
  final String id;
  final String type;
  final int likes;
  final int dislikes;
  final int neutral;

  LikeDislikeNeutral(
      {@required this.id,
      @required this.type,
      @required this.likes,
      @required this.dislikes,
      @required this.neutral});

  @override
  _LikeDislikeNeutralState createState() => _LikeDislikeNeutralState();
}

class _LikeDislikeNeutralState extends State<LikeDislikeNeutral> {
  final LikeManager _likeManager = LikeManager();

  bool isLike = false;
  bool isDislike = false;
  bool isNeutral = false;
  int likes = 0;
  int dislikes = 0;
  int neutral = 0;

  int prev = 2;

  Future<bool> isLoggedIn() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      return true;
    }
    return false;
  }

  _updateCount(int newWhat) {
    setState(() {
      if (newWhat == 1) {
        likes += 1;
      } else if (newWhat == 0) {
        neutral += 1;
      } else if (newWhat == -1) {
        dislikes += 1;
      }

      if (prev == 1) {
        likes -= 1;
      } else if (prev == 0) {
        neutral -= 1;
      } else if (prev == -1) {
        dislikes -= 1;
      }
    });
    prev = newWhat;
  }

  _like() async {
    if (isLike) {
      return;
    }
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) {
      WidgetUtils.goToAuth(context, replaceAll: false);
      return;
    }
    await _likeManager.what(firebaseUser.uid, widget.id, 1, widget.type);
    setState(() {
      isNeutral = false;
      isDislike = false;
      isLike = true;
    });
    _updateCount(1);
  }

  _neutral() async {
    if (isNeutral) {
      return;
    }
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) {
      WidgetUtils.goToAuth(context, replaceAll: false);
      return;
    }
    await _likeManager.what(firebaseUser.uid, widget.id, 0, widget.type);
    setState(() {
      isNeutral = true;
      isDislike = false;
      isLike = false;
    });
    _updateCount(0);
  }

  _dislike() async {
    if (isDislike) {
      return;
    }
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) {
      WidgetUtils.goToAuth(context, replaceAll: false);
      return;
    }
    await _likeManager.what(firebaseUser.uid, widget.id, -1, widget.type);
    setState(() {
      isNeutral = false;
      isDislike = true;
      isLike = false;
    });
    _updateCount(-1);
  }

  _checkWhat() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      int what =
          await _likeManager.isWhat(firebaseUser.uid, widget.id, widget.type);
      Logger.log(LikeDislikeNeutral.TAG, message: "$what");
      prev = what;
      setState(() {
        if (what == 1) {
          isLike = true;
        } else if (what == -1) {
          isDislike = true;
        } else if (what == 0) {
          isNeutral = true;
        }
      });
    }
  }

  Color _getColor(isWhat) {
    if (isWhat) {
      return Palette.primary;
    } else {
      return Palette.grey;
    }
  }

  _setData() async {
    setState(() {
      likes = widget.likes;
      dislikes = widget.dislikes;
      neutral = widget.neutral;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkWhat();
    _setData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 15.0,
            ),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ImageIcon(
                      AssetImage(
                        "res/icons/like.png",
                      ),
                      size: 32.0,
                      color: _getColor(isLike),
                    ),
                  ),
                  onTap: () => _like(),
                ),
                Text(
                  "$likes",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: _getColor(isLike),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.rotate(
                      angle: 80,
                      child: ImageIcon(
                        AssetImage(
                          "res/icons/like.png",
                        ),
                        size: 32.0,
                        color: _getColor(isNeutral),
                      ),
                    ),
                  ),
                  onTap: () => _neutral(),
                ),
                Text(
                  "$neutral",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: _getColor(isNeutral),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.rotate(
                      angle: 160,
                      child: ImageIcon(
                        AssetImage(
                          "res/icons/like.png",
                        ),
                        color: _getColor(isDislike),
                        size: 32.0,
                      ),
                    ),
                  ),
                  onTap: () => _dislike(),
                ),
                Text(
                  "$dislikes",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: _getColor(isDislike),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
