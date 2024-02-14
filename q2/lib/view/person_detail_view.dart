import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:q2/extension/extension.dart';

import 'package:q2/viewmodel/person_detail_viewmodel.dart';
import 'package:q2/misc/tile_providers.dart';
import 'marker_popup.dart';

class PersonDetailWidget extends StatelessWidget {
  PersonDetailWidget(this._viewModel, {super.key});

  final mapController = MapController();
  final PersonDetailViewModel _viewModel;

  late final List<Marker> _markers = (_viewModel.latLng() != null)
      ? [
          Marker(
            point: _viewModel.latLng()!,
            width: 40,
            height: 40,
            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
        ]
      : [];

  // late final MarkerLayer _markerLayer = MarkerLayer(markers: _markers);
  late final PopupMarkerLayer _markerLayer = PopupMarkerLayer(
    options: PopupMarkerLayerOptions(
      markers: _markers,
      popupDisplayOptions: PopupDisplayOptions(
        builder: (BuildContext context, Marker marker) =>
            MarkerPopup(marker, _viewModel.person.location.getLagLngInfo()!),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: FlutterMap(
              options: _viewModel.mapOptions,
              children: [
                openStreetMapTileLayer,
                _markerLayer,
                // _popupMarkerLayer,
              ],
            ),
          ),
          Visibility(
            visible: (_viewModel.latLng() == null),
            child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  height: 44,
                  color: Colors.red,
                  child: const Text(
                    "Invalid location data",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 100,
              color: Colors.white,
              child: (Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                      child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: _viewModel.person.picture,
                    width: 44.0,
                    height: 44.0,
                  )),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_viewModel.person.displayName)),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(_viewModel.person.email)),
                    ],
                  ),
                ],
              )),
            ),
          )
        ]));
  }
}
