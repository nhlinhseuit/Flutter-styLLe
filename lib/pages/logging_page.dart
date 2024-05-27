import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stylle/constants/colors.dart';
import 'package:stylle/services/collections/logging.dart';

class LoggingPage extends StatefulWidget {
  const LoggingPage({super.key});

  @override
  State<LoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logging page'),
        backgroundColor: const Color.fromARGB(255, 56, 159, 244),
      ),
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: FutureBuilder(
            future: Logging.loggingFuture(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var logging = snapshot.data;
                var numberOfLogger = logging!.length;

                return ListView.builder(
                    itemCount: numberOfLogger,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                          bottom: 8,
                          left: 10,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    'uid ${logging[index].uid}',
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    'email ${logging[index].email}',
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    'firstName ${logging[index].firstName}',
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    'lastName ${logging[index].lastName}',
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    'time ${logging[index].time}',
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
