
import 'package:flutter/material.dart';



class LastScreen extends StatefulWidget {
  @override
  LastScreenState createState() => LastScreenState();
}

class LastScreenState extends State<LastScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Center(child: Text("Coffeebeans"))
      ),
      body: Center(
          child:Center(
            child: Text("congratulations your attendance has been submitted, See you tomorrow",style: TextStyle(
                fontSize: 35,
                color: Colors.green,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                letterSpacing: 8,
                wordSpacing: 20,

            ),
      ),
          )
      ),
    );
  }

}