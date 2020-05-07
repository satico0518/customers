import 'dart:async';
import 'package:customers/src/providers/userDb.provider.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _userIdTypeController = BehaviorSubject<String>();
  final _userIdController = BehaviorSubject<String>();
  final _userNameController = BehaviorSubject<String>();
  final _userLastNameController = BehaviorSubject<String>();
  final _userContactController = BehaviorSubject<String>();
  final _userEmailController = BehaviorSubject<String>();

  Stream<String> get userIdTypeStream => _userIdTypeController.stream;
  Stream<String> get userIdStream => _userIdController.stream;
  Stream<String> get userNameStream => _userNameController.stream;
  Stream<String> get userLastNameStream => _userLastNameController.stream;
  Stream<String> get userContactStream => _userContactController.stream;
  Stream<String> get userEmailStream => _userEmailController.stream;
  Stream<bool> get formValidStream => Rx.combineLatest6(
      userIdTypeStream, userIdStream, userNameStream,
      userLastNameStream, userContactStream, userEmailStream,
      (userIdTypeStream, userIdStream, userNameStream, userLastNameStream,
              usercontactStream, userEmailStream) => true);

  Function(String) get changeUserIdType => _userIdTypeController.sink.add;
  Function(String) get changeUserId => _userIdController.sink.add;
  Function(String) get changeUserName => _userNameController.sink.add;
  Function(String) get changeUserLastName => _userLastNameController.sink.add;
  Function(String) get changeUserContact => _userContactController.sink.add;
  Function(String) get changeUserEmail => _userEmailController.sink.add;

  String get identificationType => _userIdTypeController.value;
  String get identification => _userIdController.value;
  String get name => _userNameController.value;
  String get lastName => _userLastNameController.value;
  String get contact => _userContactController.value;
  String get email => _userEmailController.value;

  UserBloc() {
    UserDBProvider.db.getUser().then((value) {
      if (value != null) {
        changeUserIdType(value.identificationType);
        changeUserId(value.identification);
        changeUserName(value.name);
        changeUserLastName(value.lastName);
        changeUserContact(value.contact);
        changeUserEmail(value.email);
      }
    });
  }

  dispose() {
    _userIdTypeController?.close();
    _userIdController?.close();
    _userNameController?.close();
    _userLastNameController?.close();
    _userContactController?.close();
    _userEmailController?.close();
  }
}
