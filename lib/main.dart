import 'package:flutter/material.dart';

import 'app_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showNestedNavigator = false;
  bool _showTopPage = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        pages: [
          // MaterialPage(
          AppPage(
            name: 'RootScreen',
            child: RootScreen(
              onOpenNested: () => setState(() => _showNestedNavigator = true),
            ),
          ),
          if (_showNestedNavigator)
            // MaterialPage(
            AppPage(
              name: 'NestedNavigatorWrapper',
              child: NestedNavigatorWrapper(
                onOpenTopPage: () => setState(() => _showTopPage = true),
              ),
            ),
          if (_showTopPage)
            // MaterialPage(
            AppPage(
              name: 'TopPage',
              child: TopPage(
                onClose: () => setState(() => _showTopPage = false),
              ),
            ),
        ],
        onDidRemovePage: (page) {
          if (page.name == 'NestedNavigatorWrapper') {
            setState(() => _showNestedNavigator = false);
          }
          if (page.name == 'TopPage') {
            setState(() => _showTopPage = false);
          }
        },
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key, required this.onOpenNested});
  final VoidCallback onOpenNested;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predictive Back Bug')),
      body: Center(
        child: ElevatedButton(
          onPressed: onOpenNested,
          child: const Text('Open Nested Navigator'),
        ),
      ),
    );
  }
}

class NestedNavigatorWrapper extends StatefulWidget {
  const NestedNavigatorWrapper({super.key, required this.onOpenTopPage});
  final VoidCallback onOpenTopPage;
  @override
  State<NestedNavigatorWrapper> createState() => _NestedNavigatorWrapperState();
}

class _NestedNavigatorWrapperState extends State<NestedNavigatorWrapper> {
  bool _showPage2 = false;
  @override
  Widget build(BuildContext context) {
    final pages = [
      // MaterialPage(
      AppPage(
        name: 'NestedPage1',
        child: NestedPage1(
          onOpenPage2: () => setState(() => _showPage2 = true),
        ),
      ),
      if (_showPage2)
        // MaterialPage(
        AppPage(
          name: 'NestedPage2',
          child: NestedPage2(onOpenTopPage: widget.onOpenTopPage),
        ),
    ];
    return NavigatorPopHandler(
      enabled: pages.length > 1,
      onPopWithResult: (_) {},
      child: Navigator(
        pages: pages,
        onDidRemovePage: (page) {
          if (page.name == 'NestedPage2') {
            setState(() => _showPage2 = false);
          }
        },
      ),
    );
  }
}

class NestedPage1 extends StatelessWidget {
  const NestedPage1({super.key, required this.onOpenPage2});
  final VoidCallback onOpenPage2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(title: const Text('Nested Page 1')),
      body: Center(
        child: ElevatedButton(
          onPressed: onOpenPage2,
          child: const Text('Open Nested Page 2'),
        ),
      ),
    );
  }
}

class NestedPage2 extends StatelessWidget {
  const NestedPage2({super.key, required this.onOpenTopPage});
  final VoidCallback onOpenTopPage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(title: const Text('Nested Page 2')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'I am the TOP route of the NESTED navigator.\n'
              'My ModalRoute.isCurrent is TRUE.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onOpenTopPage,
              child: const Text('Push Top Dialog on Root Navigator'),
            ),
          ],
        ),
      ),
    );
  }
}

class TopPage extends StatelessWidget {
  const TopPage({super.key, required this.onClose});
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'I am the top route of the ROOT navigator.\n\n'
                'BUG: If you use the Android Predictive Back swipe now,\n'
                'BOTH this dialog AND the Nested Page underneath will animate simultaneously!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onClose,
                child: const Text('Close Dialog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
