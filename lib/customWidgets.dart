import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'getData.dart';


class NewContainer extends StatelessWidget {
  String text;
  double ht;
  double wd;
  TextStyle? textType;
  FontWeight? fontweight;
  double? paddng;
  Color? colors;

  NewContainer(this.text, this.ht, this.wd,
      {this.textType,
      this.fontweight = FontWeight.w400,
      this.paddng = 10,
      this.colors = Colors.black26});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: paddng!),
      height: ht,
      width: MediaQuery.of(context).size.width * wd,
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
                    colors!.withOpacity(0.5),
                    colors!.withOpacity(0.5)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                text,
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  color: Colors.white.withOpacity(.7),
                  fontWeight: FontWeight.w400,
                ),
              )),
        ),
      ),
    );
  }
}

class SwitchTile extends StatefulWidget {
  final bool switchValue;
  final ValueChanged valueChanged;

  const SwitchTile({required this.switchValue, required this.valueChanged});

  @override
  State<SwitchTile> createState() => _SwitchTileState();
}

class _SwitchTileState extends State<SwitchTile> {
  late bool _celcius;

  @override
  void initState() {
    _celcius = widget.switchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SwitchListTile(
        title: Text(
          'Metrics',
          style: GoogleFonts.lato(
            color: Colors.white70,
            fontSize: 24,
            textStyle: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        secondary: const Icon(
          Icons.thermostat_rounded,
          color: Colors.white60,
          size: 26,
        ),
        subtitle: Text(
          'Turn off for values in Fahrenheit',
          style: GoogleFonts.lato(
            color: Colors.white54,
            fontSize: 12,
            textStyle: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        value: _celcius,
        onChanged: (value) {
          _celcius = value;
          widget.valueChanged(value);
          if (_celcius) {
            setState(() {
              query['units'] = "metric";
            });
            print(query);
          } else {
            setState(() {
              query['units'] = "imperial";
            });
            print(query);
          }
        },
      ),
    );
  }
}

class BlurContainer extends StatefulWidget {
  final Widget myParam;

  const BlurContainer({Key? key, required this.myParam}) : super(key: key);

  @override
  State<BlurContainer> createState() => _BlurContainerState();
}

class _BlurContainerState extends State<BlurContainer> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.black26.withOpacity(0.6),
                  Colors.black26.withOpacity(0.6)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: widget.myParam),
      ),
    );
  }
}

// List view widget here
class WeatherList extends StatelessWidget {
  final String header;
  final String values;
  final IconData icons;

  const WeatherList(
      {Key? key,
      required this.icons,
      required this.header,
      required this.values})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      height: 100,
      child: BlurContainer(
        myParam: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icons,
                    color: Colors.white.withOpacity(.8),
                    size: 28,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    header,
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline5,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 10,color: Colors.white,thickness: 5,),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                values[0].toUpperCase()+values.substring(1).toLowerCase(),
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.headline5,
                  color: Colors.white.withOpacity(.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
