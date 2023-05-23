import 'dart:convert';

class User {
  int id;
  String email;
  String username;
  String password;
  Name name;
  Address address;
  String phone;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory User.fromJson(String json) {
    return User.fromMap(jsonDecode(json));
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  static List<User> fromJsonList(String json) {
    List<dynamic> jsonList = jsonDecode(json);
    List<User> userList = [];
    for (var json in jsonList) {
      userList.add(User.fromMap(json));
    }
    return userList;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
    id: map['id'],
    email: map['email'],
    username: map['username'],
    password: map['password'],
    name: Name.fromMap(map['name']),
    address: Address.fromMap(map['address']),
    phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
    'id': id,
    'email': email,
    'username': username,
    'password': password,
    'name': name.toMap(),
    'address': address.toMap(),
    'phone': phone,
    };
  }
}

class Name {
  String firstname;
  String lastname;

  Name({required this.firstname, required this.lastname});

  factory Name.fromJson(String json) {
    return Name.fromMap(jsonDecode(json));
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Name.fromMap(Map<String, dynamic> map) {
    return Name(
      firstname: map['firstname'],
      lastname: map['lastname'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}

class Address {
  String city;
  String street;
  int number;
  String zipcode;
  GeoLocation geolocation;

  Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  factory Address.fromJson(String json) {
    return Address.fromMap(jsonDecode(json));
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      city: map['city'],
      street: map['street'],
      number: map['number'],
      zipcode: map['zipcode'],
      geolocation: GeoLocation.fromMap(map['geolocation']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'street': street,
      'number': number,
      'zipcode': zipcode,
      'geolocation': geolocation.toMap(),
    };
  }

}

class GeoLocation {
  String lat;
  String long;

  GeoLocation({required this.lat, required this.long});

  factory GeoLocation.fromJson(String json) {
    return GeoLocation.fromMap(jsonDecode(json));
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory GeoLocation.fromMap(Map<String, dynamic> map) {
    return GeoLocation(
      lat: map['lat'],
      long: map['long'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'long': long,
    };
  }
}
