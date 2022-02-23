import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AmbuDispatchFirebaseUser {
  AmbuDispatchFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

AmbuDispatchFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<AmbuDispatchFirebaseUser> ambuDispatchFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<AmbuDispatchFirebaseUser>(
            (user) => currentUser = AmbuDispatchFirebaseUser(user));
