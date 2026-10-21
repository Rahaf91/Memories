import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/app/app.dart';
import 'package:memories/app/dependencies.dart';
import 'package:memories/data/mock/mock_auth_repository.dart';
import 'package:memories/screens/auth/auth_screen.dart';
import 'package:memories/screens/home/home_screen.dart';
import 'package:memories/screens/profile/profile_screen.dart';
import 'package:memories/screens/settings/settings_screen.dart';
import 'package:memories/screens/shell/main_shell.dart';
import 'package:memories/widgets/common/primary_button.dart';

import 'test_helpers.dart';

void main() {
  late MockAuthRepository auth;
  late AppDependencies deps;

  Future<void> pumpSignedOut(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    // Mirrors the Supabase project: email confirmation is required.
    auth = MockAuthRepository(signedIn: false, requireEmailConfirmation: true);
    deps = AppDependencies.local(authRepository: auth);
    await tester.pumpWidget(MemoriesApp(dependencies: deps));
    await settle(tester);
  }

  Finder field(int i) => find.byType(TextFormField).at(i);

  Future<void> submit(WidgetTester tester) async {
    await tester.tap(find.byType(PrimaryButton));
    await settle(tester);
  }

  Future<void> signIn(WidgetTester tester, String email, String pw) async {
    await tester.enterText(field(0), email);
    await tester.enterText(field(1), pw);
    await submit(tester);
  }

  const email = 'sam@example.com';
  // Generated per run: no credentials are stored in the repository.
  final password = _randomPassword();

  testWidgets('sign up → sign in → app opens → sign out → sign in again', (
    tester,
  ) async {
    await pumpSignedOut(tester);
    expect(find.byType(AuthScreen), findsOneWidget);
    expect(find.byType(MainShell), findsNothing);
    expect(find.text('Welcome back'), findsOneWidget);

    // SIGN UP
    await tester.tap(find.widgetWithText(TextButton, 'Create account'));
    await settle(tester);
    expect(find.text('Create your account'), findsOneWidget);
    await tester.enterText(field(0), 'Sam Rivera');
    await tester.enterText(field(1), email);
    await tester.enterText(field(2), '123');
    await submit(tester);
    expect(find.text('Use at least 6 characters.'), findsOneWidget);

    await tester.enterText(field(2), password);
    await submit(tester);
    expect(
      find.text('Check your email to confirm your account, then sign in.'),
      findsOneWidget,
    );
    expect(find.text('Welcome back'), findsOneWidget); // back to sign-in
    expect(find.text(email), findsOneWidget); // email kept

    // Signing in before confirming is refused with a clear message.
    await tester.enterText(field(1), password);
    await submit(tester);
    expect(
      find.text('Please confirm your email first, then sign in.'),
      findsOneWidget,
    );
    expect(find.byType(MainShell), findsNothing);

    // SIGN IN (after confirming the email) → APP OPENS as that user.
    auth.confirmEmail(email);
    await signIn(tester, email, password);
    expect(find.byType(AuthScreen), findsNothing);
    expect(find.byType(MainShell), findsOneWidget);
    expect(find.textContaining('Sam'), findsWidgets); // greeting uses the name
    expect(deps.auth.user!.displayName, 'Sam Rivera');

    // SIGN OUT from Settings (Profile → Settings → Sign out → confirm).
    await openTab(tester, 'Profile');
    await tapIn(tester, ProfileScreen, 'Settings');
    expect(find.byType(SettingsScreen), findsOneWidget);
    await tapIn(tester, SettingsScreen, 'Sign out');
    expect(find.text('Sign out of Memories?'), findsOneWidget);
    await tester.tap(find.text('Sign out').last);
    await settle(tester);
    expect(find.byType(SettingsScreen), findsNothing);
    expect(find.byType(MainShell), findsNothing);
    expect(find.byType(AuthScreen), findsOneWidget);

    // SIGN IN AGAIN: wrong password first, then the right one.
    await signIn(tester, email, '${password}x');
    expect(find.text('Email or password is incorrect.'), findsOneWidget);
    await signIn(tester, email, password);
    expect(find.byType(MainShell), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
    await settleTimers(tester);
  });

  testWidgets('each account sees only its own local data', (tester) async {
    await pumpSignedOut(tester);
    for (final (name, mail) in [
      ('Sam', 'a@example.com'),
      ('Lee', 'b@example.com'),
    ]) {
      await pumpUntilDone(
        tester,
        auth.signUp(email: mail, password: password, displayName: name),
      );
      auth.confirmEmail(mail);
    }
    await pumpUntilDone(
      tester,
      auth.signIn(email: 'a@example.com', password: password),
    );
    await settle(tester);
    await addFriend(tester, deps, 'Noor Hassan');
    expect(
      (await pumpUntilDone(tester, deps.friendsService.friendsToday())).length,
      1,
    );

    await pumpUntilDone(tester, auth.signOut());
    await pumpUntilDone(
      tester,
      auth.signIn(email: 'b@example.com', password: password),
    );
    await settle(tester);
    expect(
      await pumpUntilDone(tester, deps.friendsService.friendsToday()),
      isEmpty,
    );
    await settleTimers(tester);
  });
}

String _randomPassword() {
  final random = Random.secure();
  return List.generate(24, (_) => random.nextInt(36).toRadixString(36)).join();
}
