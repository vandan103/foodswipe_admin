
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodadmin/helper/navigation.dart';
import 'package:foodadmin/helper/style.dart';
import 'package:foodadmin/model/category.dart';
import 'package:foodadmin/model/order.dart';
import 'package:foodadmin/model/product.dart';
import 'package:foodadmin/model/restaurant.dart';
import 'package:foodadmin/model/user.dart';
import 'package:foodadmin/provider/user.dart';
import 'package:foodadmin/screen/add_category.dart';
import 'package:foodadmin/screen/add_restaurant.dart';
import 'package:foodadmin/screen/login.dart';
import 'package:foodadmin/screen/show_category.dart';
import 'package:foodadmin/screen/show_product.dart';
import 'package:foodadmin/screen/show_restaurants.dart';
import 'package:foodadmin/widget/custom_text.dart';
import 'package:provider/provider.dart';

import 'add_product.dart';

enum Page { dashboard, manage }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  CategoryService _categoryService = CategoryService();
  RestaurantService _restaurantService = RestaurantService();
  ProductService _productService = ProductService();
  OrderServices _orderServices =OrderServices();
  Users _users=Users();

  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  int value ;




  @override
  Widget build(BuildContext context) {
    final  _user = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard ? active : notActive,
                      ),
                      label: Text('Dashboard')
                  )
              ),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color: _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: primary),
                accountName: CustomText(
                  text: _user?.name.text?? "username lading...",
                  color: white,
                  weight: FontWeight.bold,
                  size: 18,
                ),
                accountEmail: CustomText(
                  text: _user?.email.text ?? "email loading...",
                  color: white,
                ),
              ),
              ListTile(
                onTap: () {
                  changeScreen(context, Home());
                },
                leading: Icon(Icons.home),
                title: CustomText(text: "Home"),
              ),


              ListTile(
                onTap: () {
                  _user.signOut();
                  changeScreenReplacement(context, login());
                },
                leading: Icon(Icons.exit_to_app),
                title: CustomText(text: "Log out"),
              ),
            ],
          ),
        ),
        body: _loadScreen());
  }


  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              title: (
                 Text(
                  'Revenue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, color: Colors.grey),
                )
              ),
              subtitle: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: StreamBuilder(
                  stream: Firestore.instance.collection('orders').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    var ds = snapshot.data.documents;
                    double sum = 0.0;
                    for(int i=0; i<ds.length;i++)
                      sum+=(ds[i]['total']).toDouble();
                    return Text('$sum',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30.0, color: Colors.green) );
                  },
                ),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2 ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Text("Users")),
                          subtitle: FutureBuilder(
                            future: usercount(),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 60.0, color:active,),
                              );
                            },
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              icon: Icon(Icons.category),
                              label: Text("Category")),
                          subtitle: FutureBuilder<String>(
                            future: categorycount(),
                            builder: (context,snapshot) {
                              return Text(
                                snapshot.data.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 60.0),
                              );
                            },
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Product")),
                          subtitle: FutureBuilder(
                             future: productcount(),
                              builder:(context, snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 60.0,color: active),
                                );
                              },

                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                            onPressed: null,
                              icon: Icon(Icons.tag_faces),
                              label: Text('client')), //restaurants
                          subtitle: FutureBuilder(
                            future: restaurantcount(),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 60.0),
                              );
                            },
                          ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders")),
                          subtitle: FutureBuilder(
                            future: ordercount(),
                            builder: (context, snapshot) {
                              return Text(
                                 snapshot.data.toString() ,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 60.0),);
                            },

                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("closed")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_)=> ShowProduct())); },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                // _categoryAlert();
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddCategory()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_)=> ShowCategory())); },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add restaurant"),
              onTap: () {
                // _brandAlert();
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddRestaurant()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("Restaurant list"),
              onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_)=> ShowRestaurants() ));} ,
            ),
            Divider(),
          ],
        );
        break;
      default:
        return Container();


    }
  }


  Future<String> categorycount()  async {
    int valueString = await _categoryService.categorycount();
    print("the category is $valueString");
    return valueString != null ? "$valueString" : "0";
  }


  Future<String> productcount() async{
    int value =await _productService.productcount();
    print("the product is $value ");
    return value != null? "$value": "0";

  }
  Future<String> restaurantcount( ) async{
    int values =await _restaurantService.restaurantcount();
    print("the restaurant is  $values");
    return values!=null? "$values":"0";
  }

   Future<String> ordercount() async {
    int orders= await _orderServices.getorders();
    print("the order is $orders");
    return orders!=null ? "$orders":"0";

  }

  Future<String> usercount() async{
    int count=await _users.usercount();
    print("the users is $count");
    return count!=null ? "$count" : "0";
  }

}
