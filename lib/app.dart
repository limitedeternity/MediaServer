import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:folder_picker/folder_picker.dart';
import 'package:get_ip/get_ip.dart';
import 'package:jaguar/jaguar.dart';
import './core/queryPermissions.dart';
import './core/filesInDirectory.dart';

class Application extends StatefulWidget {
  @override
  ApplicationState createState() => new ApplicationState();
}

class ApplicationState extends State<Application> {
  bool permissionsGranted = false;
  dynamic server;

  @override
  void initState() {
    super.initState();

    queryPermissions().then((void _) {
      this.setState(() {
        this.permissionsGranted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: new Center(
        child: this.permissionsGranted
            ? new Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    color: Theme.of(context).accentColor,
                    child: new Text(server != null ? "Stop" : "Start"),
                    onPressed: () async {
                      if (server != null) {
                        await server.close();
                        return setState(() {
                          server = null;
                        });
                      }

                      await Navigator.of(context).push<FolderPicker>(
                        new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new FolderPicker(
                              rootDirectory:
                                  new Directory("/storage/emulated/0/"),
                              action: (
                                BuildContext context,
                                Directory folder,
                              ) async {
                                final jr = new Jaguar(port: 8888);
                                jr.staticFiles("/content/*", "${folder.path}");

                                jr.get(
                                  "/",
                                  (Context ctx) async {
                                    return await rootBundle
                                        .loadString("assets/index.html");
                                  },
                                  mimeType: "text/html",
                                );

                                jr.getJson(
                                  "/listDir",
                                  (Context ctx) async {
                                    return await filesInDirectory(folder);
                                  },
                                );

                                await jr.serve();
                                return setState(() {
                                  server = jr;
                                });
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  if (server != null) new Container(height: 10.0),
                  if (server != null)
                    new FutureBuilder<String>(
                        key: new UniqueKey(),
                        future: GetIp.ipAddress,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<String> snapshot,
                        ) {
                          return new TextField(
                            enabled: false,
                            textAlign: TextAlign.center,
                            decoration: new InputDecoration.collapsed(
                              hintText:
                                  (snapshot.hasData && snapshot.data != null)
                                      ? "http://${snapshot.data}:8888/"
                                      : "http://...:8888/",
                              hintStyle: new TextStyle(color: Colors.grey),
                            ),
                          );
                        }),
                ],
              )
            : new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).accentColor,
                ),
              ),
      ),
    );
  }
}
