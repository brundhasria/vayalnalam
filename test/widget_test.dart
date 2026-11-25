import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vayalnalam/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('VayalNalam app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const VayalNalamApp(initialLanguage: 'en'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('VayalNalam'), findsOneWidget);
    expect(find.text('வயல் நலம்'), findsOneWidget);

    // Advance past splash transition timer
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();
  });
}
