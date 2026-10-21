// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ذكريات';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String featureComingSoon(String feature) {
    return '$feature · قريبًا';
  }

  @override
  String get loadError => 'حدث خطأ ما. اسحب للأسفل للمحاولة مرة أخرى.';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get done => 'تم';

  @override
  String get change => 'تغيير';

  @override
  String get optional => 'اختياري';

  @override
  String get saveFailed => 'تعذّر الحفظ. يرجى المحاولة مرة أخرى.';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get more => 'المزيد';

  @override
  String get share => 'مشاركة';

  @override
  String get save => 'حفظ';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'تم النسخ';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get onlyYou => 'أنت فقط';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navMemories => 'الذكريات';

  @override
  String get navAdd => 'إضافة';

  @override
  String get navChat => 'المحادثات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String greetingMorning(String name) {
    return 'صباح الخير، $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'طاب يومك، $name';
  }

  @override
  String greetingEvening(String name) {
    return 'مساء الخير، $name';
  }

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count دقيقة',
      few: 'منذ $count دقائق',
      two: 'منذ دقيقتين',
      one: 'منذ دقيقة',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count ساعة',
      few: 'منذ $count ساعات',
      two: 'منذ ساعتين',
      one: 'منذ ساعة',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count يومًا',
      few: 'منذ $count أيام',
      two: 'منذ يومين',
    );
    return '$_temp0';
  }

  @override
  String weeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count أسبوعًا',
      few: 'منذ $count أسابيع',
      two: 'منذ أسبوعين',
      one: 'منذ أسبوع',
    );
    return '$_temp0';
  }

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get tomorrow => 'غدًا';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بعد $count يومًا',
      few: 'بعد $count أيام',
      two: 'بعد يومين',
    );
    return '$_temp0';
  }

  @override
  String get moodAmazing => 'سعيد';

  @override
  String get moodGood => 'جيد';

  @override
  String get moodOkay => 'عادي';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodVeryBad => 'سيئ جدًا';

  @override
  String feelingMood(String mood) {
    return 'الحالة: $mood';
  }

  @override
  String get notYet => 'ليس بعد';

  @override
  String get moodPrompt => 'سيرى هذا أصدقاؤك المقرّبون فقط.';

  @override
  String moodSharedLine(String mood) {
    return 'حالتك اليوم: $mood · تمت مشاركتها مع أصدقائك';
  }

  @override
  String get yourStory => 'قصتك';

  @override
  String get friendsSectionTitle => 'أصدقاء اليوم';

  @override
  String friendsCheckedIn(int checked, int total) {
    return '$checked من $total سجّلوا حالتهم';
  }

  @override
  String get friendsEmptyTitle => 'لم تُضف أي أصدقاء بعد';

  @override
  String get friendsEmptyBody => 'أضف الأشخاص الذين تودّ مشاركة لحظاتك معهم.';

  @override
  String get addFriend => 'إضافة صديق';

  @override
  String get openWhenTitle => 'افتحها عندما';

  @override
  String get openWhenEmptyTitle => 'لا توجد رسائل مجدولة بعد';

  @override
  String get openWhenEmptyBody => 'اكتب شيئًا ليفتحه أحدهم في اللحظة المناسبة.';

  @override
  String get createOpenWhen => 'إنشاء رسالة';

  @override
  String scheduledMessages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count رسالة مجدولة',
      few: '$count رسائل مجدولة',
      two: 'رسالتان مجدولتان',
      one: 'رسالة مجدولة واحدة',
    );
    return '$_temp0';
  }

  @override
  String nextOpens(String date, String relative) {
    return 'تُفتح القادمة $date · $relative';
  }

  @override
  String fromName(String name) {
    return 'من $name';
  }

  @override
  String opensOn(String date) {
    return 'تُفتح $date';
  }

  @override
  String get ready => 'جاهزة';

  @override
  String get sealed => 'مختومة';

  @override
  String get openNow => 'افتحها الآن';

  @override
  String get momentsSectionTitle => 'لحظات مع أحبّتك';

  @override
  String get momentsEmptyTitle => 'لا توجد ذكريات بعد';

  @override
  String get momentsEmptyBody => 'ستظهر هنا الذكريات التي يشاركها أصدقاؤك معك.';

  @override
  String sharedMemoryWithYou(String name) {
    return 'شارك $name ذكرى معك';
  }

  @override
  String get addMemory => 'إضافة ذكرى';

  @override
  String memoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ذكرى',
      few: '$count ذكريات',
      two: 'ذكريان',
      one: 'ذكرى واحدة',
      zero: 'لا ذكريات',
    );
    return '$_temp0';
  }

  @override
  String get memoriesSubtitle => 'كل ما احتفظتم به، معًا.';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterFriends => 'الأصدقاء';

  @override
  String get filterShared => 'المشتركة';

  @override
  String get filterCapsules => 'رسائل في الانتظار';

  @override
  String thisMonth(String month) {
    return 'هذا الشهر · $month';
  }

  @override
  String statMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ذكرى',
      few: 'ذكريات',
      two: 'ذكريان',
      one: 'ذكرى',
    );
    return '$_temp0';
  }

  @override
  String statPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'شخص',
      few: 'أشخاص',
      two: 'شخصان',
      one: 'شخص',
    );
    return '$_temp0';
  }

  @override
  String get moodYearTitle => 'عامك بالمشاعر';

  @override
  String get moodYearSubtitle => 'تابع حالتك المزاجية شهرًا بشهر';

  @override
  String get recentMemories => 'الأحدث';

  @override
  String get memoriesEmptyTitle => 'لا توجد ذكريات بعد';

  @override
  String get memoriesEmptyBody =>
      'احفظ ذكراك الأولى: لحظة، ومن كانوا معك فيها.';

  @override
  String get filterEmpty => 'لا شيء هنا بعد.';

  @override
  String withPeople(String people) {
    return 'مع $people';
  }

  @override
  String peopleTwo(String first, String second) {
    return '$first و$second';
  }

  @override
  String peopleMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صديقًا',
      few: '$count أصدقاء',
    );
    return '$_temp0';
  }

  @override
  String get visibilityPrivate => 'خاص';

  @override
  String get visibilityFriends => 'الأصدقاء';

  @override
  String get visibilityShared => 'مشترك';

  @override
  String get visibilityCapsule => 'رسالة في الانتظار';

  @override
  String get withOverline => 'مع';

  @override
  String get commentsTitle => 'التعليقات';

  @override
  String get commentsPlaceholder => 'المحادثات قادمة قريبًا. ستظهر الردود هنا.';

  @override
  String get addCommentHint => 'أضف تعليقًا…';

  @override
  String get moreOptions => 'خيارات أخرى';

  @override
  String get createTitle => 'إنشاء';

  @override
  String get createSubtitle => 'ماذا تريد أن تحفظ أو تشارك؟';

  @override
  String get createFootnote => 'كل شيء يبقى خاصًا حتى تختار مشاركته.';

  @override
  String get addMemoryDescription => 'احفظ لحظة ومن كانوا فيها.';

  @override
  String get openWhenDescription => 'اكتب شيئًا ليُفتح لاحقًا.';

  @override
  String get moodCheckInTitle => 'تسجيل المزاج';

  @override
  String get moodCheckInDescription => 'سجّل شعورك اليوم في ثوانٍ.';

  @override
  String get memorySaved => 'تم حفظ الذكرى';

  @override
  String get letterScheduled => 'تمت جدولة الرسالة';

  @override
  String get checkInSaved => 'تم حفظ التسجيل';

  @override
  String get addMemorySubtitle => 'احتفظ باللحظة، وبمن شاركتها معهم.';

  @override
  String get addPhotos => 'إضافة صور';

  @override
  String get photoUploadSoon => 'اضغط لاختيار صورة من صورك';

  @override
  String get photoUpload => 'رفع الصور';

  @override
  String get fieldTitle => 'العنوان';

  @override
  String get titleHint => 'مثال: غروب على الشاطئ';

  @override
  String get titleRequired => 'أضف عنوانًا لهذه الذكرى.';

  @override
  String get fieldDate => 'التاريخ';

  @override
  String get fieldPeopleInvolved => 'الأشخاص المشاركون';

  @override
  String get addPeople => 'إضافة أشخاص';

  @override
  String removePerson(String name) {
    return 'إزالة $name';
  }

  @override
  String get noFriendsToPick => 'لم تُضف أي أصدقاء بعد.';

  @override
  String get fieldCaption => 'الوصف';

  @override
  String get captionHint => 'ما الذي تريد أن تتذكره عنها؟';

  @override
  String get fieldWhoCanSee => 'من يمكنه رؤيتها';

  @override
  String get privacyPrivate => 'خاص';

  @override
  String get privacyFriends => 'الأصدقاء';

  @override
  String get privacySelected => 'أشخاص محددون';

  @override
  String get privacyPrivateDesc => 'أنت فقط من يمكنه رؤيتها.';

  @override
  String get privacyFriendsDesc => 'يمكن لجميع أصدقائك رؤيتها.';

  @override
  String get privacySelectedDesc => 'يمكن للأشخاص المشاركين فقط رؤيتها.';

  @override
  String get choosePeopleError => 'اختر من تريد مشاركة هذه الذكرى معهم.';

  @override
  String get saveMemory => 'حفظ الذكرى';

  @override
  String get openWhenSubtitle => 'رسالة تنتظر اللحظة المناسبة.';

  @override
  String get fieldFor => 'إلى';

  @override
  String get chooseRecipient => 'اختر المستلم';

  @override
  String get recipientRequired => 'اختر لمن هذه الرسالة.';

  @override
  String get fieldOpenWhen => 'افتحها عندما…';

  @override
  String get openWhenHint => 'تحتاج إلى من يذكّرك بنفسك';

  @override
  String get openWhenRequired => 'أكمل عبارة «افتحها عندما…».';

  @override
  String get fieldMessage => 'الرسالة';

  @override
  String get messageBodyHint => 'اكتب ما تريد أن يقرأه.';

  @override
  String get messageRequired => 'اكتب رسالتك.';

  @override
  String get fieldOpenDate => 'يمكن فتحها في';

  @override
  String get fieldNoteToSelf => 'ملاحظة لنفسك';

  @override
  String get noteToSelfHint => 'لن يراها أحد غيرك.';

  @override
  String get schedule => 'جدولة';

  @override
  String get moodCheckInSubtitle => 'كيف حالك اليوم؟';

  @override
  String get moodNoteLabel => 'هل تودّ قول شيء عن يومك؟';

  @override
  String get moodNoteHint => 'بضع كلمات، لك وحدك.';

  @override
  String get saveCheckIn => 'حفظ التسجيل';

  @override
  String get chatTitle => 'المحادثات';

  @override
  String get chatSubtitle => 'ابقَ قريبًا من أحبّتك.';

  @override
  String get newMessage => 'رسالة جديدة';

  @override
  String get moodTodayTitle => 'مزاج اليوم';

  @override
  String get moodTodayEmpty => 'لم يسجّل أي صديق حالته بعد';

  @override
  String get messagesTitle => 'الرسائل';

  @override
  String unreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count رسالة غير مقروءة',
      few: '$count رسائل غير مقروءة',
      two: 'رسالتان غير مقروءتين',
      one: 'رسالة غير مقروءة',
    );
    return '$_temp0';
  }

  @override
  String get allCaughtUp => 'لا جديد';

  @override
  String get conversationsEmptyTitle => 'لا توجد محادثات بعد';

  @override
  String get conversationsEmptyBody => 'ابدأ محادثة مع أحد أصدقائك.';

  @override
  String get startChat => 'بدء محادثة';

  @override
  String get startChatTitle => 'ابدأ محادثة';

  @override
  String youPrefix(String text) {
    return 'أنت: $text';
  }

  @override
  String get sayHello => 'قل مرحبًا';

  @override
  String get online => 'متصل الآن';

  @override
  String get messageHint => 'رسالة';

  @override
  String get send => 'إرسال';

  @override
  String get sending => 'جارٍ الإرسال…';

  @override
  String get sent => 'أُرسلت';

  @override
  String get read => 'قُرئت';

  @override
  String get notSent => 'لم تُرسل';

  @override
  String get shareInChat => 'مشاركة في المحادثة';

  @override
  String get attachMemoryDesc => 'شارك ذكرى في هذه المحادثة';

  @override
  String get sendOpenWhen => 'إرسال رسالة «افتحها عندما»';

  @override
  String get sendOpenWhenDesc => 'رسالة يمكن فتحها لاحقًا';

  @override
  String get chatOptions => 'خيارات المحادثة';

  @override
  String get closeReactions => 'إغلاق التفاعلات';

  @override
  String get reactionLove => 'حب';

  @override
  String get reactionAgree => 'أوافق';

  @override
  String get reactionHaha => 'مضحك';

  @override
  String get reactionSad => 'حزين';

  @override
  String get friendsTitle => 'الأصدقاء';

  @override
  String get friendsSubtitle => 'الأشخاص الذين تشاركهم لحظاتك.';

  @override
  String friendsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صديقًا',
      few: '$count أصدقاء',
      two: 'صديقان',
      one: 'صديق واحد',
      zero: 'لا أصدقاء بعد',
    );
    return '$_temp0';
  }

  @override
  String get addFriendSubtitle => 'أضف شخصًا تودّ مشاركة لحظاتك معه.';

  @override
  String get fieldName => 'الاسم';

  @override
  String get nameHint => 'الاسم الكامل';

  @override
  String get nameRequired => 'أدخل اسمًا.';

  @override
  String get fieldContact => 'البريد الإلكتروني أو رقم الهاتف';

  @override
  String get contactHint => 'لتتمكّن من دعوته لاحقًا';

  @override
  String friendAdded(String name) {
    return 'تمت إضافة $name';
  }

  @override
  String get message => 'مراسلة';

  @override
  String get ourStory => 'قصتنا';

  @override
  String ourStorySubtitle(String name) {
    return 'كل ما شاركته مع $name.';
  }

  @override
  String get ourStoryEmptyTitle => 'لا توجد ذكريات مشتركة بعد';

  @override
  String ourStoryEmptyBody(String name) {
    return 'ستظهر هنا الذكريات التي تشاركها مع $name.';
  }

  @override
  String get noMoodToday => 'لم يسجّل حالته اليوم';

  @override
  String sharedMemoriesStat(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ذكرى مشتركة',
      few: 'ذكريات مشتركة',
      two: 'ذكريان مشتركتان',
      one: 'ذكرى مشتركة',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get settingsSubtitle => 'اللغة والتفضيلات';

  @override
  String get language => 'اللغة';

  @override
  String get languageHint => 'اختر لغة التطبيق.';

  @override
  String get readyToOpen => 'جاهزة للفتح';

  @override
  String get tapToOpen => 'اضغط للفتح';

  @override
  String openedOn(String date) {
    return 'تم فتحها $date';
  }

  @override
  String firstOpenedOn(String date) {
    return 'تم فتحها لأول مرة $date';
  }

  @override
  String writtenOn(String date) {
    return 'كُتبت $date';
  }

  @override
  String get fromYou => 'منك';

  @override
  String get futureYou => 'أنت في المستقبل';

  @override
  String letterLockedToast(String date) {
    return 'تُفتح هذه الرسالة $date';
  }

  @override
  String get voiceNote => 'ملاحظة صوتية';

  @override
  String get yourNote => 'ملاحظتك';

  @override
  String get letterForYou => 'لك';

  @override
  String get sealedMessage => 'رسالة مختومة';

  @override
  String openWhenPhrase(String phrase) {
    return 'افتحها عندما $phrase';
  }

  @override
  String get waitingMessagesTitle => 'رسائل في الانتظار';

  @override
  String get waitingMessagesSubtitle => 'رسائل تُفتح في اللحظة المناسبة.';

  @override
  String get waitingMessageOverline => 'رسالة في الانتظار';

  @override
  String get waitingEmptyTitle => 'لا توجد رسائل في الانتظار بعد';

  @override
  String get waitingEmptyBody =>
      'اكتب رسالة تُفتح في التاريخ والوقت اللذين تختارهما.';

  @override
  String get createMessage => 'إنشاء رسالة';

  @override
  String get createMessageSubtitle => 'اكتبها الآن، وستُفتح حين يحين وقتها.';

  @override
  String get waitingMessagesDescription => 'جدوِل رسالة لتُفتح لاحقًا.';

  @override
  String get fieldRecipient => 'إلى';

  @override
  String get fieldMessageTitle => 'عنوان الرسالة';

  @override
  String get messageTitleHint => 'مثال: في عيد ميلادك';

  @override
  String get messageTitleRequired => 'أضف عنوانًا للرسالة.';

  @override
  String get fieldImage => 'صورة';

  @override
  String get addImage => 'إضافة صورة';

  @override
  String get removeImage => 'إزالة الصورة';

  @override
  String get fieldOpenDay => 'تُفتح في';

  @override
  String get fieldOpenTime => 'في الساعة';

  @override
  String get openTimeInPast => 'اختر وقتًا في المستقبل.';

  @override
  String get scheduleMessage => 'جدولة الرسالة';

  @override
  String get messageScheduled => 'تمت جدولة الرسالة';

  @override
  String toName(String name) {
    return 'إلى $name';
  }

  @override
  String get toFutureYou => 'إلى نفسك في المستقبل';

  @override
  String get attachWaitingMessage => 'رسالة في الانتظار';

  @override
  String get attachWaitingMessageDesc => 'رسالة تُفتح لاحقًا';

  @override
  String get imagePickFailed => 'تعذّر فتح الصور.';

  @override
  String get statusWaiting => 'في الانتظار';

  @override
  String get statusOpened => 'تم فتحها';

  @override
  String get authSignInTitle => 'مرحبًا بعودتك';

  @override
  String get authSignUpTitle => 'أنشئ حسابك';

  @override
  String get authSubtitle => 'مساحة خاصة لك ولأحبّتك.';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get haveAccount => 'لديك حساب بالفعل؟';

  @override
  String get noAccount => 'جديد في ذكريات؟';

  @override
  String get fieldEmail => 'البريد الإلكتروني';

  @override
  String get fieldPassword => 'كلمة المرور';

  @override
  String get fieldYourName => 'اسمك';

  @override
  String get yourNameHint => 'كما سيراك أصدقاؤك';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا.';

  @override
  String get passwordTooShort => 'استخدم 6 أحرف على الأقل.';

  @override
  String get passwordRequired => 'أدخل كلمة المرور.';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get authErrorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get authErrorEmailNotConfirmed =>
      'يرجى تأكيد بريدك الإلكتروني أولًا، ثم تسجيل الدخول.';

  @override
  String get authErrorEmailInUse =>
      'يوجد حساب بهذا البريد الإلكتروني بالفعل. جرّب تسجيل الدخول.';

  @override
  String get authErrorWeakPassword => 'اختر كلمة مرور أقوى.';

  @override
  String get authErrorRateLimited =>
      'محاولات كثيرة. يرجى الانتظار قليلًا ثم المحاولة مرة أخرى.';

  @override
  String get authErrorNetwork => 'تعذّر الاتصال. تحقّق من اتصالك بالإنترنت.';

  @override
  String get authErrorUnknown => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get confirmEmailSent =>
      'تحقّق من بريدك الإلكتروني لتأكيد حسابك، ثم سجّل الدخول.';

  @override
  String get account => 'الحساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signOutConfirm => 'هل تريد تسجيل الخروج من ذكريات؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get photoUploadFailed => 'تعذّر رفع الصورة. يرجى المحاولة مرة أخرى.';
}
