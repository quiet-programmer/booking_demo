import 'package:book_app_demo/const_values.dart';
import 'package:book_app_demo/models/user_model.dart';
import 'package:book_app_demo/services/api_service.dart';
import 'package:book_app_demo/widgets/loading.dart';
import 'package:book_app_demo/widgets/profile_container.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService _apiService = ApiService();

  List<UserModel> listOfUser = List<UserModel>();
  List<UserModel> listToSearch = List<UserModel>();

  @override
  void initState() {
    super.initState();
    _apiService.fetchUserDetials().then((value) {
      setState(() {
        listToSearch.addAll(value);
        listOfUser = listToSearch;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(listOfUser.length);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(logoImagePath, width: 120),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black45),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.text,
                        onChanged: (text) {
                          text = text.toLowerCase();
                          setState(() {
                            listOfUser = listToSearch.where((value) {
                              var userName = value.firstName.toLowerCase();
                              return userName.contains(text);
                            }).toList();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search user name only",
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: _apiService.fetchUserDetials(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    // listOfUser = snapshot.data;
                    return ListView.builder(
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listOfUser.length,
                      itemBuilder: (_, index) {
                        return ProfileContainer(
                          userIndex: listOfUser[index],
                        );
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return LoadingWidget();
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Counld not connect"),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: Text("Refresh"),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
