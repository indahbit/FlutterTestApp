import 'package:flutter/material.dart';
// import 'package:aplikasi_gudang/auth.dart';

// This app is a stateful, it tracks the user's current choice.
class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState  extends State<HomeScreen> {
                // implements AuthStateListener{
  BuildContext _ctx;
  // Choice _selectedChoice = choices[0]; // The app's "state".

  HomeScreenState() {
    // var authStateProvider = new AuthStateProvider();
    // authStateProvider.subscribe(this);
  }

  @override
  void dispose() {
    // var authStateProvider = new AuthStateProvider();
    // authStateProvider.dispose(this);
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      // var authStateProvider = new AuthStateProvider();
      // authStateProvider.LogOut();
    });
  }
  
  // @override
  // onAuthStateChanged(AuthState state) {
  //   if(state == AuthState.LOGGED_OUT)
  //     Navigator.of(_ctx).popAndPushNamed("/login");
  // }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return new Scaffold(
      appBar: new AppBar(
            title: new Text("Home"),
            actions: <Widget>[
            // overflow menu
              PopupMenuButton<Choice>(
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.map((Choice choice) {
                    return PopupMenuItem<Choice>(
                      value: choice,
                      child: Text(choice.title),
                    );
                  }).toList();
                },
              ),
            ]
          ),
      body: new Center(
        child: new Text("Welcome home!"),
      ),
    );
  }

}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Log Out', icon: Icons.directions_car),
  // const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  // const Choice(title: 'Boat', icon: Icons.directions_boat),
  // const Choice(title: 'Bus', icon: Icons.directions_bus),
  // const Choice(title: 'Train', icon: Icons.directions_railway),
  // const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}