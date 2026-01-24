import 'package:orderly/config/api_provider.dart';
import 'package:orderly/data/model/table.dart';
import 'package:orderly/data/type/api_responses.dart';

class TableService {
  final api = ApiProvider.apiClient;

  Future<List<TableModel>> getTables({
  int page = 0,
  int size = 10,
}) async {
  final response = await api.get(
    '/tables',
    query: {
      'page': page,
      'size': size,
    },
  );

  final apiResponse = ApiResponse<List<TableModel>>.fromJson(
    response.data,
    (json) {
      final List items = json['items'] ?? [];
      return items.map((item) => TableModel.fromJson(item)).toList();
    },
  );

  if (!apiResponse.succeed || apiResponse.data == null) {
    throw Exception(apiResponse.message ?? 'Get tables failed');
  }

  return apiResponse.data!;
}
}
