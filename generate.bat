@call flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart -O "lib/presentation/ui/resources" -S "assets/translations"
@call flutter pub run build_runner build --delete-conflicting-outputs

