import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';


import '../configs/base_url_config.dart';

class FilePermissionService {
  static final FilePermissionService file_permission_service =
      FilePermissionService._internal();

  factory FilePermissionService() {
    return file_permission_service;
  }

  FilePermissionService._internal();

  Future<bool> askPermission(String type) async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;

    if (android.version.sdkInt < 33) {
      await Permission.storage.request();
    } else {
      if (type == "photos") {
        await Permission.photos.request();
      } else {
        await Permission.storage.request();
      }
    }

    return await getPermission(type);
  }

  Future<bool> getPermission(String type) async {
    if (BaseUrlConfig.type == "android") {
      DeviceInfoPlugin plugin = DeviceInfoPlugin();
      AndroidDeviceInfo android = await plugin.androidInfo;
      if (android.version.sdkInt < 33) {
        if (await Permission.storage.request().isGranted) {
          return true;
        } else if (await Permission.storage.request().isPermanentlyDenied) {
          await openAppSettings();
          return false;
        } else if (await Permission.storage.request().isDenied) {
          return false;
        }
      } else {
        if (type == "photos") {
          if (await Permission.photos.request().isGranted) {
            return true;
          } else if (await Permission.photos.request().isPermanentlyDenied) {
            await openAppSettings();
            return false;
          } else if (await Permission.photos.request().isDenied) {
            return false;
          }
        } else {
          if (await Permission.storage.request().isGranted) {
            return true;
          } else if (await Permission.storage.request().isPermanentlyDenied) {
            await openAppSettings();
            return false;
          } else if (await Permission.storage.request().isDenied) {
            return false;
          }
        }
      }
    } else {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
        return false;
      } else if (await Permission.storage.request().isDenied) {
        return false;
      }
    }
  }
}
