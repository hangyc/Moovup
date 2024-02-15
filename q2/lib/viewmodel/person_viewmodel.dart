import 'package:q2/model/person.dart';
import 'package:q2/repository/person_repository.dart';

import 'package:q2/mvvm/viewmodel.dart';
import 'package:q2/mvvm/observer.dart';

class PersonViewModel extends EventViewModel {
  // final PersonRepository _repository;
  final PersonRepositoryAbstract _repository;

  PersonViewModel(this._repository);

  void loadData() {
    notify(LoadingEvent(isLoading: true));
    _repository.fetchPersons().then((value) {
      notify(LoadingEvent(isLoading: false));
      onDataLoad(value);
    }).catchError((e) {
      notify(LoadingEvent(isLoading: false));
      notify(LoadFailedEvent(error: e));
    });
  }

  void onDataLoad(List<Person> data) {
    notify(DataLoadedEvent(data: data));
  }
}

class LoadingEvent extends ViewEvent {
  bool isLoading;

  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class DataLoadedEvent extends ViewEvent {
  final List<Person> data;

  DataLoadedEvent({required this.data}) : super("DataLoadedEvent");
}

class LoadFailedEvent extends ViewEvent {
  final String error;

  LoadFailedEvent({required this.error}) : super("LoadFailedEvent");
}
