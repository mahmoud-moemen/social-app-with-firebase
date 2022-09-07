import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/social_layout/layoutCubit/layout_cubit.dart';
import 'package:social_app/social_layout/layoutCubit/layout_states.dart';

class FeedsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        return ConditionalBuilder(
         condition:LayoutCubit.get(context).posts.isNotEmpty&& LayoutCubit.get(context).userModel !=null ,
          builder: (context)=> SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children:
              [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5.0,
                  margin: EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children:
                    [
                      Image(
                        image:NetworkImage(
                            'https://img.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg?t=st=1657442435~exp=1657443035~hmac=69a622db8548915928e315a05e6fa87fdb5e77b03d02d7f33409c9dd6cb95d06&w=740'),
                        fit: BoxFit.cover,
                        height: 200.0,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'communicate with friends',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index)=>buildPostItem(LayoutCubit.get(context).posts[index],context,index),
                  separatorBuilder: (context,index)=>SizedBox(
                    height: 8.0,
                  ),
                  itemCount: LayoutCubit.get(context).posts.length,
                ),
                SizedBox(height: 8.0),

              ],
            ),
          ),
          fallback: (context)=>Center(child: CircularProgressIndicator()),
        );
      },

    );
  }

  Widget buildPostItem(PostModel model,context,index)=>Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: EdgeInsets.symmetric(horizontal: 8.0,),

    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Row(
            children:
            [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                    '${model.image}'
                ),
              ),
              SizedBox(width: 15.0,),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                            style: TextStyle(
                              height: 1.4,
                            ),
                          ),
                          SizedBox(width: 5.0,),
                          Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 18.0,
                          ),
                        ],
                      ),
                      Text(
                        '${model.dateTime}',
                        style: Theme.of(context).textTheme.caption!.
                        copyWith(
                          height: 1.4,
                        ),
                      ),

                    ],
                  )),
              SizedBox(width: 15.0,),
              IconButton(onPressed: ()
              {

              },
                icon: Icon(
                  Icons.more_horiz,
                  size: 18.0,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Text(
            '${model.text}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          //////////////tags///////////////
          // Padding(
          //   padding: const EdgeInsets.only(
          //     bottom: 10.0,
          //     top: 5.0,
          //   ),
          //   child: Container(
          //     width: double.infinity,
          //     child: Wrap(
          //
          //       children:
          //       [
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(end: 6.0),
          //           child: Container(
          //             height: 25.0,
          //             child: MaterialButton(
          //                 minWidth: 1.0,
          //                 padding: EdgeInsets.all(0.0),
          //
          //                 onPressed: (){},
          //                 child:Text(
          //                   '#software',
          //                   style: Theme.of(context).textTheme.caption!
          //                       .copyWith(color: defaultColor),
          //                 ) ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(end: 6.0),
          //           child: Container(
          //             height: 25.0,
          //             child: MaterialButton(
          //                 minWidth: 1.0,
          //                 padding: EdgeInsets.all(0.0),
          //
          //                 onPressed: (){},
          //                 child:Text(
          //                   '#flutter',
          //                   style: Theme.of(context).textTheme.caption!
          //                       .copyWith(color: defaultColor),
          //                 ) ),
          //           ),
          //         ),
          //
          //       ],
          //     ),
          //   ),
          // ),
          ///////////image/////////
          if (model.postImage != '' )
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 15.0),
              child: Container(
                height: 140.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  image: DecorationImage(
                    image:NetworkImage(
                        '${model.postImage}'),
                    fit: BoxFit.cover,

                  ),
                ),
              ),
            ),
          ////////comments&likes///////////
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: Row(
              children:
              [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: Row(
                        children:
                        [
                          Icon(
                            IconBroken.Heart,
                            size: 16.0,
                            color: Colors.red,
                          ),
                          SizedBox(width: 5.0,),
                          Text(
                            '${LayoutCubit.get(context).likes[index]}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:
                        [
                          Icon(
                            IconBroken.Chat,
                            size: 16.0,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 5.0,),
                          Text(
                            '0 comment',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
              ],
            ),
          ),
          ////////////divider/////////////
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children:
            [
              Expanded(
                child: InkWell(
                  child: Row(
                    children:
                    [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage('${LayoutCubit.get(context).userModel!.image}'),
                      ),
                      SizedBox(width: 15.0,),
                      Text(
                        'write a comment ...',
                        style: Theme.of(context).textTheme.caption!.
                        copyWith(

                        ),
                      ),
                    ],
                  ),
                  onTap: (){},
                ),
              ),
              InkWell(
                child: Row(
                  children:
                  [
                    Icon(
                      IconBroken.Heart,
                      size: 16.0,
                      color: Colors.red,
                    ),
                    SizedBox(width: 5.0,),
                    Text(
                      'Like',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                onTap: ()
                {
                  LayoutCubit.get(context).likePost(LayoutCubit.get(context).postsId[index]);
                },
              ),

            ],
          ),


        ],
      ),
    ),
  );
}
