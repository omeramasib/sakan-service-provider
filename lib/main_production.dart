import 'package:flutter/material.dart';
import 'package:sakan/app.dart';
import 'package:sakan/constants/flavor_config.dart' as config;
import 'package:sakan/flavors.dart';
import 'package:sakan/main.dart' as app;
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.production;
  config.FlavorConfig.initialize(flavor: config.Flavor.production);

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://c749e3eb4d19e269c866ed08d1a34648@o4510566705922048.ingest.de.sentry.io/4510851270180944';
      // Adds request headers and IP for users, for more info visit:
      // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
      options.sendDefaultPii = true;
      options.enableLogs = true;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
      // Configure Session Replay
      options.replay.sessionSampleRate = 0.1;
      options.replay.onErrorSampleRate = 1.0;
    },
    appRunner: () => app.mainCommon(
          rootWidget: SentryWidget(child: const App()),
        ),
  );
}
