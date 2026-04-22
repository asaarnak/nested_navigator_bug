You can switch between AppPage(with temporary fix) and MaterialPage to test.

My screen recording of the bug popping 2 pages with one swipe:
[Screen_Recording_20260423_005945.mp4](Screen_Recording_20260423_005945.mp4)

Gemini 3.1 Pro explanation of the problem:

The Root Cause

When you open "TopPage" Page on top of "NestedNavigatorWrapper" Page, the "TopPage" is correctly marked as the active foreground route (isCurrent == true) in the root navigator.

However, "NestedNavigatorWrapper" Page is also the top route of its own nested navigator.
In Flutter's eyes, its isCurrent property is also true (relative to its own nested stack).
Standard Flutter MaterialPageRoute automatically registers a gesture listener for predictive back.
When you start swiping, the Flutter engine broadcasts the gesture to all active listeners.
Since both the "Top Page" and the nested "NestedNavigatorWrapper" Page have isCurrent == true, they both receive the gesture, animate, and pop simultaneously!
