class Univ {
  Univ(
      {required this.id,
      required this.univname,
      required this.email,
      required this.univlogo});

  int id;
  String univname;
  String email;
  String univlogo;

  String get shortUnivName => univname.replaceAll("학교", "");

  factory Univ.fromJson(Map<String, dynamic> json) => Univ(
      id: json["id"] ?? 0,
      univname: json["school"] ?? "",
      email: json["email"] ?? "",
      univlogo: json["logo"] ?? "");

  factory Univ.defaultUniv() =>
      Univ(id: 0, univname: "", email: "", univlogo: '');
}

class Dept {
  Dept({required this.id, required this.deptname});

  int id;
  String deptname;

  factory Dept.fromJson(Map<String, dynamic> json) => Dept(
        id: json["id"] ?? 0,
        deptname: json["department"] ?? "",
      );

  factory Dept.defaultDept() => Dept(id: 0, deptname: "");
}
