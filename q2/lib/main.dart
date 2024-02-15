import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:q2/network/person_list_network_service.dart';

import 'package:q2/repository/person_repository.dart';
import 'package:q2/view/person_map_view.dart';
import 'package:q2/viewmodel/person_map_viewmodel.dart';
import 'package:q2/viewmodel/person_viewmodel.dart';
import 'package:q2/storage/api_response_box.dart';
import 'package:q2/view/person_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(ApiResponseBoxAdapter());

  runApp(const Q2App());
}

class Q2App extends StatelessWidget {
  const Q2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          Q2AppWidget(PersonRepository(PersonListNetworkService(), hive: Hive)),
    );
  }
}

class Q2AppWidget extends StatefulWidget {
  const Q2AppWidget(this._repository, {super.key});

  final PersonRepository _repository;

  @override
  State<Q2AppWidget> createState() {
    // ignore: no_logic_in_create_state
    return _Q2AppWidgetState(_repository);
  }
}

class _Q2AppWidgetState extends State<Q2AppWidget> {
  _Q2AppWidgetState(this._repository);

  int _selectedIndex = 0;

  // final PersonViewModel _personViewModel;
  final PersonRepository _repository;

  late final List<Widget> _widgetOptions = <Widget>[
    PersonListWidget(PersonViewModel(_repository)),
    PersonMapWidget(PersonMapViewModel(_repository)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
