import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterlens_lite/main.dart';
import 'package:waterlens_lite/database/db.dart';
import 'package:drift/native.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // 使用内存数据库进行测试
    database = AppDatabase(executor: NativeDatabase.memory());

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the map page is displayed
    expect(find.text('地图页 (兰州)'), findsOneWidget); // Title in AppBar

    // Clean up to avoid pending timers from flutter_map or async tasks
    await tester.pumpWidget(const Placeholder());
    await tester.pumpAndSettle();
  });
}
