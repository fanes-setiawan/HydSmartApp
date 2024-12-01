import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/presentations/home/view/home_view.dart';
import 'package:hyd_smart_app/presentations/remote/view/remote_view.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeView(),
    const RemoteView(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Assets.icons.home.svg(
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0 ? AppColors.primary : AppColors.gray,
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Assets.icons.server.svg(
                colorFilter: ColorFilter.mode(
                    _selectedIndex == 1 ? AppColors.primary : AppColors.gray,
                    BlendMode.srcIn),
              ),
              label: 'Control'),
         
        ],
      ),
    );
  }
}