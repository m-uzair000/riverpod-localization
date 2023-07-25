import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/extention.dart';
import 'package:localization/localization/app_localization.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var langRef = ref.watch(langProviderRef);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: langRef.supportedLocales(),
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      locale: langRef.locale,
      home: const Home(),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var langRef = ref.watch(langProviderRef);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'title'.trans(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () async {
                  langRef.changeLange(context, 'en');
                },
                child: Text("English")),
            TextButton(
                onPressed: () async {
                  langRef.changeLange(context, 'ar');
                },
                child: Text("Arabic")),
            TextButton(
                onPressed: () async {
                  langRef.changeLange(context, 'da');
                },
                child: Text("Danish")),
            TextButton(
                onPressed: () async {
                  langRef.changeLange(context, 'ur');
                },
                child: Text("Urdu")),
          ],
        ),
      ),
    );
  }
}
