import 'dart:io';

import 'package:pure_live/common/index.dart';
import 'package:pure_live/common/widgets/download_apk_dialog.dart';

Future<bool> requestStorageInstallPermission() async {
  if (await Permission.requestInstallPackages.isDenied) {
    final status = Permission.requestInstallPackages.request();
    return status.isGranted;
  }
  return true;
}

/// 用户自有 Cloudflare 专属 CDN 加速域名（免代理直连）
const String customCdnDomain = 'gh.lz1861.ccwu.cc';

List<String> getMirrorUrls(String apkUrl, {bool githubOriginOnly = false}) {
  if (apkUrl.trim().isEmpty) return const [];
  if (githubOriginOnly) return [apkUrl];

  // 将 GitHub Releases 下载链接转为用户自有 Cloudflare 专属 CDN 节点加速地址
  final cdnUrl = apkUrl.startsWith('https://github.com/')
      ? 'https://$customCdnDomain/${apkUrl.substring(19)}'
      : apkUrl;

  final urls = <String>[];
  if (cdnUrl != apkUrl) {
    urls.add(cdnUrl);
  }
  urls.add(apkUrl);
  return urls.toSet().toList(growable: false);
}

Future<void> downloadAndInstallApk(String apkUrl, {String? fileName}) async {
  if (Platform.isAndroid) {
    try {
      final hasInstallPermission = await requestStorageInstallPermission();
      if (!hasInstallPermission) {
        ToastUtil.show(i18n("grant_install_permission"));
        openAppSettings();
        return;
      }
    } catch (e) {
      ToastUtil.show('${i18n("request_install_permission_failed")}${e.toString()}');
    }
  }
  ToastUtil.show(i18n("downloading_apk", args: {"version": VersionUtil.latestVersion}));
  Get.dialog(
    DownloadApkDialog(apkUrl: apkUrl, version: VersionUtil.latestVersion, fileName: fileName),
    barrierDismissible: false,
  );
}
