// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Memories';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String featureComingSoon(String feature) {
    return '$feature · Coming soon';
  }

  @override
  String get loadError => 'Something went wrong. Pull to try again.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get seeAll => 'See all';

  @override
  String get done => 'Done';

  @override
  String get change => 'Change';

  @override
  String get optional => 'Optional';

  @override
  String get saveFailed => 'Couldn\'t save. Please try again.';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get more => 'More';

  @override
  String get share => 'Share';

  @override
  String get save => 'Save';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get notifications => 'Notifications';

  @override
  String get onlyYou => 'Only you';

  @override
  String get navHome => 'Home';

  @override
  String get navMemories => 'Memories';

  @override
  String get navAdd => 'Add';

  @override
  String get navChat => 'Chat';

  @override
  String get navProfile => 'Profile';

  @override
  String greetingMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String weeksAgo(int count) {
    return '${count}w ago';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'tomorrow';

  @override
  String inDays(int count) {
    return 'in $count days';
  }

  @override
  String get moodAmazing => 'Happy';

  @override
  String get moodGood => 'Good';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodVeryBad => 'Very Bad';

  @override
  String feelingMood(String mood) {
    return 'Feeling $mood';
  }

  @override
  String get notYet => 'Not yet';

  @override
  String get moodPrompt => 'Only your close friends will see this.';

  @override
  String moodSharedLine(String mood) {
    return 'Feeling $mood today · shared with your friends';
  }

  @override
  String get yourStory => 'Your story';

  @override
  String get friendsSectionTitle => 'Friends Today';

  @override
  String friendsCheckedIn(int checked, int total) {
    return '$checked of $total checked in';
  }

  @override
  String get friendsEmptyTitle => 'No friends added yet';

  @override
  String get friendsEmptyBody =>
      'Add the people you want to share moments with.';

  @override
  String get addFriend => 'Add Friend';

  @override
  String get openWhenTitle => 'Open When';

  @override
  String get openWhenEmptyTitle => 'No scheduled messages yet';

  @override
  String get openWhenEmptyBody =>
      'Write something for someone to open at the right moment.';

  @override
  String get createOpenWhen => 'Create Open When';

  @override
  String scheduledMessages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scheduled messages',
      one: '1 scheduled message',
    );
    return '$_temp0';
  }

  @override
  String nextOpens(String date, String relative) {
    return 'Next one opens $date · $relative';
  }

  @override
  String fromName(String name) {
    return 'From $name';
  }

  @override
  String opensOn(String date) {
    return 'Opens $date';
  }

  @override
  String get ready => 'Ready';

  @override
  String get sealed => 'Sealed';

  @override
  String get openNow => 'Open now';

  @override
  String get momentsSectionTitle => 'Moments with your people';

  @override
  String get momentsEmptyTitle => 'No memories yet';

  @override
  String get momentsEmptyBody =>
      'Memories your friends share with you will appear here.';

  @override
  String sharedMemoryWithYou(String name) {
    return '$name shared a memory with you';
  }

  @override
  String get addMemory => 'Add Memory';

  @override
  String memoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories',
      one: '1 memory',
    );
    return '$_temp0';
  }

  @override
  String get memoriesSubtitle => 'Everything you\'ve kept, together.';

  @override
  String get filterAll => 'All';

  @override
  String get filterFriends => 'Friends';

  @override
  String get filterShared => 'Shared';

  @override
  String get filterCapsules => 'Waiting Messages';

  @override
  String thisMonth(String month) {
    return 'This month · $month';
  }

  @override
  String statMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'memories',
      one: 'memory',
    );
    return '$_temp0';
  }

  @override
  String statPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'people',
      one: 'person',
    );
    return '$_temp0';
  }

  @override
  String get moodYearTitle => 'Your Mood Year';

  @override
  String get moodYearSubtitle => 'See your mood history month by month';

  @override
  String get recentMemories => 'Recent';

  @override
  String get memoriesEmptyTitle => 'No memories yet';

  @override
  String get memoriesEmptyBody =>
      'Save your first memory: a moment, and the people in it.';

  @override
  String get filterEmpty => 'Nothing here yet.';

  @override
  String withPeople(String people) {
    return 'with $people';
  }

  @override
  String peopleTwo(String first, String second) {
    return '$first & $second';
  }

  @override
  String peopleMany(int count) {
    return '$count friends';
  }

  @override
  String get visibilityPrivate => 'Private';

  @override
  String get visibilityFriends => 'Friends';

  @override
  String get visibilityShared => 'Shared';

  @override
  String get visibilityCapsule => 'Waiting message';

  @override
  String get withOverline => 'With';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get commentsPlaceholder =>
      'Conversations are coming soon. Replies will appear here.';

  @override
  String get addCommentHint => 'Add a comment…';

  @override
  String get moreOptions => 'More options';

  @override
  String get createTitle => 'Create';

  @override
  String get createSubtitle => 'What do you want to save or share?';

  @override
  String get createFootnote =>
      'Everything stays private until you choose to share it.';

  @override
  String get addMemoryDescription => 'Save a moment and the people in it.';

  @override
  String get openWhenDescription => 'Write something to be opened later.';

  @override
  String get moodCheckInTitle => 'Mood Check-in';

  @override
  String get moodCheckInDescription =>
      'Note how today feels, in a few seconds.';

  @override
  String get memorySaved => 'Memory saved';

  @override
  String get letterScheduled => 'Open When scheduled';

  @override
  String get checkInSaved => 'Check-in saved';

  @override
  String get addMemorySubtitle =>
      'Keep the moment, and who you shared it with.';

  @override
  String get addPhotos => 'Add photos';

  @override
  String get photoUploadSoon => 'Tap to choose from your photos';

  @override
  String get photoUpload => 'Photo upload';

  @override
  String get fieldTitle => 'Title';

  @override
  String get titleHint => 'e.g. Beach sunset';

  @override
  String get titleRequired => 'Give this memory a title.';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldPeopleInvolved => 'People involved';

  @override
  String get addPeople => 'Add people';

  @override
  String removePerson(String name) {
    return 'Remove $name';
  }

  @override
  String get noFriendsToPick => 'You haven\'t added any friends yet.';

  @override
  String get fieldCaption => 'Caption';

  @override
  String get captionHint => 'What do you want to remember about it?';

  @override
  String get fieldWhoCanSee => 'Who can see it';

  @override
  String get privacyPrivate => 'Private';

  @override
  String get privacyFriends => 'Friends';

  @override
  String get privacySelected => 'Selected people';

  @override
  String get privacyPrivateDesc => 'Only you can see it.';

  @override
  String get privacyFriendsDesc => 'All your friends can see it.';

  @override
  String get privacySelectedDesc => 'Only the people involved can see it.';

  @override
  String get choosePeopleError => 'Choose who to share this memory with.';

  @override
  String get saveMemory => 'Save memory';

  @override
  String get openWhenSubtitle => 'A message that waits for the right moment.';

  @override
  String get fieldFor => 'For';

  @override
  String get chooseRecipient => 'Choose recipient';

  @override
  String get recipientRequired => 'Choose who this is for.';

  @override
  String get fieldOpenWhen => 'Open when…';

  @override
  String get openWhenHint => 'you need a reminder of who you are';

  @override
  String get openWhenRequired => 'Finish the \"Open when…\" line.';

  @override
  String get fieldMessage => 'Message';

  @override
  String get messageBodyHint => 'Write what you want them to read.';

  @override
  String get messageRequired => 'Write your message.';

  @override
  String get fieldOpenDate => 'Can be opened on';

  @override
  String get fieldNoteToSelf => 'Note to yourself';

  @override
  String get noteToSelfHint => 'Only you will see this.';

  @override
  String get schedule => 'Schedule';

  @override
  String get moodCheckInSubtitle => 'How are you today?';

  @override
  String get moodNoteLabel => 'Want to say something about today?';

  @override
  String get moodNoteHint => 'A few words, just for you.';

  @override
  String get saveCheckIn => 'Save check-in';

  @override
  String get chatTitle => 'Chat';

  @override
  String get chatSubtitle => 'Stay close to your people.';

  @override
  String get newMessage => 'New message';

  @override
  String get moodTodayTitle => 'Mood Today';

  @override
  String get moodTodayEmpty => 'No friends have checked in yet';

  @override
  String get messagesTitle => 'Messages';

  @override
  String unreadCount(int count) {
    return '$count unread';
  }

  @override
  String get allCaughtUp => 'All caught up';

  @override
  String get conversationsEmptyTitle => 'No conversations yet';

  @override
  String get conversationsEmptyBody =>
      'Start a conversation with one of your friends.';

  @override
  String get startChat => 'Start Chat';

  @override
  String get startChatTitle => 'Start a chat';

  @override
  String youPrefix(String text) {
    return 'You: $text';
  }

  @override
  String get sayHello => 'Say hello';

  @override
  String get online => 'Online';

  @override
  String get messageHint => 'Message';

  @override
  String get send => 'Send';

  @override
  String get sending => 'Sending…';

  @override
  String get sent => 'Sent';

  @override
  String get read => 'Read';

  @override
  String get notSent => 'Not sent';

  @override
  String get shareInChat => 'Share in chat';

  @override
  String get attachMemoryDesc => 'Share a memory in this chat';

  @override
  String get sendOpenWhen => 'Send Open When';

  @override
  String get sendOpenWhenDesc => 'A message they can open later';

  @override
  String get chatOptions => 'Chat options';

  @override
  String get closeReactions => 'Close reactions';

  @override
  String get reactionLove => 'Love';

  @override
  String get reactionAgree => 'Agree';

  @override
  String get reactionHaha => 'Haha';

  @override
  String get reactionSad => 'Sad';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get friendsSubtitle => 'The people you share your moments with.';

  @override
  String friendsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends',
      one: '1 friend',
      zero: 'No friends yet',
    );
    return '$_temp0';
  }

  @override
  String get addFriendSubtitle => 'Add someone you want to share moments with.';

  @override
  String get fieldName => 'Name';

  @override
  String get nameHint => 'Their full name';

  @override
  String get nameRequired => 'Enter a name.';

  @override
  String get fieldContact => 'Email or phone';

  @override
  String get contactHint => 'So you can invite them later';

  @override
  String friendAdded(String name) {
    return '$name added';
  }

  @override
  String get message => 'Message';

  @override
  String get ourStory => 'Our Story';

  @override
  String ourStorySubtitle(String name) {
    return 'Everything you\'ve shared with $name.';
  }

  @override
  String get ourStoryEmptyTitle => 'No shared memories yet';

  @override
  String ourStoryEmptyBody(String name) {
    return 'Memories you share with $name will appear here.';
  }

  @override
  String get noMoodToday => 'Hasn\'t checked in today';

  @override
  String sharedMemoriesStat(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'shared memories',
      one: 'shared memory',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get settingsSubtitle => 'Language and preferences';

  @override
  String get language => 'Language';

  @override
  String get languageHint => 'Choose the language of the app.';

  @override
  String get readyToOpen => 'Ready to open';

  @override
  String get tapToOpen => 'Tap to open';

  @override
  String openedOn(String date) {
    return 'Opened $date';
  }

  @override
  String firstOpenedOn(String date) {
    return 'First opened $date';
  }

  @override
  String writtenOn(String date) {
    return 'Written $date';
  }

  @override
  String get fromYou => 'From you';

  @override
  String get futureYou => 'Future you';

  @override
  String letterLockedToast(String date) {
    return 'This message opens $date';
  }

  @override
  String get voiceNote => 'Voice note';

  @override
  String get yourNote => 'Your note';

  @override
  String get letterForYou => 'For you';

  @override
  String get sealedMessage => 'Sealed message';

  @override
  String openWhenPhrase(String phrase) {
    return 'Open when $phrase';
  }

  @override
  String get waitingMessagesTitle => 'Waiting Messages';

  @override
  String get waitingMessagesSubtitle =>
      'Messages that open at the right moment.';

  @override
  String get waitingMessageOverline => 'Waiting message';

  @override
  String get waitingEmptyTitle => 'No waiting messages yet';

  @override
  String get waitingEmptyBody =>
      'Write a message that opens on the date and time you choose.';

  @override
  String get createMessage => 'Create Message';

  @override
  String get createMessageSubtitle =>
      'Write it now. It opens when the time comes.';

  @override
  String get waitingMessagesDescription => 'Schedule a message to open later.';

  @override
  String get fieldRecipient => 'To';

  @override
  String get fieldMessageTitle => 'Message title';

  @override
  String get messageTitleHint => 'e.g. For your birthday';

  @override
  String get messageTitleRequired => 'Give the message a title.';

  @override
  String get fieldImage => 'Image';

  @override
  String get addImage => 'Add an image';

  @override
  String get removeImage => 'Remove image';

  @override
  String get fieldOpenDay => 'Opens on';

  @override
  String get fieldOpenTime => 'At';

  @override
  String get openTimeInPast => 'Choose a time in the future.';

  @override
  String get scheduleMessage => 'Schedule message';

  @override
  String get messageScheduled => 'Message scheduled';

  @override
  String toName(String name) {
    return 'To $name';
  }

  @override
  String get toFutureYou => 'To future you';

  @override
  String get attachWaitingMessage => 'Waiting message';

  @override
  String get attachWaitingMessageDesc => 'A message that opens later';

  @override
  String get imagePickFailed => 'Couldn\'t open your photos.';

  @override
  String get statusWaiting => 'Waiting';

  @override
  String get statusOpened => 'Opened';

  @override
  String get authSignInTitle => 'Welcome back';

  @override
  String get authSignUpTitle => 'Create your account';

  @override
  String get authSubtitle => 'A private space for you and your people.';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Create account';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get noAccount => 'New to Memories?';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldYourName => 'Your name';

  @override
  String get yourNameHint => 'How friends will see you';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get passwordTooShort => 'Use at least 6 characters.';

  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get authErrorInvalidCredentials => 'Email or password is incorrect.';

  @override
  String get authErrorEmailNotConfirmed =>
      'Please confirm your email first, then sign in.';

  @override
  String get authErrorEmailInUse =>
      'An account with this email already exists. Try signing in.';

  @override
  String get authErrorWeakPassword => 'Choose a stronger password.';

  @override
  String get authErrorRateLimited =>
      'Too many attempts. Please wait a moment and try again.';

  @override
  String get authErrorNetwork =>
      'Can\'t connect. Check your internet connection.';

  @override
  String get authErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get confirmEmailSent =>
      'Check your email to confirm your account, then sign in.';

  @override
  String get account => 'Account';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Sign out of Memories?';

  @override
  String get cancel => 'Cancel';

  @override
  String get photoUploadFailed =>
      'Couldn\'t upload the photo. Please try again.';
}
