// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get landingAppTitle => 'Hydroponic IoT \nPlatform';

  @override
  String get landingAppSubtitle =>
      'is a platform that allows you to monitor and control your hydroponic needs seamlessly.';

  @override
  String get getStartedButton => 'GET STARTED';

  @override
  String get signInTitle => 'SIGN IN';

  @override
  String get signInSubtitle => 'Welcome back! Please sign in to continue.';

  @override
  String get or => 'OR';

  @override
  String get signInWithGoogle => 'Sign In with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get register => 'Register';

  @override
  String get registerTitle => 'REGISTER';

  @override
  String get registerSubtitle =>
      'Looks like you don\\\'t have an account! Please fill the form to create an account.';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get clickingRegister => 'By clicking \"REGISTER\", you agree to our ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get signUpWithGoogle => 'Sign Up with Google';

  @override
  String get googleSignInNotSupported =>
      'Google Sign-In is not supported on this device.';

  @override
  String get thisMayTakeAMoment => 'This may take a moment...';

  @override
  String get signingYouIn => 'Signing you in...';

  @override
  String get creatingYourAccount => 'Creating your account...';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get registrationSuccessful =>
      'Registration successful! You can now sign in.';

  @override
  String get fillAllFields => 'Please fill all fields.';

  @override
  String get invalidEmail => 'Please enter a valid email address.';

  @override
  String get filterSessions => 'Filter Sessions';

  @override
  String get plantSessions => 'Plant Sessions';

  @override
  String get noSessionsFound => 'No sessions found.';

  @override
  String get addSession => 'Add Session';

  @override
  String get welcome => 'Welcome';

  @override
  String get devices => 'Devices';

  @override
  String get notifications => 'Notifications';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get addNewSession => 'Add New Session';

  @override
  String get addDevice => 'Add Device';

  @override
  String get addDeviceInfo => 'Add Device Info';

  @override
  String get deviceName => 'Device Name';

  @override
  String get serialNumber => 'Serial Number';

  @override
  String get deviceDescription => 'Device Description';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get cancelAddDevice => 'Cancel adding device?';

  @override
  String get areYouSureCancelAddDevice =>
      'Are you sure you want to cancel adding the device? All entered information will be lost.';

  @override
  String get registeringYourDevice => 'Registering your device...';

  @override
  String get deviceAddedSuccessfully =>
      'Your device has been added successfully.';

  @override
  String get readyToPair => 'Ready to Pair?';

  @override
  String get addStep1 =>
      '1. Re-configure your tethering SSID and Password according to the instructions provided on the IoT device.';

  @override
  String get addStep2 => '2. Make sure your IoT device is turned on.';

  @override
  String get addStep3 =>
      '3. The IoT device will automatically connect to the hotspot using the configured SSID and Password.';

  @override
  String get addStep4 =>
      '4. Once your IoT device is connected to the hotspot, it will automatically pair with the app.';

  @override
  String get deviceInformation => 'Device Information';

  @override
  String get pairingConfiguration => 'Pairing Configuration';

  @override
  String get exportData => 'Export Data';

  @override
  String get chooseExportFormat =>
      'Choose format and we\\\'ll generate a file for your selected date range.';
}
