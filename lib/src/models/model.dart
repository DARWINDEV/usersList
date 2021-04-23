class Model{
   int id;
   String firstName;
   String lastName;
   String bornDate;
   String address;

  Model({this.id, this.firstName, this.lastName, this.bornDate, this.address});

  Model.empty();

  Map<String, dynamic> toMap(){
    return {'id': id, 'firstname' : firstName, 'lastname' : lastName, 'borndate' : bornDate, 'address' : address};
  }
}