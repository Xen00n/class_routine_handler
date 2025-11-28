import 'package:class_routine_handler/dataservice.dart';
import 'package:flutter/material.dart';

class ContentLoader extends StatefulWidget {
  final String subject;
  final DataService dataService = DataService();
  ContentLoader({super.key, required this.subject});
  @override
  State<ContentLoader> createState() => _ContentLoaderState();
}

class _ContentLoaderState extends State<ContentLoader> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.dataService.loadAllContents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final contents = snapshot.data![widget.subject]!;
          return ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(contents[index].title),
                  Text(contents[index].description),
                  Text(contents[index].filepath),
                  const Divider(),
                ],
              );
            },
            itemCount: contents.length,
          );
        } else {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
