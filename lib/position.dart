// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'locationJs.dart';
// import 'package:js/js.dart';
// import 'package:mapbox_search/mapbox_search.dart';
// import 'package:mapbox_geocoding/mapbox_geocoding.dart';
// import 'package:mapbox_geocoding/model/reverse_geocoding.dart';
//
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // Provide a function to handle named routes. Use this function to
//       // identify the named route being pushed, and create the correct
//       // Screen.
//       onGenerateRoute: (settings) {
//         // If you push the PassArguments route
//         if (settings.name == PassArgumentsScreen.routeName)  {
//           // Cast the arguments to the correct type: ScreenArguments.
//           final ScreenArguments args = settings.arguments;
//
//           // Then, extract the required data from the arguments and
//           // pass the data to the correct screen.
//           return MaterialPageRoute(
//             builder: (context) {
//               return PassArgumentsScreen(
//                 title: args.title,
//                 message: args.message,
//               );
//             },
//           );
//         }
//         // The code only supports PassArgumentsScreen.routeName right now.
//         // Other values need to be implemented if we add them. The assertion
//         // here will help remind us of that higher up in the call stack, since
//         // this assertion would otherwise fire somewhere in the framework.
//         assert(false, 'Need to implement ${settings.name}');
//         return null;
//       },
//       title: 'Navigation with Arguments',
//       home: HomeScreen(),
//
//
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreen createState() => new _HomeScreen();
// }
//
//
// class _HomeScreen extends State<HomeScreen> {
//
//   // variables for keeoing track of state
//   bool loading = false;
//   List mylatlong ;  // store lat long here
//   String currentAddress = 'Not found';  // for the address
//   bool pressGeoON = false;  // for keeping track of button state
//   bool cmbscritta = false;  // for keeping track of button state
// /////////////////////////////////////////////////////////////////////////////////////
//   // this sets up the map box api .//
//   // open map box account. Then go to your dashboard and copy the APIKey or Token
//   //Set up a test api key before running for maboxsearch package
//   String apiKey = "paste your Mapbox API key (Token ) here";
//   // Map-box geocoding requires the initialisation below
//   MapboxGeocoding geocoding = MapboxGeocoding("paste your Mapbox API key (Token ) here");     //////////////////////////////////////////////////////////////////////////////////////////
//   // set the information needed the lat long here
//   Future _getUserInfo() async {
//     setState(() {
//       loading = true;
//     });
//     // call loc here to initiate and get the lat long
//     // loc is defined down in the code : line 109
//     loc();
//     setState(() {
//       loading = false;
//     });
//
//   }
//
//   // function for succesful collecting the lat long
//   success(pos) async   {
//     List mypos;
//     try {
//       //print(pos.coords.latitude);
//       //print(pos.coords.longitude);
//       mypos = [pos.coords.latitude, pos.coords.longitude ];
//     } catch (ex) {
//       print("Exception thrown : " + ex.toString());
//       //user = await GetUserInfo.getInfo(kola);
//     }
//     // once the lat long is retrieved set the values and sassign to th my lat logn variable
//     setState(() {
//       mylatlong =   mypos;
//       print(mylatlong);
//     });
//   }
//
// // define future for getting the lat long
// // loc is called in getUserInfo (line 78) which is in turn called in initState
//   Future<void> loc()  async {
//     //check if web.
//     if (kIsWeb) {
//       // get the the lat long by calling success.  Note allowInterop
//       // which enables Returns a wrapper around a function f  that can be called from JavaScript using package:js
//       // cross check the definition of getCurrentPosition in locatioJS.dart (line 7)
//       getCurrentPosition(allowInterop((pos) => success(pos)));
//
//     }
//
//   }
//
// //Reverse geocoding package for getting city name. Get place/city name from latitude and longitude.
//   getCity(double lat, double lng) async {
//
//     try {
//       ReverseGeocoding reverseModel =
//       await geocoding.reverseModel(lat, lng, limit: 7, types: 'region'); //types can be region, district, neighborhood see https://docs.mapbox.com/api/search/#data-types
//       print(reverseModel.features[0].placeName);
//       return (reverseModel.features[0].placeName);
//     } catch (Excepetion) {
//       return 'Reverse Geocoding Error';
//     }
//   }
//
// // this future to get getAddressFromLatLng  to return the city name
//   Future<void> testkey() async {
//     await getAddressFromLatLng(apiKey).catchError(print);
//     //await placesSearch(apiKey).catchError(print);
//   }
//
// // the function icalls geocity and uses it to get city name/address
//   Future getAddressFromLatLng(String apiKey) async {
//
//     // *********** using map box search ********************************//
//     // this gives empty string sometimes
//     // initialise mapbox search api
//     var geoCodingService = ReverseGeoCoding(
//       apiKey: apiKey,
//       //country: "BR",
//       limit: 5,
//     );
//     // get the lat ling stores in the variable mylatlong (line 72) . My latlong is set by loc (line 119)
//     var lat = mylatlong[0];
//     var long = mylatlong[1];
//     // get the address
//     var addresses = await geoCodingService.getAddress(Location(
//       lat: lat, //-19.984846,
//       lng: long , //-43.946852,
//     ));
//     print(addresses); // print to view resulta
// // ***********map box searxh ends here ********************************//
//
// // *********** using map box geocoding ********************************//
// // this calls th geoCity function (line 133) and uses map  geocoding to retrieve
//     var newadr = await getCity(lat, long);
//     print('the mapbox geocoding api returns $newadr');
// // *********** using map box geocoding ********************************//
//
// // set the address to the value returned by mapbox geocoding
//     setState(() {
//       currentAddress = newadr ;
//     });
// /////////////////////////////////////////
//
//   }
//
//   @override
//   void initState() {
//
//     _getUserInfo();
//     super.initState();
//
//   }
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // A button that navigates to a named route that. The named route
//             // extracts the arguments by itself.
//             ElevatedButton(
//               child: Text("Go to Page 2"),
//               onPressed: () {
//                 testkey();
//                 // When the user taps the button, navigate to a named route
//                 // and provide the arguments as an optional parameter.
//                 Navigator.pushNamed(
//
//
//                   context,
//                   PassArgumentsScreen.routeName,
//                   arguments: ScreenArguments(
//                     'Welcome to page 2 ',
//                     'This was retrieved from lat long $mylatlong and your adress is $currentAddress',
//                   ),
//                 );
//                 //getAddressFromLatLng();
//
//               },
//             ),
//             // A button that navigates to a named route. For this route, extract
//             // the arguments in the onGenerateRoute function and pass them
//             // to the screen.
//             ElevatedButton(
//               child: cmbscritta ? Text("Geolocation is $mylatlong , address $currentAddress ") : Text("Display lat long"), //Text("Navigate to a named that accepts arguments"),
//               onPressed: () {
//                 // When the user taps the button, navigate to a named route
//                 // and provide the arguments as an optional parameter.
//                 testkey();
//                 setState(() {
//                   pressGeoON = !pressGeoON;
//                   cmbscritta = !cmbscritta;
//
//                   //getAddressFromLatLng();
//                 });
//
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class PassArgumentsScreen extends StatelessWidget {
//   static const routeName = '/passArguments';
//
//   final String title;
//   final String message;
//
//   // This Widget accepts the arguments as constructor parameters. It does not
//   // extract the arguments from the ModalRoute.
//   //
//   // The arguments are extracted by the onGenerateRoute function provided to the
//   // MaterialApp widget.
//   const PassArgumentsScreen({
//     Key key,
//     @required this.title,
//     @required this.message,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Center(
//         child: Text(message),
//       ),
//     );
//   }
// }
// // You can pass any object to the arguments parameter. In this example,
// // create a class that contains both a customizable title and message.
// class ScreenArguments {
//   final String title;
//   final String message;
//
//   ScreenArguments(this.title, this.message);
// }