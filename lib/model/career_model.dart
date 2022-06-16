class CareerModel{
  String title;
  DateTime time;
  CareerModel({required this.title, required this.time});

  factory CareerModel.fromJson(Map<String, dynamic> json) => CareerModel(title: json['title'], time: json['time']);
}