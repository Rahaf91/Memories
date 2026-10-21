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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get appName;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} · Coming soon'**
  String featureComingSoon(String feature);

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Pull to try again.'**
  String get loadError;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get saveFailed;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @onlyYou.
  ///
  /// In en, this message translates to:
  /// **'Only you'**
  String get onlyYou;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMemories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get navMemories;

  /// No description provided for @navAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAdd;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String greetingMorning(String name);

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String greetingAfternoon(String name);

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String greetingEvening(String name);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}w ago'**
  String weeksAgo(int count);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get tomorrow;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'in {count} days'**
  String inDays(int count);

  /// No description provided for @moodAmazing.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodAmazing;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// No description provided for @moodOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get moodOkay;

  /// No description provided for @moodSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;

  /// No description provided for @moodVeryBad.
  ///
  /// In en, this message translates to:
  /// **'Very Bad'**
  String get moodVeryBad;

  /// No description provided for @feelingMood.
  ///
  /// In en, this message translates to:
  /// **'Feeling {mood}'**
  String feelingMood(String mood);

  /// No description provided for @notYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get notYet;

  /// No description provided for @moodPrompt.
  ///
  /// In en, this message translates to:
  /// **'Only your close friends will see this.'**
  String get moodPrompt;

  /// No description provided for @moodSharedLine.
  ///
  /// In en, this message translates to:
  /// **'Feeling {mood} today · shared with your friends'**
  String moodSharedLine(String mood);

  /// No description provided for @yourStory.
  ///
  /// In en, this message translates to:
  /// **'Your story'**
  String get yourStory;

  /// No description provided for @friendsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends Today'**
  String get friendsSectionTitle;

  /// No description provided for @friendsCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'{checked} of {total} checked in'**
  String friendsCheckedIn(int checked, int total);

  /// No description provided for @friendsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No friends added yet'**
  String get friendsEmptyTitle;

  /// No description provided for @friendsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add the people you want to share moments with.'**
  String get friendsEmptyBody;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @openWhenTitle.
  ///
  /// In en, this message translates to:
  /// **'Open When'**
  String get openWhenTitle;

  /// No description provided for @openWhenEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No scheduled messages yet'**
  String get openWhenEmptyTitle;

  /// No description provided for @openWhenEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Write something for someone to open at the right moment.'**
  String get openWhenEmptyBody;

  /// No description provided for @createOpenWhen.
  ///
  /// In en, this message translates to:
  /// **'Create Open When'**
  String get createOpenWhen;

  /// No description provided for @scheduledMessages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 scheduled message} other{{count} scheduled messages}}'**
  String scheduledMessages(int count);

  /// No description provided for @nextOpens.
  ///
  /// In en, this message translates to:
  /// **'Next one opens {date} · {relative}'**
  String nextOpens(String date, String relative);

  /// No description provided for @fromName.
  ///
  /// In en, this message translates to:
  /// **'From {name}'**
  String fromName(String name);

  /// No description provided for @opensOn.
  ///
  /// In en, this message translates to:
  /// **'Opens {date}'**
  String opensOn(String date);

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @sealed.
  ///
  /// In en, this message translates to:
  /// **'Sealed'**
  String get sealed;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get openNow;

  /// No description provided for @momentsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Moments with your people'**
  String get momentsSectionTitle;

  /// No description provided for @momentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No memories yet'**
  String get momentsEmptyTitle;

  /// No description provided for @momentsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Memories your friends share with you will appear here.'**
  String get momentsEmptyBody;

  /// No description provided for @sharedMemoryWithYou.
  ///
  /// In en, this message translates to:
  /// **'{name} shared a memory with you'**
  String sharedMemoryWithYou(String name);

  /// No description provided for @addMemory.
  ///
  /// In en, this message translates to:
  /// **'Add Memory'**
  String get addMemory;

  /// No description provided for @memoriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 memory} other{{count} memories}}'**
  String memoriesCount(int count);

  /// No description provided for @memoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you\'ve kept, together.'**
  String get memoriesSubtitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get filterFriends;

  /// No description provided for @filterShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get filterShared;

  /// No description provided for @filterCapsules.
  ///
  /// In en, this message translates to:
  /// **'Waiting Messages'**
  String get filterCapsules;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month · {month}'**
  String thisMonth(String month);

  /// No description provided for @statMemories.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{memory} other{memories}}'**
  String statMemories(int count);

  /// No description provided for @statPeople.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{person} other{people}}'**
  String statPeople(int count);

  /// No description provided for @moodYearTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Mood Year'**
  String get moodYearTitle;

  /// No description provided for @moodYearSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See your mood history month by month'**
  String get moodYearSubtitle;

  /// No description provided for @recentMemories.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentMemories;

  /// No description provided for @memoriesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No memories yet'**
  String get memoriesEmptyTitle;

  /// No description provided for @memoriesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Save your first memory: a moment, and the people in it.'**
  String get memoriesEmptyBody;

  /// No description provided for @filterEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get filterEmpty;

  /// No description provided for @withPeople.
  ///
  /// In en, this message translates to:
  /// **'with {people}'**
  String withPeople(String people);

  /// No description provided for @peopleTwo.
  ///
  /// In en, this message translates to:
  /// **'{first} & {second}'**
  String peopleTwo(String first, String second);

  /// No description provided for @peopleMany.
  ///
  /// In en, this message translates to:
  /// **'{count} friends'**
  String peopleMany(int count);

  /// No description provided for @visibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get visibilityPrivate;

  /// No description provided for @visibilityFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get visibilityFriends;

  /// No description provided for @visibilityShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get visibilityShared;

  /// No description provided for @visibilityCapsule.
  ///
  /// In en, this message translates to:
  /// **'Waiting message'**
  String get visibilityCapsule;

  /// No description provided for @withOverline.
  ///
  /// In en, this message translates to:
  /// **'With'**
  String get withOverline;

  /// No description provided for @commentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// No description provided for @commentsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Conversations are coming soon. Replies will appear here.'**
  String get commentsPlaceholder;

  /// No description provided for @addCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Add a comment…'**
  String get addCommentHint;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @createTitle.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createTitle;

  /// No description provided for @createSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to save or share?'**
  String get createSubtitle;

  /// No description provided for @createFootnote.
  ///
  /// In en, this message translates to:
  /// **'Everything stays private until you choose to share it.'**
  String get createFootnote;

  /// No description provided for @addMemoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Save a moment and the people in it.'**
  String get addMemoryDescription;

  /// No description provided for @openWhenDescription.
  ///
  /// In en, this message translates to:
  /// **'Write something to be opened later.'**
  String get openWhenDescription;

  /// No description provided for @moodCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood Check-in'**
  String get moodCheckInTitle;

  /// No description provided for @moodCheckInDescription.
  ///
  /// In en, this message translates to:
  /// **'Note how today feels, in a few seconds.'**
  String get moodCheckInDescription;

  /// No description provided for @memorySaved.
  ///
  /// In en, this message translates to:
  /// **'Memory saved'**
  String get memorySaved;

  /// No description provided for @letterScheduled.
  ///
  /// In en, this message translates to:
  /// **'Open When scheduled'**
  String get letterScheduled;

  /// No description provided for @checkInSaved.
  ///
  /// In en, this message translates to:
  /// **'Check-in saved'**
  String get checkInSaved;

  /// No description provided for @addMemorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the moment, and who you shared it with.'**
  String get addMemorySubtitle;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPhotos;

  /// No description provided for @photoUploadSoon.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose from your photos'**
  String get photoUploadSoon;

  /// No description provided for @photoUpload.
  ///
  /// In en, this message translates to:
  /// **'Photo upload'**
  String get photoUpload;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Beach sunset'**
  String get titleHint;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Give this memory a title.'**
  String get titleRequired;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @fieldPeopleInvolved.
  ///
  /// In en, this message translates to:
  /// **'People involved'**
  String get fieldPeopleInvolved;

  /// No description provided for @addPeople.
  ///
  /// In en, this message translates to:
  /// **'Add people'**
  String get addPeople;

  /// No description provided for @removePerson.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String removePerson(String name);

  /// No description provided for @noFriendsToPick.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any friends yet.'**
  String get noFriendsToPick;

  /// No description provided for @fieldCaption.
  ///
  /// In en, this message translates to:
  /// **'Caption'**
  String get fieldCaption;

  /// No description provided for @captionHint.
  ///
  /// In en, this message translates to:
  /// **'What do you want to remember about it?'**
  String get captionHint;

  /// No description provided for @fieldWhoCanSee.
  ///
  /// In en, this message translates to:
  /// **'Who can see it'**
  String get fieldWhoCanSee;

  /// No description provided for @privacyPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privacyPrivate;

  /// No description provided for @privacyFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get privacyFriends;

  /// No description provided for @privacySelected.
  ///
  /// In en, this message translates to:
  /// **'Selected people'**
  String get privacySelected;

  /// No description provided for @privacyPrivateDesc.
  ///
  /// In en, this message translates to:
  /// **'Only you can see it.'**
  String get privacyPrivateDesc;

  /// No description provided for @privacyFriendsDesc.
  ///
  /// In en, this message translates to:
  /// **'All your friends can see it.'**
  String get privacyFriendsDesc;

  /// No description provided for @privacySelectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Only the people involved can see it.'**
  String get privacySelectedDesc;

  /// No description provided for @choosePeopleError.
  ///
  /// In en, this message translates to:
  /// **'Choose who to share this memory with.'**
  String get choosePeopleError;

  /// No description provided for @saveMemory.
  ///
  /// In en, this message translates to:
  /// **'Save memory'**
  String get saveMemory;

  /// No description provided for @openWhenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A message that waits for the right moment.'**
  String get openWhenSubtitle;

  /// No description provided for @fieldFor.
  ///
  /// In en, this message translates to:
  /// **'For'**
  String get fieldFor;

  /// No description provided for @chooseRecipient.
  ///
  /// In en, this message translates to:
  /// **'Choose recipient'**
  String get chooseRecipient;

  /// No description provided for @recipientRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose who this is for.'**
  String get recipientRequired;

  /// No description provided for @fieldOpenWhen.
  ///
  /// In en, this message translates to:
  /// **'Open when…'**
  String get fieldOpenWhen;

  /// No description provided for @openWhenHint.
  ///
  /// In en, this message translates to:
  /// **'you need a reminder of who you are'**
  String get openWhenHint;

  /// No description provided for @openWhenRequired.
  ///
  /// In en, this message translates to:
  /// **'Finish the \"Open when…\" line.'**
  String get openWhenRequired;

  /// No description provided for @fieldMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get fieldMessage;

  /// No description provided for @messageBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Write what you want them to read.'**
  String get messageBodyHint;

  /// No description provided for @messageRequired.
  ///
  /// In en, this message translates to:
  /// **'Write your message.'**
  String get messageRequired;

  /// No description provided for @fieldOpenDate.
  ///
  /// In en, this message translates to:
  /// **'Can be opened on'**
  String get fieldOpenDate;

  /// No description provided for @fieldNoteToSelf.
  ///
  /// In en, this message translates to:
  /// **'Note to yourself'**
  String get fieldNoteToSelf;

  /// No description provided for @noteToSelfHint.
  ///
  /// In en, this message translates to:
  /// **'Only you will see this.'**
  String get noteToSelfHint;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @moodCheckInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How are you today?'**
  String get moodCheckInSubtitle;

  /// No description provided for @moodNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Want to say something about today?'**
  String get moodNoteLabel;

  /// No description provided for @moodNoteHint.
  ///
  /// In en, this message translates to:
  /// **'A few words, just for you.'**
  String get moodNoteHint;

  /// No description provided for @saveCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Save check-in'**
  String get saveCheckIn;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @chatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay close to your people.'**
  String get chatSubtitle;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get newMessage;

  /// No description provided for @moodTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood Today'**
  String get moodTodayTitle;

  /// No description provided for @moodTodayEmpty.
  ///
  /// In en, this message translates to:
  /// **'No friends have checked in yet'**
  String get moodTodayEmpty;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @unreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String unreadCount(int count);

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get allCaughtUp;

  /// No description provided for @conversationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get conversationsEmptyTitle;

  /// No description provided for @conversationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with one of your friends.'**
  String get conversationsEmptyBody;

  /// No description provided for @startChat.
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get startChat;

  /// No description provided for @startChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a chat'**
  String get startChatTitle;

  /// No description provided for @youPrefix.
  ///
  /// In en, this message translates to:
  /// **'You: {text}'**
  String youPrefix(String text);

  /// No description provided for @sayHello.
  ///
  /// In en, this message translates to:
  /// **'Say hello'**
  String get sayHello;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageHint;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get sending;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @notSent.
  ///
  /// In en, this message translates to:
  /// **'Not sent'**
  String get notSent;

  /// No description provided for @shareInChat.
  ///
  /// In en, this message translates to:
  /// **'Share in chat'**
  String get shareInChat;

  /// No description provided for @attachMemoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Share a memory in this chat'**
  String get attachMemoryDesc;

  /// No description provided for @sendOpenWhen.
  ///
  /// In en, this message translates to:
  /// **'Send Open When'**
  String get sendOpenWhen;

  /// No description provided for @sendOpenWhenDesc.
  ///
  /// In en, this message translates to:
  /// **'A message they can open later'**
  String get sendOpenWhenDesc;

  /// No description provided for @chatOptions.
  ///
  /// In en, this message translates to:
  /// **'Chat options'**
  String get chatOptions;

  /// No description provided for @closeReactions.
  ///
  /// In en, this message translates to:
  /// **'Close reactions'**
  String get closeReactions;

  /// No description provided for @reactionLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get reactionLove;

  /// No description provided for @reactionAgree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get reactionAgree;

  /// No description provided for @reactionHaha.
  ///
  /// In en, this message translates to:
  /// **'Haha'**
  String get reactionHaha;

  /// No description provided for @reactionSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get reactionSad;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @friendsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The people you share your moments with.'**
  String get friendsSubtitle;

  /// No description provided for @friendsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No friends yet} =1{1 friend} other{{count} friends}}'**
  String friendsCount(int count);

  /// No description provided for @addFriendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add someone you want to share moments with.'**
  String get addFriendSubtitle;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Their full name'**
  String get nameHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name.'**
  String get nameRequired;

  /// No description provided for @fieldContact.
  ///
  /// In en, this message translates to:
  /// **'Email or phone'**
  String get fieldContact;

  /// No description provided for @contactHint.
  ///
  /// In en, this message translates to:
  /// **'So you can invite them later'**
  String get contactHint;

  /// No description provided for @friendAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String friendAdded(String name);

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @ourStory.
  ///
  /// In en, this message translates to:
  /// **'Our Story'**
  String get ourStory;

  /// No description provided for @ourStorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you\'ve shared with {name}.'**
  String ourStorySubtitle(String name);

  /// No description provided for @ourStoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No shared memories yet'**
  String get ourStoryEmptyTitle;

  /// No description provided for @ourStoryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Memories you share with {name} will appear here.'**
  String ourStoryEmptyBody(String name);

  /// No description provided for @noMoodToday.
  ///
  /// In en, this message translates to:
  /// **'Hasn\'t checked in today'**
  String get noMoodToday;

  /// No description provided for @sharedMemoriesStat.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{shared memory} other{shared memories}}'**
  String sharedMemoriesStat(int count);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Language and preferences'**
  String get settingsSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the language of the app.'**
  String get languageHint;

  /// No description provided for @readyToOpen.
  ///
  /// In en, this message translates to:
  /// **'Ready to open'**
  String get readyToOpen;

  /// No description provided for @tapToOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap to open'**
  String get tapToOpen;

  /// No description provided for @openedOn.
  ///
  /// In en, this message translates to:
  /// **'Opened {date}'**
  String openedOn(String date);

  /// No description provided for @firstOpenedOn.
  ///
  /// In en, this message translates to:
  /// **'First opened {date}'**
  String firstOpenedOn(String date);

  /// No description provided for @writtenOn.
  ///
  /// In en, this message translates to:
  /// **'Written {date}'**
  String writtenOn(String date);

  /// No description provided for @fromYou.
  ///
  /// In en, this message translates to:
  /// **'From you'**
  String get fromYou;

  /// No description provided for @futureYou.
  ///
  /// In en, this message translates to:
  /// **'Future you'**
  String get futureYou;

  /// No description provided for @letterLockedToast.
  ///
  /// In en, this message translates to:
  /// **'This message opens {date}'**
  String letterLockedToast(String date);

  /// No description provided for @voiceNote.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get voiceNote;

  /// No description provided for @yourNote.
  ///
  /// In en, this message translates to:
  /// **'Your note'**
  String get yourNote;

  /// No description provided for @letterForYou.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get letterForYou;

  /// No description provided for @sealedMessage.
  ///
  /// In en, this message translates to:
  /// **'Sealed message'**
  String get sealedMessage;

  /// No description provided for @openWhenPhrase.
  ///
  /// In en, this message translates to:
  /// **'Open when {phrase}'**
  String openWhenPhrase(String phrase);

  /// No description provided for @waitingMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting Messages'**
  String get waitingMessagesTitle;

  /// No description provided for @waitingMessagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Messages that open at the right moment.'**
  String get waitingMessagesSubtitle;

  /// No description provided for @waitingMessageOverline.
  ///
  /// In en, this message translates to:
  /// **'Waiting message'**
  String get waitingMessageOverline;

  /// No description provided for @waitingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No waiting messages yet'**
  String get waitingEmptyTitle;

  /// No description provided for @waitingEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Write a message that opens on the date and time you choose.'**
  String get waitingEmptyBody;

  /// No description provided for @createMessage.
  ///
  /// In en, this message translates to:
  /// **'Create Message'**
  String get createMessage;

  /// No description provided for @createMessageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write it now. It opens when the time comes.'**
  String get createMessageSubtitle;

  /// No description provided for @waitingMessagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Schedule a message to open later.'**
  String get waitingMessagesDescription;

  /// No description provided for @fieldRecipient.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get fieldRecipient;

  /// No description provided for @fieldMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Message title'**
  String get fieldMessageTitle;

  /// No description provided for @messageTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. For your birthday'**
  String get messageTitleHint;

  /// No description provided for @messageTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Give the message a title.'**
  String get messageTitleRequired;

  /// No description provided for @fieldImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get fieldImage;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add an image'**
  String get addImage;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get removeImage;

  /// No description provided for @fieldOpenDay.
  ///
  /// In en, this message translates to:
  /// **'Opens on'**
  String get fieldOpenDay;

  /// No description provided for @fieldOpenTime.
  ///
  /// In en, this message translates to:
  /// **'At'**
  String get fieldOpenTime;

  /// No description provided for @openTimeInPast.
  ///
  /// In en, this message translates to:
  /// **'Choose a time in the future.'**
  String get openTimeInPast;

  /// No description provided for @scheduleMessage.
  ///
  /// In en, this message translates to:
  /// **'Schedule message'**
  String get scheduleMessage;

  /// No description provided for @messageScheduled.
  ///
  /// In en, this message translates to:
  /// **'Message scheduled'**
  String get messageScheduled;

  /// No description provided for @toName.
  ///
  /// In en, this message translates to:
  /// **'To {name}'**
  String toName(String name);

  /// No description provided for @toFutureYou.
  ///
  /// In en, this message translates to:
  /// **'To future you'**
  String get toFutureYou;

  /// No description provided for @attachWaitingMessage.
  ///
  /// In en, this message translates to:
  /// **'Waiting message'**
  String get attachWaitingMessage;

  /// No description provided for @attachWaitingMessageDesc.
  ///
  /// In en, this message translates to:
  /// **'A message that opens later'**
  String get attachWaitingMessageDesc;

  /// No description provided for @imagePickFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open your photos.'**
  String get imagePickFailed;

  /// No description provided for @statusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusWaiting;

  /// No description provided for @statusOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get statusOpened;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authSignInTitle;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authSignUpTitle;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A private space for you and your people.'**
  String get authSubtitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUp;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'New to Memories?'**
  String get noAccount;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @fieldYourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get fieldYourName;

  /// No description provided for @yourNameHint.
  ///
  /// In en, this message translates to:
  /// **'How friends will see you'**
  String get yourNameHint;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get passwordRequired;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email first, then sign in.'**
  String get authErrorEmailNotConfirmed;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists. Try signing in.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a stronger password.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get authErrorRateLimited;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect. Check your internet connection.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authErrorUnknown;

  /// No description provided for @confirmEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Check your email to confirm your account, then sign in.'**
  String get confirmEmailSent;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out of Memories?'**
  String get signOutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @photoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload the photo. Please try again.'**
  String get photoUploadFailed;
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
    'that was used.',
  );
}
