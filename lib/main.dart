import 'package:alice_lightweight/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_admin/screens/dashboard/dasboard_bloc.dart';
import 'package:pos_admin/screens/main/main_screen.dart';
import 'package:pos_admin/services/dio_client.dart';
import 'package:pos_admin/services/repository/dashboard_repository.dart';

void main() {
  Alice alice = Alice();
  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(
              DashboardRepositoryImpl(DioClient().init(alice)),
            ),
          ),
        ],
        child: MyApp(alice)
    ),
  );
  // runApp(MyApp(alice));
}

class MyApp extends StatelessWidget {

  Alice? alice;

  MyApp(this.alice);

  @override
  Widget build(BuildContext context) {
    // ShakeDetector.autoStart(
    //     onPhoneShake: () {
    //       alice?.showInspector();
    //     }
    // );
    return MaterialApp(
        navigatorKey: alice?.getNavigatorKey(),
        debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: MainScreen(),
    );
  }
}

