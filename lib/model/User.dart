class User {
  int? id;
  String? name;
  String? email;
  String? description;

  userMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['name'] = name!;
    mapping['email'] = email!;
    mapping['description'] = description!;
    return mapping;
  }
}
