import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:login/db/operation.dart';
import 'package:login/src/models/model.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String _date;
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController bornDateController = new TextEditingController();
  TextEditingController addressNameController = new TextEditingController();

  static List<String> addressList = [null];

  @override
  void initState() {
    addressNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    addressNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Model users = ModalRoute.of(context).settings.arguments;
    _init(users);
    return WillPopScope(
      onWillPop: () async => _willPopScopeAction(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Please fill out the form'),
          ),
          body: Container(
            child: formUI(users),
          )),
    );
  }

  _init(Model users) {
    firstNameController.text = users.firstName;
    lastNameController.text = users.lastName;
    bornDateController.text = users.bornDate;
    addressNameController.text = users.address;
  }

  Widget formUI(Model users) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _firstNameText(),
              _lastNameText(),
              _bornDate(),
              ..._getAddress(),
              _submit()
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstNameText() {
    Model users = ModalRoute.of(context).settings.arguments;
    _init(users);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: firstNameController,
        decoration: InputDecoration(
            icon: Icon(Icons.account_circle_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: 'First name'),
        validator: (v) {
          String pattern = r'(^[a-zA-Z ]*$)';
          RegExp regExp = new RegExp(pattern);
          if (v.trim().isEmpty)
            return 'First name is required';
          else if (!regExp.hasMatch(v)) return "First name have a-z & A-Z";

          return null;
        },
      ),
    );
  }

  Widget _lastNameText() {
    Model users = ModalRoute.of(context).settings.arguments;
    _init(users);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: lastNameController,
        decoration: InputDecoration(
            icon: Icon(Icons.account_circle_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: 'Last name'),
        validator: (v) {
          String pattern = r'(^[a-zA-Z ]*$)';
          RegExp regExp = new RegExp(pattern);
          if (v.trim().isEmpty)
            return 'Last name is required';
          else if (!regExp.hasMatch(v)) return "last name have a-z & A-Z";

          return null;
        },
      ),
    );
  }

  Widget _bornDate() {
    Model users = ModalRoute.of(context).settings.arguments;
    _init(users);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: bornDateController,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: 'Born date',
            icon: Icon(Icons.calendar_today)),
        validator: (v) {
          if (v.trim().isEmpty) return 'Born date is required';
          return null;
        },
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
      ),
    );
  }

  Widget _submit() {
    Model users = ModalRoute.of(context).settings.arguments;
    _init(users);

    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  //update data form

                  if (users.id != null) {
                    _alert(context);

                    users.firstName = firstNameController.text;
                    users.lastName = lastNameController.text;
                    users.bornDate = bornDateController.text;
                    users.address = addressList.join("\n");
                    Operation.update(users);
                  } else {
                    //create data form
                    _alert(context);
                    Operation.insert(Model(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        bornDate: bornDateController.text,
                        address: addressList.join("\n")));
                    _formKey.currentState.reset();
                  }
                }
              },
              child: Text('Submit')),
        ));
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1960),
        lastDate: DateTime(2030));

    if (picked != null) {
      setState(() {

        //defining the structure of calendar data
        _date = DateFormat('yyyy-MM-dd').format(picked);
        bornDateController.text = _date;
      });
    }
  }

  void _alert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('SUCCESS!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Data has been saved correctly'),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.center,
                    child: (Image(
                        width: 100,
                        height: 100,
                        image: AssetImage(
                          'assets/alertIcon.png',
                        )))),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          );
        });
  }

  List<Widget> _getAddress() {
    List<Widget> addressTextFieldList = [];
    for (int i = 0; i < addressList.length; i++) {
      addressTextFieldList.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: AddressTextField(i),
            ),
            SizedBox(width: 4),
            _addRemoveButton(i == addressList.length - 1, i)
          ],
        ),
      ));
    }
    return addressTextFieldList;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        //add textformfield
        if (add) {
          addressList.insert(0, null);
          setState(() {});
        } 
        // delete textformfield
        else {
          addressList.removeAt(index);
          setState(() {});
        }
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: (add) ? Colors.green : Colors.red),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white),
      ),
    );
  }

  //alert window
  Future<bool>_willPopScopeAction() {
    return showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('Do you wanna cancel this opcion?'),
              actions: [
                CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes')),
                CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'))
              ],
            ));
  }
}

class AddressTextField extends StatefulWidget {
  final int index;

  const AddressTextField(this.index);

  @override
  _AddressTextFieldState createState() => _AddressTextFieldState();
}

class _AddressTextFieldState extends State<AddressTextField> {
  TextEditingController addressNameController;

  @override
  void initState() {
    super.initState();
    addressNameController = TextEditingController();
  }

  @override
  void dispose() {
    addressNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
        addressNameController.text =
            _MyFormState.addressList[widget.index] ?? '');

    return TextFormField(
        controller: addressNameController,
        onChanged: (v) => _MyFormState.addressList[widget.index] = v,
        decoration: InputDecoration(
            icon: Icon(Icons.location_pin),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: 'Address'),
        validator: (v) {
          if (v.trim().isEmpty) return 'Address is required';
          return null;
        });
  }
}
