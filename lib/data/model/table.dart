class TableModel {
  final String id;
  final String? tableCode;
  final int? capacity;
  final String? status;

  TableModel({
    required this.id,
    this.tableCode,
    this.capacity,
    this.status,
  });

  /// FROM JSON (API → APP)
  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] ?? '',
      tableCode: json['tableCode'] as String?,
      capacity: json['capacity'] as int?,
      status: json['status'] as String?,
    );
  }

  /// TO JSON (APP → API nếu cần)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableCode': tableCode,
      'capacity': capacity,
      'status': status,
    };
  }
}
