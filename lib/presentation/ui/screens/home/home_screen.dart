import 'package:Hercules/presentation/ui/screens/home/calendar/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_cubit.dart';
import 'home_state.dart';
import 'main/main_screen.dart';
import 'profile/profile_screen.dart';
import 'search/search_screen.dart';
import 'statistic/statistic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomeScreen());
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 2;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(),
      child: BlocListener<HomeCubit, HomeState>(
          listener: _handleState,
          child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Scaffold(
                    body: PageView(
                      controller: _pageController,
                      children: [
                        CalendarScreen(),
                        StatisticScreen(),
                        MainScreen(),
                        SearchScreen(),
                        ProfileScreen()
                      ],
                    ),
                  bottomNavigationBar: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(icon: Icon(Icons.call_end)),
                      BottomNavigationBarItem(icon: Icon(Icons.bar_chart)),
                      BottomNavigationBarItem(icon: Icon(Icons.domain)),
                      BottomNavigationBarItem(icon: Icon(Icons.search)),
                      BottomNavigationBarItem(icon: Icon(Icons.person)),
                    ],
                    currentIndex: _selectedIndex,
                    onTap: _onTapped,
                  ),
                );
              }
          )
      ),
    );
  }

  void _handleState(BuildContext context, HomeState state) {

  }

  void _onTapped(int index) {
    setState((){
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }
}
