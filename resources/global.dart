import 'package:get_it/get_it.dart';
import 'package:sermons_audio/resources/audio_resources.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/resources/methods_for_update_2026.dart';
import 'package:sermons_audio/resources/screen_dimensions.dart';

final locator = GetIt.instance;
//Data to be accesable anywhere in the app
void setupLocator() {
  locator.registerLazySingleton<LocalData>(() => LocalData());
  locator.registerLazySingleton<AuthMethods>(() => AuthMethods());
  locator.registerLazySingleton<FirestoreMethods>(() => FirestoreMethods());
  locator.registerLazySingleton<AudioResources>(() => AudioResources());
  locator.registerLazySingleton<ScreenDimensions>(() => ScreenDimensions());
  locator.registerLazySingleton<MethodsForUpdate2026>(
      () => MethodsForUpdate2026());
}
