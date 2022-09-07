import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/layout_screens/chats/chats_screen.dart';
import 'package:social_app/modules/layout_screens/feeds/feeds_screen.dart';
import 'package:social_app/modules/layout_screens/settings/settings_screen.dart';
import 'package:social_app/modules/layout_screens/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/social_layout/layoutCubit/layout_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../models/user_model.dart';
import '../../modules/new_post/new_post_screen.dart';

class LayoutCubit extends Cubit<LayoutStates>
{
  LayoutCubit() :super(LayoutInitialState());

  static LayoutCubit get(context)=>BlocProvider.of(context);

   UserModel? userModel;

  void getUserData()
  {
    emit(LayoutGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get()
        .then((value)
    {
      print(value.data());
      userModel= UserModel.fromJson(value.data()!);
      emit(LayoutGetUserSuccessState());
    })
        .catchError((error)
    {
      print(error);
      emit(LayoutGetUserErrorState(error.toString()));
    });
  }


  /////////////////////
  // int currentIndex=0;
  List<String> titles=[
    'Home',
    'Chats',
    'post',
    'Users',
    'Settings',

  ];

  int currentIndex=0;
  List<Widget> screens=[
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  void changeBottomNav (int index)
  {
    if (index ==1)
      getUsers();
    if(index==2)
      emit(LayoutNewPostState());
    else
    {
      currentIndex=index;
      emit(LayoutChangeBottomNavState());
    }

  }
////////////////////////////

  /////////////image picker//////////////////

  File? profileImage;
  final ImagePicker picker = ImagePicker();

  Future<void> getProfileImage()async
  {
    //  profileImage = await _picker.pickImage(source: ImageSource.gallery) as file?;
    XFile? image = (await picker.pickImage(source: ImageSource.gallery)) ;
    if(image !=null)
    {
      profileImage = File(image.path);
      print(profileImage!.path);
      emit(LayoutProfileImagePickedSuccessState());
    }else
    {
      print('No image selected');
      emit(LayoutProfileImagePickedErrorState());
    }
  }
//////////////////////////////////////////////////////

  File? coverImage;

  Future<void> getCoverImage()async
  {
    //  profileImage = await _picker.pickImage(source: ImageSource.gallery) as file?;
    XFile? image = (await picker.pickImage(source: ImageSource.gallery)) ;
    if(image !=null)
    {
      coverImage = File(image.path);
      emit(LayoutCoverImagePickedSuccessState());
    }else
    {
      print('No image selected');
      emit(LayoutCoverImagePickedErrorState());
    }
  }
//////////////////////////////////////////////////////

  void uploadProfileImage({
  required String name,
  required String phone,
  required String bio,
  })
  {
    emit(LayoutUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {
       // emit(LayoutUploadProfileImageSuccessState());
        print(value);
        updateUser(
            name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      })
          .catchError((error)
      {
        emit(LayoutUploadProfileImageErrorState());
      });
    })
        .catchError((error)
    {
      emit(LayoutUploadProfileImageErrorState());
    });
  }
//////////////////////////////////////////////////////////


  void uploadcoverImage({
    required String name,
    required String phone,
    required String bio,
})
  {
    emit(LayoutUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {
        //emit(LayoutUploadCoverImageSuccessState());
        print(value);

        updateUser(
            name: name,
            phone: phone,
            bio: bio,
            cover: value
        );
      })
          .catchError((error)
      {
        emit(LayoutUploadCoverImageErrorState());
      });
    })
        .catchError((error)
    {
      emit(LayoutUploadCoverImageErrorState());
    });
  }


///////////////////////////////////////////////////////

// void updateUserImages({
//   required String name,
//   required String phone,
//   required String bio,
// })
// {
//   emit(LayoutUserUpdateLoadingState());
//   if(coverImage !=null)
//   {
//     uploadcoverImage();
//   }else if(profileImage != null)
//   {
//     uploadProfileImage();
//   }else if (coverImage !=null&&profileImage != null)
//   {
//
//   }
//   else
//   {
//     updateUser(
//       name: name,
//       phone: phone,
//       bio: bio
//     );
//   }
//
// }


void updateUser({
  required String name,
  required String phone,
  required String bio,
   String? cover,
   String? image,
})
{
  UserModel model =UserModel(
    name: name,
    phone: phone,
    bio: bio,
    //if there is no change in image and cover it will save the same data
    image:image?? userModel!.image,
    cover:cover?? userModel!.cover,
    email: userModel!.email,
    uId: userModel!.uId,
    isEmailVerified: false,

  );

  FirebaseFirestore.instance
      .collection('users')
      .doc(userModel!.uId)
      .update(model.toMap())
      .then((value)
  {
    getUserData();
  })
      .catchError((error)
  {
    emit(LayoutUserUpdateErrorState());
  });
}

//////////////////posts///////////////

  File? postImage;
  Future<void> getPostImage()async
  {
    //  profileImage = await _picker.pickImage(source: ImageSource.gallery) as file?;
    XFile? image = (await picker.pickImage(source: ImageSource.gallery)) ;
    if(image !=null)
    {
      postImage = File(image.path);
      emit(LayoutPostImagePickedSuccessState());
    }else
    {
      print('No image selected');
      emit(LayoutPostImagePickedErrorState());
    }
  }
///////////////////////////////////////////////////////////////////////////
  void removePostImage()
  {
    postImage = null;
    emit(LayoutRemovePostImageState());
  }

  void uploadPostImage({

    required String dateTime,
    required String text,

  })
  {
    emit(LayoutCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {

        print(value);
        createPost(dateTime: dateTime, text: text,postImage: value);

      })
          .catchError((error)
      {
        emit(LayoutCreatePostErrorState());
      });
    })
        .catchError((error)
    {
      emit(LayoutCreatePostErrorState());
    });
  }



  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  })
  {
    emit(LayoutCreatePostLoadingState());
    PostModel model =PostModel(
      name: userModel!.name,
      image:userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage:postImage??'',

    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value)
    {
      emit(LayoutCreatePostSuccessState());
    })
        .catchError((error)
    {
      emit(LayoutCreatePostErrorState());
    });
  }

/////////////////get list [posts]&list [postsId]&list [likes] ///////////////

  List<PostModel> posts= [];
  List<String> postsId= [];
  List<int> likes= [];
  void getPosts()
  {
    FirebaseFirestore.instance.collection('posts')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {

        element.reference
        .collection('likes')
        .get()
        .then((value)
        {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        })
        .catchError((error){});


        // postsId.add(element.id);
        // posts.add(PostModel.fromJson(element.data()));
      });
      emit(LayoutGetPostsSuccessState());
    })
        .catchError((error){
          emit(LayoutGetPostsErrorState(error.toString()));
    });
  }


  //////////////posts likes/////////////

  void likePost(String postId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like':true,
    })
        .then((value) 
    {
      emit(LayoutLikePostSuccessState());
    })
        .catchError((error)
    {
      emit(LayoutLikePostErrorState(error.toString()));
    });
  }

  /////////////////////////////////

  List<UserModel> users=[] ;

  void getUsers()
  {
    //users=[];
    // we need to initializa users list to empty list  to empty the list first every time
    //getUsers called then get the data and add it to users List
    // or(7al tani) =>  check users length if 0 then get users <=this is best solution
    // 34an da bygeb al data mara wa7da bs
    if (users.length ==0)

      FirebaseFirestore.instance.collection('users')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        if(element.data()['uId'] != userModel!.uId)
          users.add(UserModel.fromJson(element.data()));
      });
      emit(LayoutGetAllUsersSuccessState());
    })
        .catchError((error){
      emit(LayoutGetAllUsersErrorState(error.toString()));
    });
  }
//////////////////send chat message//////////////////////////////

  void sendMessage
    ({
    required String receiverId,
    required String dateTime,
    required String text,
   })
  {
    MessageModel model=MessageModel(
      text: text,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats
    FirebaseFirestore.instance.collection('users')
    .doc(userModel!.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(model.toMap())
    .then((value)
    {
      emit(LayoutSendMessageSuccessState());
    })
    .catchError((error)
    {
      emit(LayoutSendMessageErrorState());
    });


    // set receiver chats
    FirebaseFirestore.instance.collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value)
    {
      emit(LayoutSendMessageSuccessState());
    })
        .catchError((error)
    {
      emit(LayoutSendMessageErrorState());
    });
  }

  List<MessageModel> messages=[];

  void getMessages({
    required String receiverId,
})
  {

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
    .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages=[];
      event.docs.forEach((element)
      {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(LayoutGetMessagesSuccessState());
    });
  }

}

