import 'package:force_update_example/src/features/updates/domain/build_version.dart';
import 'package:force_update_example/src/features/updates/domain/update_status.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updates_repository.g.dart';

class UpdatesRepository {
  // Get the current device app version
  Future<int> deviceBuildNum() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return int.parse(packageInfo.buildNumber);
  }

  // Retrieve the BuildVersion from our API
  Future<BuildVersion?> buildVersionInfo() async {
    // Make an API request to get you app's build version Info
    return Future.value(
      const BuildVersion(
        minBuild: 2,
        deployedBuild: 3,
      ),
    );
  }

  Future<UpdateStatus> deviceUpdateStatus() async {
    BuildVersion? buildVersion = await buildVersionInfo();
    if (buildVersion == null) {
      return UpdateStatus.none;
    }

    int minBuild = buildVersion.minBuild;
    int deployedBuild = buildVersion.deployedBuild;
    int deviceBuild = await deviceBuildNum();

    // the minBuild should NEVER be higher than the deployedBuild
    if (minBuild > deployedBuild) {
      minBuild = deployedBuild;
    }

    // if deviceBuild is less than minBuild REQUIRE update
    if (deviceBuild < minBuild) {
      return UpdateStatus.mandatory;
    }

    // if deviceBuild is less than deployedBuild we have an optional update
    if (deviceBuild < deployedBuild) {
      return UpdateStatus.optional;
    }

    return UpdateStatus.none;
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

@Riverpod(keepAlive: true)
Future<UpdateStatus> deviceUpdateStatus(DeviceUpdateStatusRef ref) async {
  final updatesRepository = ref.watch(updatesRepositoryProvider);
  return await updatesRepository.deviceUpdateStatus();
}
