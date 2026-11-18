
import 'package:flutter_test/flutter_test.dart';
import 'package:latrespamfix/main.dart';

void main() {
  testWidgets('Spaceflight app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const SpaceflightApp());

    expect(find.byType(SpaceflightApp), findsOneWidget);
  });
}
