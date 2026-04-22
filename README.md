Predictive back swiping pops both nested and root navigator routes.
You can switch between AppPage(with temporary fix) and MaterialPage.
Tested on Android 16 with predictive back swipes.

My screen recording of the bug popping 2 pages with one swipe:
[Screen_Recording_20260423_005945.mp4](Screen_Recording_20260423_005945.mp4)
```
[✓] Flutter (Channel stable, 3.41.7, on macOS 26.4.1 25E253 darwin-arm64, locale en-US) [854ms]
• Flutter version 3.41.7 on channel stable at /Users/asaarnak/A/PROGRAMS/flutter
• Upstream repository https://github.com/flutter/flutter.git
• Framework revision cc0734ac71 (7 days ago), 2026-04-15 21:21:08 -0700
• Engine revision 59aa584fdf
• Dart version 3.11.5
• DevTools version 2.54.2
• Feature flags: enable-web, enable-linux-desktop, enable-macos-desktop, enable-windows-desktop, enable-android, enable-ios, cli-animations, enable-native-assets,
enable-swift-package-manager, omit-legacy-version-file, enable-lldb-debugging, enable-uiscene-migration
```

```
Gemini 3.1 Pro explanation of the problem:
The Root Cause
When you open "TopPage" Page on top of "NestedNavigatorWrapper" Page, the "TopPage" is correctly marked as the active foreground route (isCurrent == true) in the root navigator.
However, "NestedNavigatorWrapper" Page is also the top route of its own nested navigator.
In Flutter's eyes, its isCurrent property is also true (relative to its own nested stack).
Standard Flutter MaterialPageRoute automatically registers a gesture listener for predictive back.
When you start swiping, the Flutter engine broadcasts the gesture to all active listeners.
Since both the "Top Page" and the nested "NestedNavigatorWrapper" Page have isCurrent == true, they both receive the gesture, animate, and pop simultaneously!
```