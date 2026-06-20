import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/shared/network/dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});
