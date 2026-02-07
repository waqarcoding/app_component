import 'package:app_component/widgets/app_container.dart';
import 'package:app_component/widgets/chip_widget.dart';
import 'package:app_component/widgets/gradient_container_widget.dart';
import 'package:app_component/widgets/neon_input_widget.dart';
import 'package:app_component/widgets/appbar_widget.dart';
import 'package:app_component/widgets/appgrid_widget.dart';
import 'package:app_component/widgets/applist_widget.dart';
import 'package:app_component/widgets/appbar_widget.dart';
import 'package:app_component/widgets/radiogroup_widget.dart';
import 'package:app_component/widgets/switch_bar_widget.dart';
import 'package:app_component/widgets/tab_bar_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Widget Example',
      home: const ExampleHome(),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class ExampleHome extends StatelessWidget {
  const ExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBarWidget<User>(
        title: "Users",
        isShowSearchBar: () => SearchBarConfig<User>(
          url: "https://jsonplaceholder.typicode.com/users",
          fromJson: User.fromJson,

          searchBackgroundColor: Colors.white,
          searchBy: (user) => user.name, // filter by name
          itemBuilder: (user) => ListTile(
            leading: CircleAvatar(child: Text(user.name[0])),
            title: Text(user.name),
            subtitle: Text(user.email),
            onTap: () => debugPrint("Selected: ${user.name}"),
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              TabBarWidget(tabs: [
                'Card',
                'Slider',
                'Switch',
                'TextField',
                'Checkbox',
                'Dropdown',
                'AppBar',
                'BottomNavigationBar',
                'Dialog',
                'SnackBar',
                'ListTile',
                'ExpansionPanel',
              ], onTabChanged: (index) {}, labelBuilder: (label) => label),
              SizedBox(height: 10),
              Title('Neon Input Tab'),
              Center(
                child: NeonInputBox(
                  tabs: const ['Text', 'Lyrics', 'Image'],
                ),
              ),
              Title('ChipWidget'),
              ChipWidget<String>(
                values: ['Basic', 'Pro', 'Enterprise'],
                alignment: WrapAlignment.center,
                isEnabledRadioBtn: true,
                unselectedRadioIcon:
                    Icons.radio_button_off, // 👈 hide when unselected
                selectedRadioIcon: Icons.check_circle,

                unselectedRadioIconColor: Colors.black26,

                enableTapEffect: true,
                onSelected: (v, i) {
                  debugPrint('$v');
                },
              ),
              Title('SwitchBarWidget'),
              SwitchBarWidget(items: [
                SwitchItem(
                  label: 'Home',
                  icon: Ionicons.sparkles,
                  page: Container(
                    color: Colors.blueAccent,
                    alignment: Alignment.center,
                    child: const Text(
                      'Home',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SwitchItem(
                  label: 'Pending',
                  icon: Icons.timelapse,
                  page: Container(
                    color: Colors.greenAccent,
                    alignment: Alignment.center,
                    child: const Text(
                      'Pending Tasks',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SwitchItem(
                  label: 'Completed',
                  icon: Icons.check_circle,
                  page: Container(
                    color: Colors.orangeAccent,
                    alignment: Alignment.center,
                    child: const Text(
                      'Completed Tasks',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ]),
              Title('RadioGroupWidget'),
              RadioGroupWidget<String>(
                items: ['Basic', 'Pro', 'Enterprise'],
                titleBuilder: (v) => v,
                subtitleBuilder: (v) => 'Plan: $v',
                onChanged: (item) {
                  print("Selected:$item");
                },
              ),
              Title('AppList'),
              SizedBox(
                height: 300,
                child: AppListView<String>(
                  isShowFilter: true,
                  isSelectable: true,
                  filterNames: ['New', 'Old'],
                  searchTrailingIcon: Icons.search,
                  isSearchable: true,
                  items: [
                    'Card',
                    'Slider',
                    'Switch',
                    'TextField',
                    'Checkbox',
                    'Dropdown',
                    'AppBar',
                    'BottomNavigationBar',
                    'Dialog',
                    'SnackBar',
                    'ListTile',
                    'ExpansionPanel',
                  ],
                  leadingIconBuilder: (icon) => Icons.menu_book_sharp,
                  subtitleBuilder: (s) => "Detail text here",
                  onTap: (e) => debugPrint('Tapped $e'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Title(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
