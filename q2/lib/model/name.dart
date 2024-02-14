class Name {
  Name(this.last, this.first);

  final String last;
  final String first;

  Name.fromJson(Map<String, dynamic> json)
      : last = json['last'],
        first = json['first'];

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'last': last, 'first': first};
}
