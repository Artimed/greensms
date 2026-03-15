import 'package:flutter/material.dart';
import 'package:zelenaya_sms/l10n/app_localizations.dart';

import '../core/l10n/l10n.dart';
import '../core/services/bank/bank_registry_service.dart';
import '../core/services/bank/command_builder_service.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/gradient_button.dart';
import '../features/home/presentation/home_page.dart';
import '../features/qr/presentation/qr_hub_page.dart';
import '../features/settings/presentation/settings_page.dart';
import 'app_controller.dart';
import 'bootstrap.dart';
import 'di/service_locator.dart';

class ZelenayaSmsApp extends StatefulWidget {
  const ZelenayaSmsApp({super.key, this.bootstrapFn});
  final Future<AppController> Function()? bootstrapFn;

  @override
  State<ZelenayaSmsApp> createState() => _ZelenayaSmsAppState();
}

class _ZelenayaSmsAppState extends State<ZelenayaSmsApp> {
  AppController? _controller;
  bool _loading = true;

  static final _lightTheme = AppTheme.light;
  static final _darkTheme = AppTheme.dark;

  @override
  void initState() {
    super.initState();
    (widget.bootstrapFn ?? bootstrapApplication)()
        .then((controller) {
          controller.addListener(_rebuild);
          if (mounted) {
            setState(() {
              _controller = controller;
              _loading = false;
            });
          }
        })
        .catchError((Object error) {
          if (mounted) setState(() => _loading = false);
        });
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.removeListener(_rebuild);
    super.dispose();
  }

  ThemeMode get _themeMode {
    return switch (_controller?.settings.themeMode) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  Locale get _locale {
    final code = _controller?.settings.localeCode ?? 'en';
    return switch (code) {
      'ru' => const Locale('ru'),
      'hi' => const Locale('hi'),
      'kk' => const Locale('kk'),
      'uz' => const Locale('uz'),
      // Keep backward compatibility for previously saved "tl".
      'tl' => const Locale('fil'),
      'fil' => const Locale('fil'),
      'id' => const Locale('id'),
      'vi' => const Locale('vi'),
      'hy' => const Locale('hy'),
      'ur' => const Locale('ur'),
      'bn' => const Locale('bn'),
      _ => const Locale('en'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    Widget home;
    if (_loading || controller == null) {
      home = const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (!controller.settings.onboardingDone) {
      home = OnboardingPage(controller: controller);
    } else {
      home = MainShell(controller: controller);
    }

    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.controller});

  final AppController controller;

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => Scaffold(
          appBar: AppBar(title: Text(routeContext.l10n.settingsTitle)),
          body: SafeArea(
            child: SettingsPage(
              controller: controller,
              bankRegistry: sl<BankRegistryService>(),
            ),
          ),
        ),
      ),
    );
  }

  void _openQrHub(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QrHubPage(
          controller: controller,
          bankRegistry: sl<BankRegistryService>(),
          commandBuilder: sl<CommandBuilderService>(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            onPressed: () => _openSettings(context),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
          ),
        ],
      ),
      body: SafeArea(
        child: HomePage(
          controller: controller,
          bankRegistry: sl<BankRegistryService>(),
          onOpenQr: () => _openQrHub(context),
          onOpenSettings: () => _openSettings(context),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientDiag,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/icons/app_icon_source.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.onboardingSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),
              _InfoRow(
                icon: Icons.phone_android,
                text: l10n.onboardingFeatureLocal,
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.sms_outlined,
                text: l10n.onboardingFeatureSms,
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.lock_outline,
                text: l10n.onboardingFeaturePrivacy,
              ),
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.qr_code, text: l10n.onboardingFeatureQr),
              const Spacer(),
              GradientButton(
                onPressed: controller.completeOnboarding,
                icon: const Icon(Icons.security),
                label: Text(l10n.onboardingButton),
                width: double.infinity,
                height: 52,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }
}
