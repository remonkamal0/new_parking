import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Parky'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @phoneVerification.
  ///
  /// In en, this message translates to:
  /// **'Phone Verification'**
  String get phoneVerification;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number to receive a verification code.'**
  String get enterPhone;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @noDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No Devices Found'**
  String get noDevicesFound;

  /// No description provided for @addNewDevice.
  ///
  /// In en, this message translates to:
  /// **'Add New Device'**
  String get addNewDevice;

  /// No description provided for @buyDevice.
  ///
  /// In en, this message translates to:
  /// **'Buy Device'**
  String get buyDevice;

  /// No description provided for @showMap.
  ///
  /// In en, this message translates to:
  /// **'Show Map'**
  String get showMap;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @enableBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Enable Bluetooth'**
  String get enableBluetooth;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get enableLocation;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @scanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQr;

  /// No description provided for @enterDeviceDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Device Details'**
  String get enterDeviceDetails;

  /// No description provided for @selectDeviceType.
  ///
  /// In en, this message translates to:
  /// **'Which type of device would you like to install?'**
  String get selectDeviceType;

  /// No description provided for @bouncer.
  ///
  /// In en, this message translates to:
  /// **'Bouncer'**
  String get bouncer;

  /// No description provided for @bouncerDesc.
  ///
  /// In en, this message translates to:
  /// **'Smart Parking Barrier'**
  String get bouncerDesc;

  /// No description provided for @terminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get terminal;

  /// No description provided for @terminalDesc.
  ///
  /// In en, this message translates to:
  /// **'Smart Gate Manager'**
  String get terminalDesc;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @searchParking.
  ///
  /// In en, this message translates to:
  /// **'Search for parking...'**
  String get searchParking;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'Under \$5'**
  String get filterAll;

  /// No description provided for @filterEV.
  ///
  /// In en, this message translates to:
  /// **'EV Charging'**
  String get filterEV;

  /// No description provided for @filterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get filterOpen;

  /// No description provided for @reserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserve;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @bluetoothAccess.
  ///
  /// In en, this message translates to:
  /// **'Enable Bluetooth:'**
  String get bluetoothAccess;

  /// No description provided for @bluetoothDesc.
  ///
  /// In en, this message translates to:
  /// **'To enable seamless access and helpful prompts, we need access to your device\'s Bluetooth.'**
  String get bluetoothDesc;

  /// No description provided for @locationAccess.
  ///
  /// In en, this message translates to:
  /// **'Enable Location:'**
  String get locationAccess;

  /// No description provided for @locationDesc.
  ///
  /// In en, this message translates to:
  /// **'For a tailored experience and to provide location-based features, we\'d like to access your device\'s location.'**
  String get locationDesc;

  /// No description provided for @whyNeedAccess.
  ///
  /// In en, this message translates to:
  /// **'Why we need access:'**
  String get whyNeedAccess;

  /// No description provided for @reason1.
  ///
  /// In en, this message translates to:
  /// **'Connect with devices'**
  String get reason1;

  /// No description provided for @reason2.
  ///
  /// In en, this message translates to:
  /// **'Sync choices and settings'**
  String get reason2;

  /// No description provided for @reason3.
  ///
  /// In en, this message translates to:
  /// **'Navigation and guidance'**
  String get reason3;

  /// No description provided for @alignQr.
  ///
  /// In en, this message translates to:
  /// **'Align QR Code'**
  String get alignQr;

  /// No description provided for @scanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Place the parking meter\'s code within the frame. It will be detected automatically.'**
  String get scanInstruction;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Code Manually'**
  String get enterManually;

  /// No description provided for @torch.
  ///
  /// In en, this message translates to:
  /// **'Torch'**
  String get torch;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @serialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get serialNumber;

  /// No description provided for @snPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'XXXX-XXXX-XXXX'**
  String get snPlaceholder;

  /// No description provided for @whereFindSn.
  ///
  /// In en, this message translates to:
  /// **'Where search I find my serial number?'**
  String get whereFindSn;

  /// No description provided for @unlockParking.
  ///
  /// In en, this message translates to:
  /// **'Unlock parking space'**
  String get unlockParking;

  /// No description provided for @unlockDesc.
  ///
  /// In en, this message translates to:
  /// **'Do you want to unlock the parking space number 1? Please scan the QR code to use the device.'**
  String get unlockDesc;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @turnOnFlash.
  ///
  /// In en, this message translates to:
  /// **'TURN ON FLASHLIGHT'**
  String get turnOnFlash;

  /// No description provided for @scanToPark.
  ///
  /// In en, this message translates to:
  /// **'SCAN TO PARK'**
  String get scanToPark;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @scanCode.
  ///
  /// In en, this message translates to:
  /// **'Scan Code'**
  String get scanCode;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @primaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary color'**
  String get primaryColor;

  /// No description provided for @secondaryColor.
  ///
  /// In en, this message translates to:
  /// **'Secondary/Accent color'**
  String get secondaryColor;

  /// No description provided for @backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get backgroundColor;

  /// No description provided for @textColorOptional.
  ///
  /// In en, this message translates to:
  /// **'Text color (optional)'**
  String get textColorOptional;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get resetToDefault;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By clicking login, you agree to our Terms of Service and Privacy Policy'**
  String get termsAndPrivacy;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceiveCode;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'NEED HELP?'**
  String get needHelp;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'E-Mail Support'**
  String get emailSupport;

  /// No description provided for @whatsappSupport.
  ///
  /// In en, this message translates to:
  /// **'Whatsapp Support'**
  String get whatsappSupport;

  /// No description provided for @profileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile Details'**
  String get profileDetails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @licensePlate.
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// No description provided for @communicationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Communication Preferences'**
  String get communicationPreferences;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @saveTheSelection.
  ///
  /// In en, this message translates to:
  /// **'SAVE THE SELECTION'**
  String get saveTheSelection;

  /// No description provided for @reachOutDirectlyFor.
  ///
  /// In en, this message translates to:
  /// **'Reach out directly for:'**
  String get reachOutDirectlyFor;

  /// No description provided for @contactViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact via E-mail'**
  String get contactViaEmail;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
