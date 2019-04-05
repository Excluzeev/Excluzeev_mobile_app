import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/misc/palette.dart';

class MultiChipChoice extends StatefulWidget {
  final Function(List) onChanged;
  final Function(String) onResonEnter;

  MultiChipChoice({this.onChanged, this.onResonEnter});

  @override
  _MultiChipChoiceState createState() => _MultiChipChoiceState();
}

class _MultiChipChoiceState extends State<MultiChipChoice> {
  List _value = <String>[];
  String selectedString = "";
  bool _showTextEntry = false;

  List<Widget> _chipsList = List();
  Translation translation;

  _generateList() {
    _chipsList = List();

    List<String> dataList = [
      translation.nudity,
      translation.violence,
      translation.harassment,
      translation.suicide,
      translation.selfInjury,
      translation.falseNews,
      translation.spam,
      translation.unauthorisedSales,
      translation.hateSpeech,
      translation.terrorism,
      translation.other,
    ];

    dataList.forEach(
      (item) => {
            _chipsList.add(
              Container(
                padding: const EdgeInsets.only(left: 5.0, right: 2.5),
                child: ChoiceChip(
                  label: Text(item),
                  selected: _value.contains(item),
                  selectedColor: Palette.primary,
                  labelStyle: TextStyle(
                    color: _value.contains(item) ? Colors.white : Colors.black,
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      selected ? _value.add(item) : _value.remove(item);
                      if (_value.contains("Other")) {
                        _showTextEntry = true;
                      } else {
                        _showTextEntry = false;
                      }
                      widget.onChanged(_value);
                    });
                  },
                ),
              ),
            ),
          },
    );

    return _chipsList;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    translation = Translation.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Wrap(
            children: _generateList(),
          ),
          _showTextEntry
              ? TextField(
                  onChanged: (updatedString) {
                    selectedString = updatedString;
                    widget.onResonEnter(updatedString);
                  },
                  decoration: InputDecoration(
                    // helperText: translation.typeReason,
                    hintText: translation.typeReason,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
