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


  LikeDislikeNeutral({@required this.id, @required this.type, @required this.likes, @required this.dislikes, @required this.neutral});

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
    if(firebaseUser != null) {
      return true;
    }
    return false;
  }

  _updateCount(int newWhat) {

    if(prev != 2) {

      setState(() {
        if(newWhat == 1) {
          likes +=1;
        } else if(newWhat == 0) {
          neutral +=1;
        } else if(newWhat == -1) {
          dislikes +=1;
        }

        if(prev == 1) {
          likes -= 1;
        } else if(prev == 0) {
          neutral -= 1;
        } else if(prev == -1) {
          dislikes -= 1;
        }
      });
      prev = newWhat;

    }

  }

  _like() async {
    if(isLike) {
      return;
    }
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if(firebaseUser == null) {
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
    if(isNeutral) {
      return;
    }
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if(firebaseUser == null) {
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
    if(isDislike) {
      return;
    }
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if(firebaseUser == null) {
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
    if(firebaseUser != null) {
      int what = await _likeManager.isWhat(firebaseUser.uid, widget.id, widget.type);
      Logger.log(LikeDislikeNeutral.TAG, message: "$what");
      prev = what;
      setState(() {
        if(what == 1) {
          isLike = true;
        } else if(what == -1) {
          isDislike = true;
        } else if (what == 0) {
          isNeutral = true;
        }
      });
    }
  }

  Color _getColor(isWhat) {
    if(isWhat) {
      return Palette.primary;
    } else {
      return Palette.disabled;
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color: _getColor(isLike),
                ),
                onPressed: () => _like(),
              ),
              Text(
                "$likes"
              ),
            ],
          ),
          Column(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.sentiment_neutral,
                  color: _getColor(isNeutral),
                ),
                onPressed: () => _neutral(),
              ),
              Text(
                  "$neutral"
              ),
            ],
          ),
          Column(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.thumb_down,
                  color: _getColor(isDislike),
                ),
                onPressed: () => _dislike(),
              ),
              Text(
                  "$dislikes"
              ),
            ],
          ),
        ],
      ),
    );
  }
}
