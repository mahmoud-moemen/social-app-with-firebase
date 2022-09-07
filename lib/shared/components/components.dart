

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
// my defaultFormField
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword=false,
  Function(String)? onSubmitted,
  Function(String)? onChanged,
  VoidCallback? onTap,

  //required String Function(String?) validate ,
  required String? Function(String? val)? validator,

  required String label,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable=true,
}) => TextFormField(
  controller:controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmitted,
  onChanged:onChanged,
  onTap:onTap ,
  enabled:isClickable ,
  validator:validator,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefix,), //icon in the start
    suffixIcon:suffix !=null ? IconButton(
      onPressed:suffixPressed ,
      icon : Icon(
        suffix,
      ),
    ):null, //icon in the start
    border: OutlineInputBorder(),
  ),
);



Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  double radias = 10.0,
  //required Function function,HOW to pass a function as a parameter مش شغاله اللي تحتها اللي شغاله
  required final VoidCallback callback,
  required String text,
}) {
  return Container(
    width: width,
    height: 40.0,
    child: MaterialButton(
      onPressed:callback,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radias),
      color: background,
    ),
  );
}


Widget defaultTextButton({
  required VoidCallback callback,
  required String text
})=>TextButton(onPressed: callback, child:Text(text.toUpperCase()) );

////////////////////////////
void navigateTo(context , Widget)=> Navigator.push(
  context,
  MaterialPageRoute(
    builder: (Context)=>Widget,
  ),
);
//////////////////////////////////////////////////////

void navigateAndFinish(context,Widget)=>Navigator.pushReplacement
  (context,
    MaterialPageRoute(builder: (context)=>Widget));


/////////////////////////////////////////////
void showToast({
  required String text,
  required toastStates state,
})=>Fluttertoast.showToast(
    msg:text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0);


enum toastStates {SUCCESS , ERROR , WARNING}

Color chooseToastColor(toastStates state)
{
  Color color;
  switch(state)
  {
    case toastStates.SUCCESS:
      color= Colors.green;
      break;

    case toastStates.ERROR:
      color= Colors.red;
      break;

    case toastStates.WARNING:
      color= Colors.amber;
      break;
  }
  return color;
}
//////////////////////////////////////////////////////////////////

PreferredSizeWidget? defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
})=> AppBar(
  leading: IconButton(onPressed: ()
  {
    Navigator.pop(context);
  }, icon: Icon(IconBroken.Arrow___Left_2)),
  titleSpacing: 5.0,
  title: Text(
      title!),
  actions: actions ,
);