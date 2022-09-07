
import 'dart:io';

import 'package:flutter/widgets.dart';

abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates{}

//////////////////get user states//////////////////////
class LayoutGetUserLoadingState extends LayoutStates{}
class LayoutGetUserSuccessState extends LayoutStates{}
class LayoutGetUserErrorState extends LayoutStates
{
  final String error;

  LayoutGetUserErrorState(this.error);
}
//////////////////////////////////////////////////
class LayoutGetAllUsersLoadingState extends LayoutStates{}
class LayoutGetAllUsersSuccessState extends LayoutStates{}
class LayoutGetAllUsersErrorState extends LayoutStates
{
  final String error;

  LayoutGetAllUsersErrorState(this.error);
}
//////////////////////////////////////////////////////

class LayoutChangeBottomNavState extends LayoutStates{}

////////////////////////////////////////////
class LayoutNewPostState extends LayoutStates{}
///////////////////////////////////////
class LayoutProfileImagePickedSuccessState extends LayoutStates {}
class LayoutProfileImagePickedErrorState extends LayoutStates{}

class LayoutCoverImagePickedSuccessState extends LayoutStates{}
class LayoutCoverImagePickedErrorState extends LayoutStates{}



class LayoutUploadProfileImageSuccessState extends LayoutStates {}
class LayoutUploadProfileImageErrorState extends LayoutStates{}

class LayoutUploadCoverImageSuccessState extends LayoutStates {}
class LayoutUploadCoverImageErrorState extends LayoutStates{}

class LayoutUserUpdateLoadingState extends LayoutStates{}
class LayoutUserUpdateErrorState extends LayoutStates{}

//////////////////create post///////////////////////////////////
class LayoutCreatePostLoadingState extends LayoutStates{}
class LayoutCreatePostSuccessState extends LayoutStates{}
class LayoutCreatePostErrorState extends LayoutStates{}


class LayoutPostImagePickedSuccessState extends LayoutStates{}
class LayoutPostImagePickedErrorState extends LayoutStates{}

////////////////remove image state//////////////////////////
class LayoutRemovePostImageState extends LayoutStates{}

/////////////get posts////////////////////////
class LayoutGetPostsLoadingState extends LayoutStates{}
class LayoutGetPostsSuccessState extends LayoutStates{}
class LayoutGetPostsErrorState extends LayoutStates
{
  final String error;

  LayoutGetPostsErrorState(this.error);
}

/////////////////posts likes///////////////////////
class LayoutLikePostSuccessState extends LayoutStates{}
class LayoutLikePostErrorState extends LayoutStates
{
  final String error;

  LayoutLikePostErrorState(this.error);
}
/////////////////chat//////////////////////////////
class LayoutSendMessageSuccessState extends LayoutStates{}
class LayoutSendMessageErrorState extends LayoutStates{}
class LayoutGetMessagesSuccessState extends LayoutStates{}
