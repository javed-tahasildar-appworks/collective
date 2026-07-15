import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register your services and repositories here
  // Example:
  // locator.registerLazySingleton<SomeService>(() => SomeServiceImpl());
  // locator.registerFactory<SomeRepository>(() => SomeRepositoryImpl());

  // Get available cameras
  final cameras = await availableCameras();
  if (cameras.isNotEmpty) {
    CameraDescription cameraObj = cameras.first;
    locator.registerSingleton<CameraDescription>(cameraObj);
  } else {
    // Optionally handle the case for no camera (e.g., register a mock, log, or skip)
    print('No cameras available on this device.');
  }
}
