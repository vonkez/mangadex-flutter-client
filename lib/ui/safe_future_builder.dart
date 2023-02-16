import 'package:flutter/material.dart';

class SafeFutureBuilder<T> extends StatelessWidget {
  SafeFutureBuilder({Key? key, required this.builder, required this.future}) : super(key: key);
  Future<T> future;
  Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot);
        }
        else if(snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ERROR!?!', style: TextStyle(color: Colors.red, fontSize: 28, fontWeight: FontWeight.bold),),
                  Text(snapshot.error.toString())
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}