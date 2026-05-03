# Week 5 — Testing Challenge

This repo is your Week 5 assignment. It contains real application code with **4 hidden bugs**. Your job is to find them, write tests that expose them, and fix them — following the TDD cycle.

---

## How to Start

1. **Fork this repo** to your own GitHub account
2. Clone your fork locally
3. Run `flutter pub get`
4. Run `flutter test` — you should see 0 tests pass (all test files are empty stubs)
5. Start writing tests, one file at a time

---

## The Bugs

There are 4 bugs hidden across the codebase. Each one has a comment starting with `// BUG` that describes the problem without giving away the fix. Your job is to:

- Read the bug comment
- Write a test that **fails** because of the bug
- Fix the bug in the source code
- Confirm the test now **passes**

### Where the bugs are

| File | Bug |
|---|---|
| `lib/features/auth/domain/usecases/login_usecase.dart` | Bug 1 |
| `lib/features/auth/presentation/bloc/auth_bloc.dart` | Bug 2 |
| `lib/features/chat/domain/usecases/send_message_usecase.dart` | Bug 3 |
| `lib/features/chat/domain/usecases/watch_messages_usecase.dart` | Bug 4 |

---

## The TDD Cycle — Follow This Every Time

```
Red   → Write a test. Run it. Confirm it FAILS.
Green → Fix the bug. Run the test. Confirm it PASSES.
Refactor → Clean up if needed. Run again to make sure nothing broke.
```

Never fix the code before writing the test. That defeats the whole point.

---

## Test Files

Your test stubs are already created in `/test`. Each file has a `TODO` comment with the exact scenarios you need to cover.

```
test/
  features/
    auth/
      login_usecase_test.dart     ← Unit tests for LoginUseCase (Bug 1)
      auth_bloc_test.dart         ← BLoC tests for AuthBloc (Bug 2)
    chat/
      send_message_usecase_test.dart  ← Unit tests for SendMessageUseCase (Bug 3)
      watch_messages_usecase_test.dart ← Unit tests for WatchMessagesUseCase (Bug 4)
      chat_bloc_test.dart         ← BLoC tests for ChatBloc
```

---

## Resources — Read Before Starting

- **Flutter unit testing intro**: https://docs.flutter.dev/cookbook/testing/unit/introduction
- **BLoC testing guide**: https://bloclibrary.dev/testing
- **mocktail README**: https://pub.dev/packages/mocktail
- **bloc_test README**: https://pub.dev/packages/bloc_test

---

## Submission

1. Push your completed branch to your fork
2. Make sure `flutter test` passes with **zero failures**
3. Share your fork link with the mentor

---

## Checklist Before Submitting

- [ ] All 4 bugs are fixed
- [ ] Each fix has a corresponding test that was written **before** the fix
- [ ] All repository calls in tests are mocked — no real Firebase or network calls
- [ ] `flutter test` runs clean with no failures
- [ ] Each test file covers both success and failure paths
