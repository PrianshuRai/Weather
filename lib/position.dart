/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class MyClass extends StatelessWidget {
  const MyClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "23",
                style: GoogleFonts.getFont('Lato',
                    textStyle: Theme.of(context).textTheme.headline1,
                    color: Colors.white.withOpacity(.7),
                    fontWeight: FontWeight.w800),
                children: [
                  TextSpan(
                    text: '\u00B0',
                    style: GoogleFonts.getFont('Lato',
                        textStyle:
                        Theme.of(context).textTheme.headline1,
                        color: Colors.white.withOpacity(.7),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 4
                      // fontSize: 30,
                    ),
                  ),
                  query["units"] == 'metric'
                      ? TextSpan(
                    text: 'C',
                    style: GoogleFonts.getFont(
                      'Lato',
                      textStyle:
                      Theme.of(context).textTheme.headline1,
                      color: Colors.white.withOpacity(.7),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                      : query["units"] == "imperial"
                      ? TextSpan(
                    text: "F",
                    style: GoogleFonts.getFont(
                      'Lato',
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline1,
                      color: Colors.white.withOpacity(.7),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                      : TextSpan(
                    text: "K",
                    style: GoogleFonts.getFont(
                      'Lato',
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline1,
                      color: Colors.white.withOpacity(.7),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  // currentLocation.position(context);
                  currentLocation.getCoordinates(context);
                },
                child: Text('get position')),
            Spacer(
              flex: 1,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              height: 350,
              width: MediaQuery.of(context).size.width * .93,
              color: Colors.transparent,
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.black26.withOpacity(0.5),
                            Colors.black26.withOpacity(0.5)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Text("MISSING")
                    // TODO: build stream for new data
                    // ListView.builder(
                    //   itemBuilder: (BuildContext context, int index) {
                    //     String key = userDetails.keys.elementAt(index);
                    //     return Card(
                    //       child: ListTile(
                    //         title: Text('$key'),
                    //         subtitle: Text(userDetails[key]),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ),
                ),
              ),
            ),
          ],
        );
    );
  }
}*/
/*
import 'dart:convert';

import 'package:fluter_login_provider/data.dart';
import 'package:fluter_login_provider/datamodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider<Data>(create: (_) => Data())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data = Provider.of<Data>(context, listen: false);
    data.fetchData(context);
  }

  @override
  Widget build(BuildContext context) {

    final data = Provider.of<Data>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Provider Network Call"),
      ),
      body: Center(child: Container(child: Text(data.dataModel.title))),
    );
  }
}

Future<DataModel> getData(context) async {
  late DataModel dataModel;

  try {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      dataModel = DataModel.fromJson(data);
    }else{
      print("Something went wrong");
    }
  } catch (e) {
    print(e.toString());
  }

  return dataModel;
}

 */