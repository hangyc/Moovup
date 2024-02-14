import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MarkerPopup extends StatefulWidget {
  final Marker marker;

  final String content;

  const MarkerPopup(this.marker, this.content, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _MarkerPopupState(content);
}

class _MarkerPopupState extends State<MarkerPopup> {
  _MarkerPopupState(this.content);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
          ],
        ),
      ),
    );
  }

  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Text(
          // person.displayName,
          content,
          overflow: TextOverflow.fade,
          softWrap: false,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
