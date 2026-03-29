import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/providers/task_provider.dart';
import 'package:test_app/providers/providers/theme_provider.dart';
import 'package:test_app/screens/screens/main_list_screen.dart';
import 'package:test_app/services/services/hive_service.dart';
import 'package:test_app/theme/theme/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()..loadTasks()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flodo Task Manager',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: MainListScreen(),
          );
        },
      ),
    );
  }
}