// report_model.dart

class ReportModel {
  final String userEmail;
  final String heartRate;
  final String bloodGroup;
  final String weight;
  final String doctorReport;

  ReportModel({
    required this.userEmail,
    required this.heartRate,
    required this.bloodGroup,
    required this.weight,
    required this.doctorReport,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      userEmail: json['userEmail'] ?? '',
      heartRate: json['heartRate'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      weight: json['weight'] ?? '',
      doctorReport: json['doctorReport'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'heartRate': heartRate,
      'bloodGroup': bloodGroup,
      'weight': weight,
      'doctorReport': doctorReport,
    };
  }
}
