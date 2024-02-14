// screen_a.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import 'package:q2/mvvm/observer.dart';
import 'package:q2/viewmodel/person_viewmodel.dart';
import 'package:q2/viewmodel/person_map_viewmodel.dart';
import 'package:q2/misc/tile_providers.dart';
import 'package:q2/model/person.dart';
import 'package:q2/extension/extension.dart';
import 'package:q2/view/marker_popup.dart';

class PersonMapWidget extends StatefulWidget {
  const PersonMapWidget(this._viewModel, {super.key});

  final PersonMapViewModel _viewModel;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _PersonMapWidgetState(_viewModel);
  }
}

class _PersonMapWidgetState extends State<PersonMapWidget>
    implements EventObserver {
  _PersonMapWidgetState(this._viewModel);

  final PersonMapViewModel _viewModel;

  bool _isLoading = false;
  bool _isError = false;
  String _statusMessage = "";
  // List<Person> _persons = [];
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
    _viewModel.loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Map"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _viewModel.loadData();
          },
          child: const Icon(Icons.refresh),
        ),
        body: _isError
            ? Center(child: Text(_statusMessage))
            : _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : FlutterMap(
                    options: _viewModel.mapOptions,
                    children: [
                      openStreetMapTileLayer,
                      _popupMarkerLayer,
                    ],
                  ));
  }

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
        _isError = false;
      });
    } else if (event is DataLoadedEvent) {
      setState(() {
        // _persons = event.data;
        List<PersonMarker> markers = [];
        for (var element in event.data) {
          if (element.location.getLatLng() != null) {
            markers.add(PersonMarker(element,
                point: element.location.getLatLng()!,
                width: 40.0,
                height: 40.0,
                child: const Icon(Icons.location_pin,
                    color: Colors.red, size: 40)));
          }
        }
        _markers = markers;
        _isError = false;
      });
    } else if (event is LoadFailedEvent) {
      setState(() {
        _statusMessage = event.error;
        _isError = true;
      });
    }
  }

  late final PopupMarkerLayer _popupMarkerLayer = PopupMarkerLayer(
    options: PopupMarkerLayerOptions(
        markers: _markers,
        popupDisplayOptions: PopupDisplayOptions(
          builder: (BuildContext context, Marker marker) {
            final pmarker = marker as PersonMarker;
            return MarkerPopup(marker, pmarker.person?.displayName);
          },
        )),
  );
}

class PersonMarker extends Marker {
  const PersonMarker(this.person,
      {super.key,
      required super.point,
      required super.child,
      super.width,
      super.height,
      super.alignment,
      super.rotate});

  final Person? person;
}
