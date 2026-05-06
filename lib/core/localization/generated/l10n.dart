// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalization {
  AppLocalization();

  static AppLocalization? _current;

  static AppLocalization get current {
    assert(_current != null,
        'No instance of AppLocalization was loaded. Try to initialize the AppLocalization delegate before accessing AppLocalization.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalization> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalization();
      AppLocalization._current = instance;

      return instance;
    });
  }

  static AppLocalization of(BuildContext context) {
    final instance = AppLocalization.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalization present in the widget tree. Did you add AppLocalization.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalization? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  /// `من الجاسوس؟`
  String get gameTitle {
    return Intl.message(
      'من الجاسوس؟',
      name: 'gameTitle',
      desc: '',
      args: [],
    );
  }

  /// `لعبة من الجاسوس لعبة جماعية تعتمد على الذكاء والملاحظة. في كل جولة، يكون واحد من اللاعبين هو الجاسوس بدون ما يعرف كلمة السر، والباقين يعرفون الكلمة. تبدأون تسألون بعض وتتناقشون، وتحاولون تكتشفون الجاسوس. بنفس الوقت، الجاسوس يحاول يفهم الكلمة من كلامكم بدون ما يفضح نفسه.`
  String get aboutGame {
    return Intl.message(
      'لعبة من الجاسوس لعبة جماعية تعتمد على الذكاء والملاحظة. في كل جولة، يكون واحد من اللاعبين هو الجاسوس بدون ما يعرف كلمة السر، والباقين يعرفون الكلمة. تبدأون تسألون بعض وتتناقشون، وتحاولون تكتشفون الجاسوس. بنفس الوقت، الجاسوس يحاول يفهم الكلمة من كلامكم بدون ما يفضح نفسه.',
      name: 'aboutGame',
      desc: '',
      args: [],
    );
  }

  /// `تمام`
  String get understood {
    return Intl.message(
      'تمام',
      name: 'understood',
      desc: '',
      args: [],
    );
  }

  /// `عن اللعبة`
  String get aboutTheGame {
    return Intl.message(
      'عن اللعبة',
      name: 'aboutTheGame',
      desc: '',
      args: [],
    );
  }

  /// `اختر تصنيف الكلمة`
  String get chooseStoryType {
    return Intl.message(
      'اختر تصنيف الكلمة',
      name: 'chooseStoryType',
      desc: '',
      args: [],
    );
  }

  /// `اختر التصنيف اللي يناسبكم`
  String get chooseStoryTypeSubtitle {
    return Intl.message(
      'اختر التصنيف اللي يناسبكم',
      name: 'chooseStoryTypeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `ابدأ اللعب`
  String get startPlaying {
    return Intl.message(
      'ابدأ اللعب',
      name: 'startPlaying',
      desc: '',
      args: [],
    );
  }

  /// `أقل عدد لاعبين للبدء هو 3. تقدر تضيف لاعبين وتعدّل أسمائهم تحت.`
  String get minPlayersMessage {
    return Intl.message(
      'أقل عدد لاعبين للبدء هو 3. تقدر تضيف لاعبين وتعدّل أسمائهم تحت.',
      name: 'minPlayersMessage',
      desc: '',
      args: [],
    );
  }

  /// `ابدأ اللعب`
  String get startGameButton {
    return Intl.message(
      'ابدأ اللعب',
      name: 'startGameButton',
      desc: '',
      args: [],
    );
  }

  /// `إضافة لاعب`
  String get addNewPlayer {
    return Intl.message(
      'إضافة لاعب',
      name: 'addNewPlayer',
      desc: '',
      args: [],
    );
  }

  /// `تعديل اسم اللاعب`
  String get editPlayerName {
    return Intl.message(
      'تعديل اسم اللاعب',
      name: 'editPlayerName',
      desc: '',
      args: [],
    );
  }

  /// `اكتب الاسم هنا...`
  String get enterNamePlaceholder {
    return Intl.message(
      'اكتب الاسم هنا...',
      name: 'enterNamePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `إضافة`
  String get addAction {
    return Intl.message(
      'إضافة',
      name: 'addAction',
      desc: '',
      args: [],
    );
  }

  /// `تعديل`
  String get editAction {
    return Intl.message(
      'تعديل',
      name: 'editAction',
      desc: '',
      args: [],
    );
  }

  /// `لاعب 1`
  String get player1 {
    return Intl.message(
      'لاعب 1',
      name: 'player1',
      desc: '',
      args: [],
    );
  }

  /// `لاعب 2`
  String get player2 {
    return Intl.message(
      'لاعب 2',
      name: 'player2',
      desc: '',
      args: [],
    );
  }

  /// `لاعب 3`
  String get player3 {
    return Intl.message(
      'لاعب 3',
      name: 'player3',
      desc: '',
      args: [],
    );
  }

  /// `اعطوا الجوال ل`
  String get givePhoneTo {
    return Intl.message(
      'اعطوا الجوال ل',
      name: 'givePhoneTo',
      desc: '',
      args: [],
    );
  }

  /// `أنت الجاسوس! حاول تعرف ايش هي الكلمة السرية من كلام البقية أو اقنعهم يصوتون على الشخص الخطأ!`
  String get youAreOutsideStory {
    return Intl.message(
      'أنت الجاسوس! حاول تعرف ايش هي الكلمة السرية من كلام البقية أو اقنعهم يصوتون على الشخص الخطأ!',
      name: 'youAreOutsideStory',
      desc: '',
      args: [],
    );
  }

  /// `أنت تعرف السر، الكلمة هي:`
  String get youAreInsideStory {
    return Intl.message(
      'أنت تعرف السر، الكلمة هي:',
      name: 'youAreInsideStory',
      desc: '',
      args: [],
    );
  }

  /// `وقت التحقيق`
  String get questionTime {
    return Intl.message(
      'وقت التحقيق',
      name: 'questionTime',
      desc: '',
      args: [],
    );
  }

  /// `اسأل سؤال عن الكلمة السرية! اختار سؤالك بعناية عشان الجاسوس ما يعرفها`
  String get questionAboutStory {
    return Intl.message(
      'اسأل سؤال عن الكلمة السرية! اختار سؤالك بعناية عشان الجاسوس ما يعرفها',
      name: 'questionAboutStory',
      desc: '',
      args: [],
    );
  }

  /// `اسأل`
  String get ask {
    return Intl.message(
      'اسأل',
      name: 'ask',
      desc: '',
      args: [],
    );
  }

  /// `وقت التصويت`
  String get votingTime {
    return Intl.message(
      'وقت التصويت',
      name: 'votingTime',
      desc: '',
      args: [],
    );
  }

  /// `الجاسوس هو...`
  String get theOneOutsideStoryIs {
    return Intl.message(
      'الجاسوس هو...',
      name: 'theOneOutsideStoryIs',
      desc: '',
      args: [],
    );
  }

  /// `التالي`
  String get next {
    return Intl.message(
      'التالي',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `سلم الجوال للجاسوس`
  String get givePhoneToOutsider {
    return Intl.message(
      'سلم الجوال للجاسوس',
      name: 'givePhoneToOutsider',
      desc: '',
      args: [],
    );
  }

  /// `تغيير التصنيف`
  String get changeStoryType {
    return Intl.message(
      'تغيير التصنيف',
      name: 'changeStoryType',
      desc: '',
      args: [],
    );
  }

  /// `كمل اللعب`
  String get continuePlaying {
    return Intl.message(
      'كمل اللعب',
      name: 'continuePlaying',
      desc: '',
      args: [],
    );
  }

  /// `النتائج`
  String get results {
    return Intl.message(
      'النتائج',
      name: 'results',
      desc: '',
      args: [],
    );
  }

  /// `فتح`
  String get unlock {
    return Intl.message(
      'فتح',
      name: 'unlock',
      desc: '',
      args: [],
    );
  }

  /// `هالتصنيف يحتاج {coins} عملة عشان تفتحه.`
  String unlockCategoryMessage(Object coins) {
    return Intl.message(
      'هالتصنيف يحتاج $coins عملة عشان تفتحه.',
      name: 'unlockCategoryMessage',
      desc: '',
      args: [coins],
    );
  }

  /// `استئجار {name}`
  String rentCategoryTitle(Object name) {
    return Intl.message(
      'استئجار $name',
      name: 'rentCategoryTitle',
      desc: '',
      args: [name],
    );
  }

  /// `التكلفة: {coins} عملة لمدة ساعتين.`
  String rentCategoryMessage(Object coins) {
    return Intl.message(
      'التكلفة: $coins عملة لمدة ساعتين.',
      name: 'rentCategoryMessage',
      desc: '',
      args: [coins],
    );
  }

  /// `معك:`
  String get youHave {
    return Intl.message(
      'معك:',
      name: 'youHave',
      desc: '',
      args: [],
    );
  }

  /// `عملة`
  String get coins {
    return Intl.message(
      'عملة',
      name: 'coins',
      desc: '',
      args: [],
    );
  }

  /// `يمكن لاحقاً`
  String get maybeLater {
    return Intl.message(
      'يمكن لاحقاً',
      name: 'maybeLater',
      desc: '',
      args: [],
    );
  }

  /// `تم بنجاح`
  String get success {
    return Intl.message(
      'تم بنجاح',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `تم فتح التصنيف بنجاح!`
  String get categoryUnlocked {
    return Intl.message(
      'تم فتح التصنيف بنجاح!',
      name: 'categoryUnlocked',
      desc: '',
      args: [],
    );
  }

  /// `تم استئجار التصنيف لمدة ساعتين.`
  String get categoryRented {
    return Intl.message(
      'تم استئجار التصنيف لمدة ساعتين.',
      name: 'categoryRented',
      desc: '',
      args: [],
    );
  }

  /// `صار خطأ`
  String get error {
    return Intl.message(
      'صار خطأ',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `ما قدرنا نفتح التصنيف`
  String get failedToUnlock {
    return Intl.message(
      'ما قدرنا نفتح التصنيف',
      name: 'failedToUnlock',
      desc: '',
      args: [],
    );
  }

  /// `ما قدرنا نستأجر التصنيف`
  String get failedToRent {
    return Intl.message(
      'ما قدرنا نستأجر التصنيف',
      name: 'failedToRent',
      desc: '',
      args: [],
    );
  }

  /// `افتح الآن`
  String get unlockNow {
    return Intl.message(
      'افتح الآن',
      name: 'unlockNow',
      desc: '',
      args: [],
    );
  }

  /// `استأجر الآن`
  String get rentNow {
    return Intl.message(
      'استأجر الآن',
      name: 'rentNow',
      desc: '',
      args: [],
    );
  }

  /// `شاهد إعلان (+{coins} عملة)`
  String watchAdForCoins(Object coins) {
    return Intl.message(
      'شاهد إعلان (+$coins عملة)',
      name: 'watchAdForCoins',
      desc: '',
      args: [coins],
    );
  }

  /// `التكلفة`
  String get cost {
    return Intl.message(
      'التكلفة',
      name: 'cost',
      desc: '',
      args: [],
    );
  }

  /// `رصيدك`
  String get yourBalance {
    return Intl.message(
      'رصيدك',
      name: 'yourBalance',
      desc: '',
      args: [],
    );
  }

  /// `متاح لمدة ساعتين`
  String get accessFor24Hours {
    return Intl.message(
      'متاح لمدة ساعتين',
      name: 'accessFor24Hours',
      desc: '',
      args: [],
    );
  }

  /// `فتح {name}`
  String unlockCategoryTitle(Object name) {
    return Intl.message(
      'فتح $name',
      name: 'unlockCategoryTitle',
      desc: '',
      args: [name],
    );
  }

  /// `استئجار لمدة`
  String get rentFor {
    return Intl.message(
      'استئجار لمدة',
      name: 'rentFor',
      desc: '',
      args: [],
    );
  }

  /// `ساعتين`
  String get hours24 {
    return Intl.message(
      'ساعتين',
      name: 'hours24',
      desc: '',
      args: [],
    );
  }

  /// `استئجار ساعتين`
  String get rentFor24HoursButton {
    return Intl.message(
      'استئجار ساعتين',
      name: 'rentFor24HoursButton',
      desc: '',
      args: [],
    );
  }

  /// `شاهد إعلان (+{coins} عملة)`
  String watchAdCoinsButton(Object coins) {
    return Intl.message(
      'شاهد إعلان (+$coins عملة)',
      name: 'watchAdCoinsButton',
      desc: '',
      args: [coins],
    );
  }

  /// `الإعدادات`
  String get settings {
    return Intl.message(
      'الإعدادات',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `إزالة الإعلانات`
  String get removeAds {
    return Intl.message(
      'إزالة الإعلانات',
      name: 'removeAds',
      desc: '',
      args: [],
    );
  }

  /// `استمتع باللعب بدون إعلانات`
  String get removeAdsDescription {
    return Intl.message(
      'استمتع باللعب بدون إعلانات',
      name: 'removeAdsDescription',
      desc: '',
      args: [],
    );
  }

  /// `استعادة المشتريات`
  String get restorePurchases {
    return Intl.message(
      'استعادة المشتريات',
      name: 'restorePurchases',
      desc: '',
      args: [],
    );
  }

  /// `استرجع مشترياتك السابقة`
  String get restorePurchasesDescription {
    return Intl.message(
      'استرجع مشترياتك السابقة',
      name: 'restorePurchasesDescription',
      desc: '',
      args: [],
    );
  }

  /// `دعم المطور`
  String get donateToDeveloper {
    return Intl.message(
      'دعم المطور',
      name: 'donateToDeveloper',
      desc: '',
      args: [],
    );
  }

  /// `دعمك يساعدنا نطوّر اللعبة`
  String get donateDeveloperSubtitle {
    return Intl.message(
      'دعمك يساعدنا نطوّر اللعبة',
      name: 'donateDeveloperSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `تم الشراء بنجاح!`
  String get purchaseSuccessTitle {
    return Intl.message(
      'تم الشراء بنجاح!',
      name: 'purchaseSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `شكراً لشرائك`
  String get purchaseSuccessMessage {
    return Intl.message(
      'شكراً لشرائك',
      name: 'purchaseSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `شكراً لدعمك!`
  String get donationSuccessTitle {
    return Intl.message(
      'شكراً لدعمك!',
      name: 'donationSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `دعمك يفرق معنا`
  String get donationSuccessMessage {
    return Intl.message(
      'دعمك يفرق معنا',
      name: 'donationSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `تم إلغاء الشراء`
  String get purchaseCanceled {
    return Intl.message(
      'تم إلغاء الشراء',
      name: 'purchaseCanceled',
      desc: '',
      args: [],
    );
  }

  /// `موافق`
  String get ok {
    return Intl.message(
      'موافق',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get cancel {
    return Intl.message(
      'إلغاء',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد`
  String get confirm {
    return Intl.message(
      'تأكيد',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `مفعل`
  String get activated {
    return Intl.message(
      'مفعل',
      name: 'activated',
      desc: '',
      args: [],
    );
  }

  /// `معلومات التطبيق`
  String get appInfo {
    return Intl.message(
      'معلومات التطبيق',
      name: 'appInfo',
      desc: '',
      args: [],
    );
  }

  /// `الدعم`
  String get support {
    return Intl.message(
      'الدعم',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `تواصل معنا`
  String get contact {
    return Intl.message(
      'تواصل معنا',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `قيّم التطبيق`
  String get rateApp {
    return Intl.message(
      'قيّم التطبيق',
      name: 'rateApp',
      desc: '',
      args: [],
    );
  }

  /// `شارك التطبيق`
  String get shareApp {
    return Intl.message(
      'شارك التطبيق',
      name: 'shareApp',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني`
  String get email {
    return Intl.message(
      'البريد الإلكتروني',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `الموقع`
  String get website {
    return Intl.message(
      'الموقع',
      name: 'website',
      desc: '',
      args: [],
    );
  }

  /// `جاري الاستعادة...`
  String get restoring {
    return Intl.message(
      'جاري الاستعادة...',
      name: 'restoring',
      desc: '',
      args: [],
    );
  }

  /// `تمت الاستعادة بنجاح`
  String get restoreSuccess {
    return Intl.message(
      'تمت الاستعادة بنجاح',
      name: 'restoreSuccess',
      desc: '',
      args: [],
    );
  }

  /// `فشلت الاستعادة`
  String get restoreFailed {
    return Intl.message(
      'فشلت الاستعادة',
      name: 'restoreFailed',
      desc: '',
      args: [],
    );
  }

  /// `المتجر غير متوفر`
  String get storeNotAvailable {
    return Intl.message(
      'المتجر غير متوفر',
      name: 'storeNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `المنتج غير موجود`
  String get productNotFound {
    return Intl.message(
      'المنتج غير موجود',
      name: 'productNotFound',
      desc: '',
      args: [],
    );
  }

  /// `دعم بسيط`
  String get donationSmall {
    return Intl.message(
      'دعم بسيط',
      name: 'donationSmall',
      desc: '',
      args: [],
    );
  }

  /// `دعم متوسط`
  String get donationMedium {
    return Intl.message(
      'دعم متوسط',
      name: 'donationMedium',
      desc: '',
      args: [],
    );
  }

  /// `دعم كبير`
  String get donationLarge {
    return Intl.message(
      'دعم كبير',
      name: 'donationLarge',
      desc: '',
      args: [],
    );
  }

  /// `إجمالي الدعم`
  String get totalDonations {
    return Intl.message(
      'إجمالي الدعم',
      name: 'totalDonations',
      desc: '',
      args: [],
    );
  }

  /// `اللغة`
  String get language {
    return Intl.message(
      'اللغة',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `اختر لغة التطبيق`
  String get languageDescription {
    return Intl.message(
      'اختر لغة التطبيق',
      name: 'languageDescription',
      desc: '',
      args: [],
    );
  }

  /// `العربية`
  String get arabic {
    return Intl.message(
      'العربية',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `عام`
  String get general {
    return Intl.message(
      'عام',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `بريميوم`
  String get premium {
    return Intl.message(
      'بريميوم',
      name: 'premium',
      desc: '',
      args: [],
    );
  }

  /// `اضغط للقراءة`
  String get tapToRead {
    return Intl.message(
      'اضغط للقراءة',
      name: 'tapToRead',
      desc: '',
      args: [],
    );
  }

  /// `اضغط التالي حتى تعرف هل أنت الجاسوس أو لا، ولا تخلي أحد يشوف شاشتك!`
  String get tabNextToKnow {
    return Intl.message(
      'اضغط التالي حتى تعرف هل أنت الجاسوس أو لا، ولا تخلي أحد يشوف شاشتك!',
      name: 'tabNextToKnow',
      desc: '',
      args: [],
    );
  }

  /// `تقدر تضيف لاعبين زيادة أو تبدأ اللعب`
  String get youCanAddMorePlayers {
    return Intl.message(
      'تقدر تضيف لاعبين زيادة أو تبدأ اللعب',
      name: 'youCanAddMorePlayers',
      desc: '',
      args: [],
    );
  }

  /// `تلميح: الكلمة من تصنيف`
  String get hintTheSaidAbout {
    return Intl.message(
      'تلميح: الكلمة من تصنيف',
      name: 'hintTheSaidAbout',
      desc: '',
      args: [],
    );
  }

  /// `هدفك في اللعبة معرفة مين الجاسوس. اضغط التالي!`
  String get yourGoal {
    return Intl.message(
      'هدفك في اللعبة معرفة مين الجاسوس. اضغط التالي!',
      name: 'yourGoal',
      desc: '',
      args: [],
    );
  }

  /// `اختار الشخص اللي تظن انه الجاسوس`
  String get selectPersonWhoIsOut {
    return Intl.message(
      'اختار الشخص اللي تظن انه الجاسوس',
      name: 'selectPersonWhoIsOut',
      desc: '',
      args: [],
    );
  }

  /// `نهاية الجولة!`
  String get endOfRoundTitle {
    return Intl.message(
      'نهاية الجولة!',
      name: 'endOfRoundTitle',
      desc: '',
      args: [],
    );
  }

  /// `تقدرون تكملون لعب أو تغيرون لاعب أو ترجعون لشاشة اختيار اللأسئلة`
  String get endOfRoundDescription {
    return Intl.message(
      'تقدرون تكملون لعب أو تغيرون لاعب أو ترجعون لشاشة اختيار اللأسئلة',
      name: 'endOfRoundDescription',
      desc: '',
      args: [],
    );
  }

  /// `كمل لعب`
  String get endOfRoundContinuePlaying {
    return Intl.message(
      'كمل لعب',
      name: 'endOfRoundContinuePlaying',
      desc: '',
      args: [],
    );
  }

  /// `تغيير اللاعبين`
  String get changePlayers {
    return Intl.message(
      'تغيير اللاعبين',
      name: 'changePlayers',
      desc: '',
      args: [],
    );
  }

  /// `الصفحة الرئيسية`
  String get endOfRoundHomePage {
    return Intl.message(
      'الصفحة الرئيسية',
      name: 'endOfRoundHomePage',
      desc: '',
      args: [],
    );
  }

  /// `تصنيفات أكثر`
  String get moreCategories {
    return Intl.message(
      'تصنيفات أكثر',
      name: 'moreCategories',
      desc: '',
      args: [],
    );
  }

  /// `مستانس من اللعبة؟`
  String get enjoyingGamePrompt {
    return Intl.message(
      'مستانس من اللعبة؟',
      name: 'enjoyingGamePrompt',
      desc: '',
      args: [],
    );
  }

  /// `أيوة، بحب اللعبة!`
  String get yesLoveIt {
    return Intl.message(
      'أيوة، بحب اللعبة!',
      name: 'yesLoveIt',
      desc: '',
      args: [],
    );
  }

  /// `مو كثير`
  String get notReallyEnjoying {
    return Intl.message(
      'مو كثير',
      name: 'notReallyEnjoying',
      desc: '',
      args: [],
    );
  }

  /// `تعزيزات الجولة`
  String get monetizationRoundBoostsTitle {
    return Intl.message(
      'تعزيزات الجولة',
      name: 'monetizationRoundBoostsTitle',
      desc: '',
      args: [],
    );
  }

  /// `كشف موضوع التصنيف`
  String get monetizationRevealCategoryHintTitle {
    return Intl.message(
      'كشف موضوع التصنيف',
      name: 'monetizationRevealCategoryHintTitle',
      desc: '',
      args: [],
    );
  }

  /// `{coins} عملة`
  String monetizationCoinAmountCoins(Object coins) {
    return Intl.message(
      '$coins عملة',
      name: 'monetizationCoinAmountCoins',
      desc: '',
      args: [coins],
    );
  }

  /// `تم تفعيل تلميح التصنيف: {category}`
  String monetizationCategoryHintUnlockedWithCategory(Object category) {
    return Intl.message(
      'تم تفعيل تلميح التصنيف: $category',
      name: 'monetizationCategoryHintUnlockedWithCategory',
      desc: '',
      args: [category],
    );
  }

  /// `غير متاح أو الرصيد غير كافٍ.`
  String get monetizationUnavailableOrInsufficientCoins {
    return Intl.message(
      'غير متاح أو الرصيد غير كافٍ.',
      name: 'monetizationUnavailableOrInsufficientCoins',
      desc: '',
      args: [],
    );
  }

  /// `تلميح: استبعاد لاعب خاطئ`
  String get monetizationRemoveWrongPlayerHintTitle {
    return Intl.message(
      'تلميح: استبعاد لاعب خاطئ',
      name: 'monetizationRemoveWrongPlayerHintTitle',
      desc: '',
      args: [],
    );
  }

  /// `التلميح فعّال لهذه الجولة.`
  String get monetizationHintActiveThisRound {
    return Intl.message(
      'التلميح فعّال لهذه الجولة.',
      name: 'monetizationHintActiveThisRound',
      desc: '',
      args: [],
    );
  }

  /// `ركّز أقل على {playerName}.`
  String monetizationFocusLessOnPlayer(Object playerName) {
    return Intl.message(
      'ركّز أقل على $playerName.',
      name: 'monetizationFocusLessOnPlayer',
      desc: '',
      args: [playerName],
    );
  }

  /// `تسليط الضوء على لاعب مشبوه`
  String get monetizationHighlightSuspiciousTitle {
    return Intl.message(
      'تسليط الضوء على لاعب مشبوه',
      name: 'monetizationHighlightSuspiciousTitle',
      desc: '',
      args: [],
    );
  }

  /// `إشارة: انتبه لـ {playerName}.`
  String monetizationSuspiciousPayAttention(Object playerName) {
    return Intl.message(
      'إشارة: انتبه لـ $playerName.',
      name: 'monetizationSuspiciousPayAttention',
      desc: '',
      args: [playerName],
    );
  }

  /// `ضعف العملات في الجولة القادمة`
  String get monetizationDoubleCoinsNextRoundTitle {
    return Intl.message(
      'ضعف العملات في الجولة القادمة',
      name: 'monetizationDoubleCoinsNextRoundTitle',
      desc: '',
      args: [],
    );
  }

  /// `{coins} عملة أو شاهد إعلاناً`
  String monetizationDoubleCoinsSubtitleCoinsOrAd(Object coins) {
    return Intl.message(
      '$coins عملة أو شاهد إعلاناً',
      name: 'monetizationDoubleCoinsSubtitleCoinsOrAd',
      desc: '',
      args: [coins],
    );
  }

  /// `{coins} عملة`
  String monetizationDoubleCoinsSubtitleCoinsOnly(Object coins) {
    return Intl.message(
      '$coins عملة',
      name: 'monetizationDoubleCoinsSubtitleCoinsOnly',
      desc: '',
      args: [coins],
    );
  }

  /// `ضعف عملات الجولة القادمة`
  String get monetizationDoubleNextRoundDialogTitle {
    return Intl.message(
      'ضعف عملات الجولة القادمة',
      name: 'monetizationDoubleNextRoundDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `ادفع بالعملات أو شاهد فيديو قصيراً.`
  String get monetizationDoubleNextRoundDialogBody {
    return Intl.message(
      'ادفع بالعملات أو شاهد فيديو قصيراً.',
      name: 'monetizationDoubleNextRoundDialogBody',
      desc: '',
      args: [],
    );
  }

  /// `إعلان بمكافأة`
  String get monetizationRewardedAdButton {
    return Intl.message(
      'إعلان بمكافأة',
      name: 'monetizationRewardedAdButton',
      desc: '',
      args: [],
    );
  }

  /// `ستُضاعف عملات الجولة القادمة مرة واحدة.`
  String get monetizationNextPayoutDoubledOnce {
    return Intl.message(
      'ستُضاعف عملات الجولة القادمة مرة واحدة.',
      name: 'monetizationNextPayoutDoubledOnce',
      desc: '',
      args: [],
    );
  }

  /// `لم يكتمل الإعلان.`
  String get monetizationAdNotCompleted {
    return Intl.message(
      'لم يكتمل الإعلان.',
      name: 'monetizationAdNotCompleted',
      desc: '',
      args: [],
    );
  }

  /// `تنبيه`
  String get monetizationNoticeTitle {
    return Intl.message(
      'تنبيه',
      name: 'monetizationNoticeTitle',
      desc: '',
      args: [],
    );
  }

  /// `مكافأة يومية`
  String get monetizationDailyRewardTitle {
    return Intl.message(
      'مكافأة يومية',
      name: 'monetizationDailyRewardTitle',
      desc: '',
      args: [],
    );
  }

  /// `تم المطالبة اليوم.`
  String get monetizationDailyRewardAlreadyClaimed {
    return Intl.message(
      'تم المطالبة اليوم.',
      name: 'monetizationDailyRewardAlreadyClaimed',
      desc: '',
      args: [],
    );
  }

  /// `تمت استعادة السلسلة. المطالبة بمكافأة اليوم.`
  String get monetizationDailyRewardStreakRestoredBody {
    return Intl.message(
      'تمت استعادة السلسلة. المطالبة بمكافأة اليوم.',
      name: 'monetizationDailyRewardStreakRestoredBody',
      desc: '',
      args: [],
    );
  }

  /// `الاستعادة غير متاحة.`
  String get monetizationDailyRewardRestoreUnavailable {
    return Intl.message(
      'الاستعادة غير متاحة.',
      name: 'monetizationDailyRewardRestoreUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `يوم السلسلة التالي: {day}\nالمكافأة: {coins} عملة`
  String monetizationDailyRewardPreview(Object day, Object coins) {
    return Intl.message(
      'يوم السلسلة التالي: $day\nالمكافأة: $coins عملة',
      name: 'monetizationDailyRewardPreview',
      desc: '',
      args: [day, coins],
    );
  }

  /// `استعادة السلسلة (إعلان)`
  String get monetizationRestoreStreakWithAd {
    return Intl.message(
      'استعادة السلسلة (إعلان)',
      name: 'monetizationRestoreStreakWithAd',
      desc: '',
      args: [],
    );
  }

  /// `استعادة السلسلة`
  String get monetizationRestoreStreak {
    return Intl.message(
      'استعادة السلسلة',
      name: 'monetizationRestoreStreak',
      desc: '',
      args: [],
    );
  }

  /// `المطالبة`
  String get monetizationClaimReward {
    return Intl.message(
      'المطالبة',
      name: 'monetizationClaimReward',
      desc: '',
      args: [],
    );
  }

  /// `أهلاً بك!`
  String get monetizationWelcomeTitle {
    return Intl.message(
      'أهلاً بك!',
      name: 'monetizationWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `احصل على {coins} عملة مجاناً — شاهد فيديو قصيراً.`
  String monetizationFirstLaunchFreeCoinsBody(Object coins) {
    return Intl.message(
      'احصل على $coins عملة مجاناً — شاهد فيديو قصيراً.',
      name: 'monetizationFirstLaunchFreeCoinsBody',
      desc: '',
      args: [coins],
    );
  }

  /// `ليس الآن`
  String get monetizationNotNow {
    return Intl.message(
      'ليس الآن',
      name: 'monetizationNotNow',
      desc: '',
      args: [],
    );
  }

  /// `حزمة البداية`
  String get monetizationStarterPack {
    return Intl.message(
      'حزمة البداية',
      name: 'monetizationStarterPack',
      desc: '',
      args: [],
    );
  }

  /// `شاهد الإعلان`
  String get monetizationWatchAdShort {
    return Intl.message(
      'شاهد الإعلان',
      name: 'monetizationWatchAdShort',
      desc: '',
      args: [],
    );
  }

  /// `فتح سريع ({hours} س)`
  String monetizationQuickUnlockHours(Object hours) {
    return Intl.message(
      'فتح سريع ($hours س)',
      name: 'monetizationQuickUnlockHours',
      desc: '',
      args: [hours],
    );
  }

  /// `فتح بالإعلان`
  String get monetizationQuickUnlockWithAd {
    return Intl.message(
      'فتح بالإعلان',
      name: 'monetizationQuickUnlockWithAd',
      desc: '',
      args: [],
    );
  }

  /// `{hours} س`
  String monetizationDurationHoursShort(Object hours) {
    return Intl.message(
      '$hours س',
      name: 'monetizationDurationHoursShort',
      desc: '',
      args: [hours],
    );
  }

  /// `تعزيزات وتلميحات`
  String get monetizationGameRoundPerksTooltip {
    return Intl.message(
      'تعزيزات وتلميحات',
      name: 'monetizationGameRoundPerksTooltip',
      desc: '',
      args: [],
    );
  }

  /// ` • VIP`
  String get monetizationVipBadgeSuffix {
    return Intl.message(
      ' • VIP',
      name: 'monetizationVipBadgeSuffix',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalization> load(Locale locale) => AppLocalization.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
