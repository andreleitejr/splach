import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionStatus extends StatelessWidget {
  ConnectionStatus({
    super.key,
    required this.connected,
    required this.disconnected,
  });

  final Widget connected;
  final Widget disconnected;

  final _connectionChecker = InternetConnectionChecker();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InternetConnectionStatus>(
      future: _connectionChecker.connectionStatus,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return StreamBuilder<InternetConnectionStatus>(
          initialData: snapshot.data,
          stream: _connectionChecker.onStatusChange,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final con = snapshot.data == InternetConnectionStatus.connected;
            if (con) {
              return connected;
            } else {
              return disconnected;
            }
          },
        );
      },
    );
  }
}
