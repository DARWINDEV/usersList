import 'package:flutter/material.dart';

import 'package:login/db/operation.dart';
import 'package:login/src/models/model.dart';

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User list'),
      ),
      body: UserList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.pushNamed(context, 'form', arguments: Model.empty()),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<Model> users = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (_, i) => _createItem(i),
    );
  }

  _loadData() async {
    List<Model> auxUser = await Operation.users();

    setState(() {
      users = auxUser;
    });
  }

  Widget _createItem(int i) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.only(left: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (direction) {
        print(direction);
        Operation.delete(users[i]);
      },
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, 'form', arguments: users[i]),
        child: Card(
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _styleRegister('Name: ', users[i].firstName),
                SizedBox(height: 5),
                _styleRegister('Last name: ', users[i].lastName),
                SizedBox(height: 5),
                _styleRegister('Born date: ', users[i].bornDate),
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Addresses Registedes:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(users[i].address)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _styleRegister(String text, dynamic data) {
    return Row(
      children: [
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(data)
      ],
    );
  }
}
