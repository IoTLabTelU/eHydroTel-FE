import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloader {
  static Future<void> downloadAndOpenFile({
    required String url,
    required String filename,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    ListFormat? listFormat,
  }) async {
    final dio = Dio();

    // 1️⃣ Minta izin storage
    // if (Platform.isAndroid) {
    //   final status = await Permission.storage.request();
    //   if (!status.isGranted) {
    //     throw Exception('Storage permission denied');
    //   }
    // }

    // 2️⃣ Tentukan folder penyimpanan
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$filename';

    // 3️⃣ Download file
    final response = await dio.get<List<int>>(
      url,
      // filePath,
      options: Options(
        responseType: ResponseType.bytes,
        headers: headers,
        contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        listFormat: listFormat,
      ),
      queryParameters: queryParameters,
      onReceiveProgress: (count, total) {
        if (total > 0) {
          print('Downloading: ${(count / total * 100).toStringAsFixed(0)}%');
        }
      },
    );
    final file = File(filePath);
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data!);
    await raf.close();
  }
}
