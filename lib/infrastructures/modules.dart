import "package:injectable/injectable.dart";
import "package:package_info_plus/package_info_plus.dart";

@module
abstract class InfrastructuresModules {
  @singleton
  @preResolve
  Future<PackageInfo> getPackageInfo() {
    return PackageInfo.fromPlatform();
  }
}
