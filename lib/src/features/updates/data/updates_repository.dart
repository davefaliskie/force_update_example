import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updates_repository.g.dart';

class UpdatesRepository {
  // Get the current device app version
  Future<int> deviceBuildNum() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return int.parse(packageInfo.buildNumber);
  }
}

@Riverpod(keepAlive: true)
UpdatesRepository updatesRepository(UpdatesRepositoryRef ref) {
  return UpdatesRepository();
}

@Riverpod(keepAlive: true)
Future<int> deviceBuild(DeviceBuildRef ref) async {
  final updatesRepository = ref.watch(updatesRepositoryProvider);
  return await updatesRepository.deviceBuildNum();
}
