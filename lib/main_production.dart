import 'package:sakan/constants/flavor_config.dart' as config;
import 'package:sakan/flavors.dart';
import 'package:sakan/main.dart' as app;

void main() {
  F.appFlavor = Flavor.production;
  config.FlavorConfig.initialize(flavor: config.Flavor.production);
  app.main();
}
