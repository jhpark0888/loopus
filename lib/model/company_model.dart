class Company{
  Company({required this.companyImage, required this.companyName, required this.contactField});
  String companyImage; 
  String companyName;
  String contactField;

  factory Company.fromJson(Map<String,dynamic>json) => Company(companyImage: json['company_image'], companyName: json['company_name'], contactField: json['contact_field']);
}