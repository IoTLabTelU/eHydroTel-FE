import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @landingAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Grow Smart,\nLive Green'**
  String get landingAppTitle;

  /// No description provided for @landingAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control your hydroponic\nsystem effortlessly'**
  String get landingAppSubtitle;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedButton;

  /// No description provided for @anytime.
  ///
  /// In en, this message translates to:
  /// **'Anytime'**
  String get anytime;

  /// No description provided for @anywhere.
  ///
  /// In en, this message translates to:
  /// **'Anywhere'**
  String get anywhere;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please sign in to continue.'**
  String get signInSubtitle;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with email'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Looks like you don\\\'t have an account! Please fill the form to create an account.'**
  String get registerSubtitle;

  /// No description provided for @authDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our'**
  String get authDisclaimer;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @clickingRegister.
  ///
  /// In en, this message translates to:
  /// **'By clicking \"REGISTER\", you agree to our '**
  String get clickingRegister;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up with Google'**
  String get signUpWithGoogle;

  /// No description provided for @googleSignInNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In is not supported on this device.'**
  String get googleSignInNotSupported;

  /// No description provided for @thisMayTakeAMoment.
  ///
  /// In en, this message translates to:
  /// **'This may take a moment...'**
  String get thisMayTakeAMoment;

  /// No description provided for @signingYouIn.
  ///
  /// In en, this message translates to:
  /// **'Signing you in...'**
  String get signingYouIn;

  /// No description provided for @creatingYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating your account...'**
  String get creatingYourAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your Account or Password?'**
  String get forgotPassword;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! You can now sign in.'**
  String get registrationSuccessful;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get fillAllFields;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @filterSessions.
  ///
  /// In en, this message translates to:
  /// **'Filter Sessions'**
  String get filterSessions;

  /// No description provided for @filterDevices.
  ///
  /// In en, this message translates to:
  /// **'Filter Devices'**
  String get filterDevices;

  /// No description provided for @plantSessions.
  ///
  /// In en, this message translates to:
  /// **'Plant Sessions'**
  String get plantSessions;

  /// No description provided for @allSessions.
  ///
  /// In en, this message translates to:
  /// **'All Sessions'**
  String get allSessions;

  /// No description provided for @noSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'No sessions found.'**
  String get noSessionsFound;

  /// No description provided for @addSession.
  ///
  /// In en, this message translates to:
  /// **'Add Session'**
  String get addSession;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Hi there'**
  String get welcome;

  /// No description provided for @letsgrow.
  ///
  /// In en, this message translates to:
  /// **'Let\'s grow something'**
  String get letsgrow;

  /// No description provided for @amazing.
  ///
  /// In en, this message translates to:
  /// **'amazing'**
  String get amazing;

  /// No description provided for @yourDevices.
  ///
  /// In en, this message translates to:
  /// **'Your Devices'**
  String get yourDevices;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @newSession.
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get newSession;

  /// No description provided for @addDevice.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get addDevice;

  /// No description provided for @addDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device Info'**
  String get addDeviceInfo;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// No description provided for @serialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get serialNumber;

  /// No description provided for @deviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Device Description'**
  String get deviceDescription;

  /// No description provided for @warningNoDeviceFound.
  ///
  /// In en, this message translates to:
  /// **'No device found. Please add a device first.'**
  String get warningNoDeviceFound;

  /// No description provided for @deviceSummary.
  ///
  /// In en, this message translates to:
  /// **'Device Summary'**
  String get deviceSummary;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @oof.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get oof;

  /// No description provided for @plantedAt.
  ///
  /// In en, this message translates to:
  /// **'Planted at'**
  String get plantedAt;

  /// No description provided for @loadingDevice.
  ///
  /// In en, this message translates to:
  /// **'Loading devices...'**
  String get loadingDevice;

  /// No description provided for @cancelAddDevice.
  ///
  /// In en, this message translates to:
  /// **'Cancel adding device?'**
  String get cancelAddDevice;

  /// No description provided for @areYouSureCancelAddDevice.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel adding the device? All entered information will be lost.'**
  String get areYouSureCancelAddDevice;

  /// No description provided for @registeringYourDevice.
  ///
  /// In en, this message translates to:
  /// **'Registering your device...'**
  String get registeringYourDevice;

  /// No description provided for @deviceAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your device has been added successfully.'**
  String get deviceAddedSuccessfully;

  /// No description provided for @readyToPair.
  ///
  /// In en, this message translates to:
  /// **'Ready to Pair?'**
  String get readyToPair;

  /// No description provided for @addStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Re-configure your tethering SSID and Password according to the instructions provided on the IoT device.'**
  String get addStep1;

  /// No description provided for @addStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Make sure your IoT device is turned on.'**
  String get addStep2;

  /// No description provided for @addStep3.
  ///
  /// In en, this message translates to:
  /// **'3. The IoT device will automatically connect to the hotspot using the configured SSID and Password.'**
  String get addStep3;

  /// No description provided for @addStep4.
  ///
  /// In en, this message translates to:
  /// **'4. Once your IoT device is connected to the hotspot, it will automatically pair with the app.'**
  String get addStep4;

  /// No description provided for @deviceInformation.
  ///
  /// In en, this message translates to:
  /// **'Device Information'**
  String get deviceInformation;

  /// No description provided for @pairingConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Pairing Configuration'**
  String get pairingConfiguration;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @chooseExportFormat.
  ///
  /// In en, this message translates to:
  /// **'Choose format and we\\\'ll generate a file for your selected date range.'**
  String get chooseExportFormat;

  /// No description provided for @loadingCropCycles.
  ///
  /// In en, this message translates to:
  /// **'Loading crop cycles...'**
  String get loadingCropCycles;

  /// No description provided for @noCropCyclesFound.
  ///
  /// In en, this message translates to:
  /// **'No crop cycles found. Please add crop cycle session first.'**
  String get noCropCyclesFound;

  /// No description provided for @searchCropCycles.
  ///
  /// In en, this message translates to:
  /// **'Search crop cycles...'**
  String get searchCropCycles;

  /// No description provided for @startTypingToSearch.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search...'**
  String get startTypingToSearch;

  /// No description provided for @searchDevices.
  ///
  /// In en, this message translates to:
  /// **'Search by device name, serial, or SSID...'**
  String get searchDevices;

  /// No description provided for @accountNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Account not supported'**
  String get accountNotSupported;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @phOverTime.
  ///
  /// In en, this message translates to:
  /// **'pH over time'**
  String get phOverTime;

  /// No description provided for @ppmOverTime.
  ///
  /// In en, this message translates to:
  /// **'PPM over time'**
  String get ppmOverTime;

  /// No description provided for @harvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get harvest;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterYourRegisteredEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email to\nreset your password.'**
  String get enterYourRegisteredEmail;

  /// No description provided for @youReceiveOneTimeCode.
  ///
  /// In en, this message translates to:
  /// **'You\'ll receive one-time code\nto your email'**
  String get youReceiveOneTimeCode;

  /// No description provided for @forgotYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotYourPassword;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @digitCode.
  ///
  /// In en, this message translates to:
  /// **'and enter the 6-digit code here.'**
  String get digitCode;

  /// No description provided for @noCode.
  ///
  /// In en, this message translates to:
  /// **'No code in your inbox?'**
  String get noCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a new, strong\npassword for your account.'**
  String get createNewPassword;

  /// No description provided for @makeSureItsSomething.
  ///
  /// In en, this message translates to:
  /// **'Make sure it\'s something you can\nremember easily.'**
  String get makeSureItsSomething;

  /// No description provided for @verifyingCode.
  ///
  /// In en, this message translates to:
  /// **'Verifying code...'**
  String get verifyingCode;

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'OTP code has been resent successfully.'**
  String get otpResent;

  /// No description provided for @resettingPassword.
  ///
  /// In en, this message translates to:
  /// **'Resetting password...'**
  String get resettingPassword;

  /// No description provided for @passwordResetSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Password has been reset successfully. You can now log in with your new password.'**
  String get passwordResetSuccessful;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @searchSessionOrPlants.
  ///
  /// In en, this message translates to:
  /// **'Search sessions or plants'**
  String get searchSessionOrPlants;

  /// No description provided for @findAndManage.
  ///
  /// In en, this message translates to:
  /// **'Find and manage your growing spaces'**
  String get findAndManage;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryAnotherName.
  ///
  /// In en, this message translates to:
  /// **'Try another name or check your spelling'**
  String get tryAnotherName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @autoSetBasedOnPlantType.
  ///
  /// In en, this message translates to:
  /// **'Auto-set based on your plant type'**
  String get autoSetBasedOnPlantType;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @thresholdSettings.
  ///
  /// In en, this message translates to:
  /// **'Threshold Settings'**
  String get thresholdSettings;

  /// No description provided for @rangeAvailable.
  ///
  /// In en, this message translates to:
  /// **'Range Available'**
  String get rangeAvailable;

  /// No description provided for @customizeValues.
  ///
  /// In en, this message translates to:
  /// **'Customize values'**
  String get customizeValues;

  /// No description provided for @revertToAutoValues.
  ///
  /// In en, this message translates to:
  /// **'Revert to auto values'**
  String get revertToAutoValues;

  /// No description provided for @editSession.
  ///
  /// In en, this message translates to:
  /// **'Edit Session'**
  String get editSession;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
