import 'package:flutter/material.dart';
import 'package:nitrous/Test/login_screen.dart';
import 'package:nitrous/Test/screens/signup_screen.dart';
import '../models/screens_models/signup_screen_model.dart';
import '../models/screens_models/login_screen_model.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final loginModel = LoginScreenModel();
  final signupModel = SignUpScreenModel();

  bool loading = false;
  bool login = true;

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background.png"),
                        fit: BoxFit.cover)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                            MediaQuery.of(context).size.width * 0.05),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: login
                            ? MediaQuery.of(context).size.height * 0.6
                            : MediaQuery.of(context).size.height * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 0),
                                  blurRadius: 3)
                            ]),
                        child: SingleChildScrollView(
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/images/nitrouslogo.png",
                                  height:
                                  MediaQuery.of(context).size.height * 0.15,
                                  fit: BoxFit.cover),
                              TabBar(
                                controller: _tabController,
                                labelColor: Colors.blue,
                                labelPadding: EdgeInsets.all(5),
                                tabs: [
                                  Tab(
                                    child: Text("Login"),
                                  ),
                                  Tab(
                                    child: Text("Sign up"),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                height:
                                MediaQuery.of(context).size.height * 0.4,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    LoginScreen(
                                      model: loginModel,
                                    ),
                                    SignupScreen(
                                      model: signupModel,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.13,
                  left: MediaQuery.of(context).size.width * 0.36,
                  child: Container(
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 1),
                                blurRadius: 1)
                          ]),
                      child: !loading
                          ? InkWell(
                        onTap: () async {
                          bool done;
                          setState(() {
                            loading = true;
                          });
                          _tabController.index == 0
                              ? done = await loginModel.login(context)
                              : done = await signupModel.signup(context);
                          if (!done) {
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.5, 1.0],
                              colors: [Colors.blue, Colors.blue[200]],
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      )
                          : Center(child: CircularProgressIndicator())))
            ],
          ),
        ),
      ),
    );
  }
}