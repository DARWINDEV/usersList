import 'package:flutter/material.dart';

import 'package:login/src/pages/form.dart';
import 'package:login/src/pages/userList.dart';

Map<String, WidgetBuilder> getApplicationsRoutes(){
  return <String, WidgetBuilder>{
  '/': (BuildContext context) => UserListPage(),
  'form': (BuildContext context) => MyForm()
};

}

