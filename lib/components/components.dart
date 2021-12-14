import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:news_app/modules/web_view_screen/web_view_screen.dart';


Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required VoidCallback function,
  required String text,
}) => Container(
  height: 40.0,
  width: width,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style:TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
);


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String?)? onSubmit,
  Function(String?)? onChange,
  VoidCallback? onTap,
  required String? Function(String?)? validate,
  required String label,
  required IconData prefix,
  bool isPassword = false,
  bool isEnabled = true,
  IconData? suffix,
  VoidCallback? suffixPressed,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  onFieldSubmitted:onSubmit,
  onChanged: onChange,
  onTap: onTap,
  enabled: isEnabled,
  validator: validate,
  decoration: InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    prefixIcon: Icon(
        prefix,
      ),
    suffixIcon: suffix != null ? IconButton(
        onPressed: suffixPressed,
        icon : Icon(suffix),) : null,
  ),
  style: TextStyle(
    color: Colors.deepOrange,
    fontSize: 18.0,
  ),
  obscureText: isPassword,
);

Widget articleBuilder(list, context, {isSearch = false}) => Conditional.single(
  context: context,
  conditionBuilder:  list.length > 0,
  widgetBuilder: (context) =>
      ListView.separated(
        itemBuilder: (context, index) => buildArticleItem(list[index], context),
        separatorBuilder: (context, index) => const Padding(
          padding: const EdgeInsets.all(20.0),
          child: Divider(color: Colors.grey,),
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,),
  fallbackBuilder: (context) => isSearch ? Container() : const Center(child: CircularProgressIndicator()),

);

// myDivider()
// {
//   Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: Divider(color: Colors.grey,),
//   );
// }

Widget buildArticleItem(article, context) => InkWell(
  onTap: (){
    navigateTo(context, WebViewScreen(article['url']));
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Container(
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: NetworkImage('${article['urlToImage']}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${article['title']}' ,
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${article['publishedAt']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);

void navigateTo(context, screen) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => screen,
  ),
);
