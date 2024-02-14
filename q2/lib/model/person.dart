import 'location.dart';
import 'name.dart';

class Person {
  Person(this._id, this.name, this.email, this.picture, this.location);

  final String _id;
  final Name name;
  final String email;
  final String picture;
  final Location location;

  Person.fromJson(Map<String, dynamic> json)
      : _id = json['_id'],
        name = Name.fromJson(json['name']),
        email = json['email'],
        picture = json['picture'],
        location = Location.fromJson(json['location']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': _id,
        'name': name.toJson(),
        'email': email,
        'picture': picture,
        'location': location.toJson()
      };
}

// "_id": "ae736d8f-5a08-4bab-8e30-1eb2079e5dc2",
// "name": {
//     "last": "Bass",
//     "first": "Bradley"
// },
// "email": "aida.griffith@sybixtex.show",
// "picture": "https://placebear.com/225/210",
// "location": {
//     "latitude": 22.38,
//     "longitude": null
// }