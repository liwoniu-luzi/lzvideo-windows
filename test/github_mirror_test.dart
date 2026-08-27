import 'package:flutter_test/flutter_test.dart';
import 'package:pure_live/common/utils/githup_mirror.dart';

void main() {
  test('mirror list prioritizes custom Cloudflare CDN and keeps direct GitHub fallback', () {
    final urls = GitHubMirror(owner: 'owner', repo: 'repo', branch: 'main').mirrors('assets/config.json');

    expect(urls.first, 'https://gh.lz1861.ccwu.cc/raw/main/assets/config.json');
    expect(urls.last, 'https://raw.githubusercontent.com/owner/repo/main/assets/config.json');
    expect(urls.toSet(), hasLength(urls.length));
    expect(urls, everyElement(startsWith('https://')));
  });
}
