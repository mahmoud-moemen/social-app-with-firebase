import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';



class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit():super(RegisterInitialState());

  static RegisterCubit get(context)=>BlocProvider.of(context);


//////////////////////////////////////////////
  void userRegister({
  required String name,
  required String email,
  required String password,
  required String phone,
})
  {

    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword
      (email: email, password: password)
        .then((value)
    {
      print(value.user!.email);
      print(value.user!.uid);
      //////////////////call userCreate method here
      userCreate(
        uId: value.user!.uid,
        name:name ,
        email:email ,
        phone:phone,
      );
      //emit(RegisterSuccessState());

    }).catchError((error)
    {
      emit(RegisterErrorState(error.toString()));
    });
  }

  ////////////////////////////////////////////
void userCreate({
  required String name,
  required String email,
  required String phone,
  required String uId,
})
{
  UserModel model =UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'write your bio ..',
      image: 'https://img.freepik.com/premium-photo/portrait-male-profile-silhouette-with-big-question-mark-head-indoor-studio-shot-isolated-yellow-background_416530-28011.jpg?w=740',
      cover: 'https://img.freepik.com/premium-photo/portrait-male-profile-silhouette-with-big-question-mark-head-indoor-studio-shot-isolated-yellow-background_416530-28011.jpg?w=740',
      isEmailVerified: false
  );
  FirebaseFirestore.instance.collection('users').
  doc(uId).set(model.toMap())
      .then((value)
  {

    emit(CreateUserSuccessState());
  })
      .catchError((error)
  {
    emit(CreateUserErrorState(error.toString()));
  });
}

//////////////////////////////////////////////////////////


  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  void changePasswordVisibility()
  {
    isPassword= !isPassword;
    suffix = isPassword?Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }
}