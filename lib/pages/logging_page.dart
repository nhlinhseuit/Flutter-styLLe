import 'package:flutter/material.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/collections/logging.dart';

import '../utilities/popup_confirm_dialog.dart';

class LoggingPage extends StatefulWidget {
  const LoggingPage({super.key});

  @override
  State<LoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {
  int reload = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logging page'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () async {
              final confirmLogout = await showLogOutDialog(context,
                  content: 'Logging out?', title: 'Log out');

              if (confirmLogout) {
                await AuthService.firebase().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              }
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black.withAlpha(100),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () async { 
            setState(() {
              reload++;
            });
          },
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
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
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
                                        'uid: ${logging[index].uid}',
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
                                        'email: ${logging[index].email}',
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
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
                                        'firstName: ${logging[index].firstName}',
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
                                        'lastName: ${logging[index].lastName}',
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
                                        'time: ${logging[index].time}',
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
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
                                        'action: ${loggingTypeToString(logging[index].type)}',
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
