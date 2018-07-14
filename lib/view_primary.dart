import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'loading_screen.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'animated_logo.dart';
import 'color_override.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_country_picker/flutter_country_picker.dart';

class ViewPrimaryPage extends StatefulWidget {
  final String currentUserId;
  final FirebaseStorage storage;
  ViewPrimaryPage({Key key, this.currentUserId, this.storage}): super(key: key);

  @override
  ViewPrimaryPageState createState() => ViewPrimaryPageState();
}

class ViewPrimaryPageState extends State<ViewPrimaryPage>  with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String imagePath;
  File _image;
  final _userName = GlobalKey(debugLabel: 'Username');
  final _userStatus = GlobalKey(debugLabel: 'User Status');
  final _firstName = GlobalKey(debugLabel: 'First Name');
  final _lastName = GlobalKey(debugLabel: 'Last Name');
  final _email1 = GlobalKey(debugLabel: 'Email1');
  final _email2 = GlobalKey(debugLabel: 'Email2');
  final _sex = GlobalKey(debugLabel: 'Sex');
  final _country = GlobalKey(debugLabel: 'Country');
  final _mainPhone = GlobalKey(debugLabel: 'Main Phone');
  final _phone1 = GlobalKey(debugLabel: 'Phone1');
  final _phone2 = GlobalKey(debugLabel: 'Phone2');
  final _passportNo = GlobalKey(debugLabel: 'Passport No');
  final _tin = GlobalKey(debugLabel: 'TIN');
  final _cvStatusElec = GlobalKey(debugLabel: 'CV Status Electronic');
  final _nationalID = GlobalKey(debugLabel: 'National ID');
  final _role = GlobalKey(debugLabel: 'Role');
  final _dob = GlobalKey(debugLabel: 'Date Of Birth');
  final _padding = EdgeInsets.all(5.0);
  int _colorIndex = 0;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _email1Controller = TextEditingController();
  final _email2Controller = TextEditingController();
  final _sexController = TextEditingController();
  final _countryController = TextEditingController();
  final _mainPhoneController = TextEditingController();
  final _phone1Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _passportNoController = TextEditingController();
  final _bankAcctNoController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _insuranceNoController = TextEditingController();
  final _insuranceCpyController = TextEditingController();
  final _tinController = TextEditingController();
  final _cvStatusElecController = TextEditingController();
  final _dobController = TextEditingController();
  final _nationalIDController = TextEditingController();
  static String firstName = "";
  static String lastName = "";
  static String email1 = "";
  static String email2 = "";
  static String sex ="";
  static String country = "";
  static String mainPhone = "";
  static String phone1 = "";
  static String phone2 = "";
  static String passportNo = "";
//  static String bankAcctNo = "";
//  static String bankName = "";
  static String insurance = "";
  static String insuranceNo = "";
  static String insuranceCpy = "";
  static String tin = "";
  static String cvStatusElec = "";
  static String dob = "";
  static String nationalID = "";
  static String emergencyContactName = "";
  static String emergencyContactPhone = "";
  List<bool> changed = [false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false];
  static final formKey = new GlobalKey<FormState>();
  List<String> locations = ["Locations", "Gasabo", "Remera", "Kisimenti", "Gaculiro", "Kacyiru"];
  String profile_photo = "Change Your Profile Photo";
  bool showLoadingAnimation = false;
  String imageUrlStr = '';
  Country _selected;
  DateTime picked;
  List<String> sex_options = ['Sex', 'Male', 'Female'];
  List<DropdownMenuItem> _sexMenuItems;
  String _sexValue;

  Future getImage(String src) async {
    var image = await ImagePicker.pickImage(source: src == 'Camera' ? ImageSource.camera : ImageSource.gallery);
    
    setState(() {
      _image = image;
    });
  }

  // Method for uploading image
  Future _uploadImage(File image) async {

    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    // fetch file name
    String fileName = p.basename(image.path);
    print('image base file name: ${fileName}');
    String lastImageName = getLastToken(user.photoUrl);

        if(lastImageName.isNotEmpty) {
//          print('MMMMMMMMMMM => => => $lastImageName');
          FirebaseStorage.instance.ref().child(
              "users_photos/$lastImageName").delete();
        }


    final StorageReference ref = FirebaseStorage.instance.ref().child(
        "users_photos/$fileName");

    final StorageUploadTask uploadTask = ref.putFile(image, StorageMetadata(contentLanguage: "en"));
    print('STEP 1 Done - ${new DateTime.now()} ');

    print("=> => => ${user.providerData.first.photoUrl}");

    final Uri downloadUrl = (await uploadTask.future).downloadUrl;
    print('STEP 2 Done - ${new DateTime.now()} ');

    print('Download url received: $downloadUrl');
    UserUpdateInfo userInfo = new UserUpdateInfo();
    userInfo.photoUrl='$downloadUrl';
    userInfo.displayName='';
    _auth.updateProfile(userInfo);
    setState(() {
      this.showLoadingAnimation = false;
      print("Loading animation ended");
    });
  }


  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    }
    return false;
  }

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();

    _createDropdownMenuItems(6, sex_options);

    setDefaults();
  }
  void setDefaults()async {
      FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseUser user = await _auth.currentUser();
      imageUrlStr = user.photoUrl;

      _setSexDefaults();
  }

  /// Creates fresh list of [DropdownMenuItem] widgets, given a list of [Unit]s.
  void _createDropdownMenuItems(int idx, List<String> list) {
    var newItems = <DropdownMenuItem>[];
    for (var unit in list) {
      newItems.add(DropdownMenuItem(
        value: unit,
        child: Container(
          child: Text(
            unit,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
     if (idx == 6){
        _sexMenuItems = newItems;
      }
    });
  }

  void _setSexDefaults() {
    setState(() {
      _sexValue = sex_options[0];
    });
  }

  Widget _createDropdown(int idx, String currentValue, ValueChanged<dynamic>

  onChanged)

  {
    return Container(
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: TodoColors.baseColors[_colorIndex],
        border: Border.all(
          color: TodoColors.baseColors[_colorIndex],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: new SingleChildScrollView(
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 8.0,
              ),
              child: DropdownButtonHideUnderline(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      DropdownButton(
                        value: currentValue,
                        items: _sexMenuItems,
                        onChanged: onChanged,
                        style: TodoColors.textStyle2,
                      ),
                    ],)
              ),
            ),
          ),),),
    );
  }

  void _updateSexValue(dynamic name) {
    setState(() {
      _sexValue = name;
      if(name != 'Sex') {
        changed[6] = true;
      }
    });
  }

//  dispose() {
//    controller.dispose();
//    super.dispose();
//  }

  String getLastToken(String str){
      String last = p.basename(str);
      return last.substring(last.indexOf('users_photos%2F')+15, last.indexOf('.jpg')+4);
  }
  
  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    String editText = document['editing'] ? 'SAVE':'EDIT';
      return
        ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: <Widget>[

            SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                AnimatedLogo(animation: animation, message: 'Your Primary Details', factor: 1.0, colorIndex: _colorIndex,),
              ],
            ),
            Center(
      child: new Container(
      width: 70.0, height: 60.0,
      decoration: new BoxDecoration(
      image: new DecorationImage(
      image: _image == null ? Image.network(imageUrlStr).image: AssetImage(_image.path),
      fit: BoxFit.cover),
      borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
      boxShadow: <BoxShadow>[
      new BoxShadow(
      color: Colors.black26, blurRadius: 5.0, spreadRadius: 1.0),
      ],
      ),
      ),
    ),
            Form(
              key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:<Widget>[

                  SizedBox(height: 12.0),
                  document['editing'] ?
                  FlatButton (
                    child: Text (_image == null ? 'Update Your Profile Photo': 'Image Name:\n' + p.basename(_image.path),
                      style: TodoColors.textStyle.apply(color: Theme
                        .of(context)
                        .disabledColor),),
                    padding: EdgeInsets.all(20.0),
                    color: TodoColors.baseColors[_colorIndex],
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    onPressed: () {
                      new Container(
                        width: 450.0,
                      );

                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            content: new SingleChildScrollView(
                              child: new ListBody(
                              children:<Widget>[
                              FlatButton(
                                child: Text('CANCEL'),
                                textColor: TodoColors.baseColors[_colorIndex],
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(7.0)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              RaisedButton(
                                child: Text('TAKE A NEW PHOTO'),
                                textColor: TodoColors.baseColors[_colorIndex],
                                elevation: 8.0,
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(7.0)),
                                ),
                                onPressed: () {getImage('Camera'); Navigator.of(context).pop();},
                              ),
                              SizedBox(height: 12.0),
                              RaisedButton(
                                child: Text('PICK FROM GALLERY'),
                                textColor: TodoColors.baseColors[_colorIndex],
                                elevation: 8.0,
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(7.0)),
                                ),
                                onPressed: () {getImage('Gallery'); Navigator.of(context).pop();},
                              ),
                              SizedBox(height: 12.0),
                            ],
                          ),
                            ),
                          );
                        },
                      );
                    },
                  ): Container(),

            SizedBox(height: 12.0),
            ListTile(
              title: Container(
                child: InputDecorator(
                  key: _userName,
                  child: Text(
                    document['userName'],
                    style: TodoColors.textStyle3.apply(
                        color: TodoColors.baseColors[_colorIndex]),
                  ),
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    labelStyle: TodoColors.textStyle2,
                    border: CutCornersBorder(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.0),
            ListTile(
              title: Container(
                child: InputDecorator(
                  key: _role,
                  child: Text(
                    document['userRole'],
                    style: TodoColors.textStyle3.apply(
                        color: TodoColors.baseColors[_colorIndex]),
                  ),
                  decoration: InputDecoration(
                    labelText: 'User Role',
                    labelStyle: TodoColors.textStyle2,
                    border: CutCornersBorder(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.0),
            ListTile(
              title: Container(
                child: InputDecorator(
                  key: _userStatus,
                  child: Text(
                    document['userStatus'],
                    style: TodoColors.textStyle3.apply(
                        color: TodoColors.baseColors[_colorIndex]),
                  ),
                  decoration: InputDecoration(
                    labelText: 'User Status',
                    labelStyle: TodoColors.textStyle2,
                    border: CutCornersBorder(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'firstName', 'First Name', _firstName, _firstNameController, 0),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'lastName', 'Last Name', _lastName, _lastNameController, 1),

            SizedBox(height: 12.0),
                  document['editing'] ?
    new IconButton(
    icon: const Icon(Icons.calendar_today),
    onPressed: () {
    mselectDate(context);
    changed[2] = true;
    },
    tooltip: 'Calendar',
    )
            :ListTile(
              title: Container(
                child: InputDecorator(
                  key: _dob,
                  child: Text(
                    document['dob'],
                    style: TodoColors.textStyle3.apply(
                        color: TodoColors.baseColors[_colorIndex]),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Date Of Birth',
                    labelStyle: TodoColors.textStyle2,
                    border: CutCornersBorder(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.0),
            document['editing'] ?
            ListTile(
                title: Container(
                  child: CountryPicker(
                    onChanged: (Country country) {
                      setState(() {
                        _selected = country;
                        changed[3] = true;
                      });
                    },
                    selectedCountry: _selected,
                  ),
                )
            )
            : ListTile(
              title: Container(
                  child: InputDecorator(
                  key: _country,
                  child: Text(
                    document['country'],
                    style: TodoColors.textStyle3.apply(
                        color: TodoColors.baseColors[_colorIndex]),

                  ),
                  decoration: InputDecoration(
                    labelText: 'Country',
                    labelStyle: TodoColors.textStyle2,
                    border: CutCornersBorder(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'nationalID', 'National ID', _nationalID, _nationalIDController, 4),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'passportNo', 'Passport Number', _passportNo, _passportNoController, 5),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'mainPhone', 'Main Phone', _mainPhone, _mainPhoneController, 7),

            SizedBox(height: 12.0),
            document['editing'] ?
            _createDropdown(6, _sexValue, _updateSexValue)
            :ListTile(
              title: Container(child:
              InputDecorator(
                key: _sex,
                child: Text(
                document['sex'],
                  style: TodoColors.textStyle3.apply(
                      color: TodoColors.baseColors[_colorIndex]),
                ),
                decoration: InputDecoration(
                  labelText: 'Sex',
                  labelStyle: TodoColors.textStyle2,
                  border: CutCornersBorder(),
                ),
              ),
    ),
            ),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'phone1', 'Alt Phone 1', _phone1, _phone1Controller, 8),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'phone2', 'Alt Phone 2', _phone2, _phone2Controller, 9),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'email1', 'Email 1', _email1, _email1Controller, 10),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'email2', 'Email 2', _email2, _email2Controller, 11),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'tin', 'TIN', _tin, _tinController, 17),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'cvStatusElec', 'CV Status Electronic', _cvStatusElec, _cvStatusElecController, 18),

    ButtonBar(
    children: <Widget>[
    FlatButton(
    child: Text('CANCEL',),
    shape: BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7.0)),
    ),
    onPressed: () {
      setState(() {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction. get (
              document.reference);
          await transaction.update(
              snapshot.reference, {
            'editing': false,
          });
        });
      });
      showInSnackBar("Leaving Edit Mode ...", TodoColors.baseColors[_colorIndex]);
      Navigator.of(context).pop();
    },
    ),
    RaisedButton(
    child:
    Text(editText
      , style: TextStyle(color: TodoColors.baseColors[0]),),
    elevation: 8.0,
    shape: BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7.0)),
    ),
    onPressed: ()  {

        setState(() {
          if(editText == 'SAVE') {
            showInSnackBar("Saving Changes ...", TodoColors.baseColors[_colorIndex]);

        bool valid = validateAndSave();

            firstName = changed[0] ? _firstNameController.text : document['firstName'];
            lastName = changed[1] ? _lastNameController.text : document['lastName'];
            dob = changed[2] ? picked.toIso8601String().split('T')[0] : document['dob'];
            country = changed[3] ? _selected.name : document['country'];
            nationalID = changed[4] ? _nationalIDController.text : document['nationalID'];
            passportNo = changed[5] ? _passportNoController.text : document['passportNo'];
            sex = changed[6] ? _sexValue : document['sex'];
            mainPhone = changed[7] ? _mainPhoneController.text : document['mainPhone'];
            phone1 = changed[8] ? _phone1Controller.text : document['phone1'];
            phone2 = changed[9] ? _phone2Controller.text : document['phone2'];
            email1 = changed[10] ? _email1Controller.text : document['email1'];
            email2 = changed[11] ? _email2Controller.text : document['email2'];
            insurance = changed[14] ? _insuranceController.text : document['insurance'];
            insuranceNo = changed[15] ? _insuranceNoController.text : document['insuranceNo'];
            insuranceCpy = changed[16] ? _insuranceCpyController.text : document['insuranceCpy'];
            tin = changed[17] ? _tinController.text : document['tin'];
            cvStatusElec = changed[18] ? _cvStatusElecController.text : document['cvStatusElec'];


            Firestore.instance.runTransaction((transaction) async {
              DocumentSnapshot snapshot =
              await transaction.get(document.reference);

              await transaction.update(snapshot.reference, {
                'firstName': firstName,
                'lastName': lastName,
                'email1': email1,
                'email2': email2,
                'sex': sex,
                'country': country,
                'mainPhone': mainPhone,
                'phone1': phone1,
                'phone2': phone2,
                'passportNo': passportNo,
                'tin': tin,
                'cvStatusElec': cvStatusElec,
                'dob': dob,
                'nationalID': nationalID,
                'editing':!snapshot['editing'],
              });
            });
            _uploadImage(_image);
    }else {
    Firestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction. get (
    document.reference);
    await transaction.update(
    snapshot.reference, {
    'editing': !snapshot['editing']
    });
    });
    showInSnackBar("Entering Edit Mode ...", Colors.redAccent);
    }
    });
    }


    )
    ],
    ),],),),
    ],
    );
  }

  Future<Null> mselectDate(BuildContext context) async {
    picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1910, 1),
        lastDate: new DateTime(2101)
    );
  }

  void onTap(){

  }

  Widget _buildTile(BuildContext context, DocumentSnapshot document, String fieldName, String label, GlobalKey mkey,
      TextEditingController controller, int idx){
   changed[idx] = true;
    return ListTile(
      title: Container(
              child: !document['editing']
                  ? InputDecorator(
                key: mkey,
                child: Text(
                  document[fieldName],
                  style: TodoColors.textStyle3.apply(
                      color: TodoColors.baseColors[_colorIndex]),
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TodoColors.textStyle2,
                  border: CutCornersBorder(),
                ),
              ): PrimaryColorOverride(
                color: TodoColors.baseColors[_colorIndex],
                child: TextFormField(
                  key: mkey,
                  initialValue: document[fieldName],
                  onSaved: (text) {
                  controller.text = text;
                  },
                  onFieldSubmitted: (text) {
                    controller.text = text;
                  },
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: document[fieldName],
                    border: CutCornersBorder(),
                  ),
                ),
              ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final padding = Padding(padding: _padding);

    return new StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.document('users/${widget.currentUserId}').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData)
    {
      return new Center(
          child: new BarLoadingScreen(),
      );
    }else if (snapshot.data != null) {
//            DocumentSnapshot document = snapshot.data.documents.where((doc){
//    return (doc['userName'] == widget.currentUserId) ? true : false;
//              }).first;

            final converter = _buildListItem(context, snapshot.data);

            return Padding(
              padding:
              _padding,
              child: OrientationBuilder(
                builder: (BuildContext
                context, Orientation orientation) {
                  if (orientation == Orientation.portrait) {
                    return
                       converter;
                  } else {
                    return Center(
                      child: Container(
                        width: 450.0,
                          child:converter,
                      ),
                    );
                  }
                }
                ,
              ),
            );
          }

        });
  }


  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}


