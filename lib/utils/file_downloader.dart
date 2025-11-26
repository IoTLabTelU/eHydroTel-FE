import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class FileDownloader {
  static Future<void> downloadAndOpenFile({
    required String url,
    required String filename,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    ListFormat? listFormat,
  }) async {
    try {
      final dio = Dio();

      if (!filename.contains('.')) {
        filename = '$filename.xlsx';
      }

      final dir = Directory('/storage/emulated/0/Download');

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final nameWithoutExt = filename.split('.').first;
      final extension = filename.split('.').last;
      final uniqueFilename = '${nameWithoutExt}_$timestamp.$extension';

      final filePath = '${dir.path}/$uniqueFilename';

      print('Downloading to: $filePath');

      await dio.download(
        url,
        filePath,
        options: Options(headers: headers, responseType: ResponseType.bytes),
        queryParameters: queryParameters,
        onReceiveProgress: (count, total) {
          if (total > 0) {
            print('Downloading: ${(count / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      if (Platform.isAndroid) {
        final process = await Process.run('am', [
          'broadcast',
          '-a',
          'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
          '-d',
          'file://$filePath',
        ]);
        print('Media scan result: ${process.exitCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  static Future<void> download({
    required String url,
    required String filename,
    Map<String, String> headers = const {},
  }) async {
    try {
      if (!filename.contains('.')) {
        filename = '$filename.xlsx';
      }

      final dir = Directory('/storage/emulated/0/Download');

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final nameWithoutExt = filename.split('.').first;
      final fileExt = filename.split('.').last;
      final uniqueFilename = '${nameWithoutExt}_$timestamp.$fileExt';

      final filePath = '${dir.path}/$uniqueFilename';
      await FlutterDownloader.enqueue(
        url: url,
        headers: headers,
        savedDir: dir.path,
        fileName: uniqueFilename,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );
      if (Platform.isAndroid) {
        final process = await Process.run('am', [
          'broadcast',
          '-a',
          'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
          '-d',
          'file://$filePath',
        ]);
        print('Media scan result: ${process.exitCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
