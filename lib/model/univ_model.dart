class Univ {
  Univ({required this.id, required this.univname, required this.email});

  int id;
  String univname;
  String email;

  factory Univ.fromJson(Map<String, dynamic> json) => Univ(
      id: json["id"] ?? 0,
      univname: json["school"] ?? "",
      email: json["email"] ?? "");

  factory Univ.defalut() => Univ(id: 0, univname: "", email: "");
}

class Dept {
  Dept({required this.id, required this.deptname});

  int id;
  String deptname;

  factory Dept.fromJson(Map<String, dynamic> json) => Dept(
        id: json["id"] ?? 0,
        deptname: json["department"] ?? "",
      );

  factory Dept.defalut() => Dept(id: 0, deptname: "");
}
