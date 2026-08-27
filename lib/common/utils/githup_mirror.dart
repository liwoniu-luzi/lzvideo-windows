class GitHubMirror {
  final String owner;
  final String repo;
  final String branch;
  final String cdnDomain;

  GitHubMirror({
    required this.owner,
    required this.repo,
    this.branch = 'master',
    this.cdnDomain = 'gh.lz1861.ccwu.cc',
  });

  /// 单个文件路径生成（GitHub Raw 官方直连）
  String rawUrl(String filePath) {
    return 'https://raw.githubusercontent.com/$owner/$repo/$branch/$filePath';
  }

  /// 自有 Cloudflare 专属 CDN 加速地址（免代理直连）
  String cdnRawUrl(String filePath) {
    return 'https://$cdnDomain/raw/$branch/$filePath';
  }

  /// 生成镜像线路（优先使用自有 Cloudflare 专属 CDN 加速，官方直连兜底，已完全剔除第三方镜像）
  List<String> mirrors(String filePath) {
    final cdn = cdnRawUrl(filePath);
    final raw = rawUrl(filePath);
    return List.unmodifiable({cdn, raw});
  }
}
