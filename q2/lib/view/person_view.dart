import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:q2/extension/extension.dart';
import 'package:q2/view/person_detail_view.dart';
import 'package:q2/viewmodel/person_detail_viewmodel.dart';

import 'package:q2/model/person.dart';
import 'package:q2/mvvm/observer.dart';
import 'package:q2/viewmodel/person_viewmodel.dart';

class PersonListWidget extends StatefulWidget {
  const PersonListWidget(this._viewModel, {super.key});

  final PersonViewModel _viewModel;

  @override
  State<StatefulWidget> createState() {
    return _PersonListWidgetState(_viewModel);
  }
}

class _PersonListWidgetState extends State<PersonListWidget>
    implements EventObserver {
  _PersonListWidgetState(this._viewModel);

  final PersonViewModel _viewModel;

  bool _isLoading = false;
  bool _isError = false;
  String _statusMessage = "";
  List<Person> _persons = [];

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
          title: const Text("Person List"),
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
                : ListView.builder(
                    itemCount: _persons.length,
                    itemBuilder: (context, index) {
                      return Card(
                          margin: const EdgeInsets.all(2),
                          child: ListTile(
                            leading: ClipOval(
                                child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: _persons[index].picture,
                              width: 44.0,
                              height: 44.0,
                            )),
                            title: Text("${_persons[index].displayName}"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PersonDetailWidget(
                                          PersonDetailViewModel(
                                              _persons[index]))));
                            },
                          ));
                    },
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
        _persons = event.data;
        _isError = false;
      });
    } else if (event is LoadFailedEvent) {
      setState(() {
        _statusMessage = event.error;
        _isError = true;
      });
    }
  }
}
