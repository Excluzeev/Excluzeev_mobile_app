import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/managers/trailer_manager.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

import 'package:trenstop/widgets/rounded_border.dart';

class EditTrailerDescription extends StatefulWidget {
  final Trailer trailer;

  EditTrailerDescription(this.trailer);

  @override
  _EditTrailerDescriptionState createState() => _EditTrailerDescriptionState();
}

class _EditTrailerDescriptionState extends State<EditTrailerDescription> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _descriptionController = TextEditingController();

  final TrailerManager _trailerManager = TrailerManager.instance;

  String _description = "";
  bool _isUpdating = false;

  Translation translation;

  _showSnackBar(String message) {
    _updateStatus(false);
    if (mounted && message != null && message.isNotEmpty)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
  }

  _updateStatus(bool status) {
    setState(() {
      _isUpdating = status;
    });
  }

  _updateDescription(String description) {
    setState(() {
      _description = description;
    });
  }

  _startUpdate() async {
    _updateStatus(true);
    Snapshot<Trailer> snapshot = await _trailerManager.updateTrailerDescription(
        widget.trailer, _description);

    if (snapshot.error != null) {
      _showSnackBar(snapshot.error);
      return;
    } else {
      _showSnackBar("Description updated.");
    }
    _updateStatus(false);
    Navigator.of(context).pop(_description);
  }

  @override
  void initState() {
    super.initState();
    _updateDescription(widget.trailer.description);
    setState(() {
      _descriptionController.text = _description;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: WhiteAppBar(
        centerTitle: true,
        title: Text("Description"),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              enabled: !_isUpdating,
              controller: _descriptionController,
              onChanged: _updateDescription,
              maxLines: 5,
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                filled: true,
                border: InputBorder.none,
                hintText: translation.descriptionLabel,
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(255)],
            ),
            SizedBox(
              height: 16.0,
            ),
            RoundedButton(
              enabled: !_isUpdating,
              text: translation.updateDescription.toUpperCase(),
              onPressed: () => !_isUpdating
                  ? _startUpdate()
                  : _showSnackBar(translation.errorFields),
            ),
            SizedBox(
              height: 16.0,
            ),
            if (_isUpdating)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

class RoundedBorder {}
