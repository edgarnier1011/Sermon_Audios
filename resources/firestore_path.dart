//The paths to communicate to database
import 'package:sermons_audio/resources/auth_methods.dart';

class FirestorePath {
  static String userC() => 'Users';
  static String currUser() => 'Users/${AuthMethods().uid}';
  static String user(String id) => 'Users/$id';
  static String userNotifications(String id) => 'Users/$id/Notifications';
  static String userDevices(String id) => 'Users/$id/Devices';
  static String userDevicesspecific(String id, String deviceLocation) =>
      'Users/$id/Devices/$deviceLocation';
  static String notifications() => 'Notifications';

  static String authorsadd() => 'Authors';
  static String authorsgetdata(String id) => 'Authors/$id';
  static String authorsaddid(String id) => 'Authors/$id/Sermons';

  static String addText() => 'Texts';
  static String addTextpending() => 'TextsPending';
  static String getText(String textid) => 'Texts/$textid';
  static String getTextpending(String textid) => 'TextsPending/$textid';

  static String follows() => 'Follows';
  static String follow(String id) => "Follows/$id";

  static String audioadd() => 'Audios';
  static String audioaddPending() => 'AudiosPending';
  static String audioaddSample() => 'AudiosSamples';
  static String audioaddSamplegetdata(String id) => 'AudioSamples/$id';
  static String audioaddSamplePending() => 'AudiosSamplesPending';
  static String audiogetdata(String id) => 'Audios/$id';
  static String audiogetdataPending(String id) => 'AudiosPending/$id';

  static String gettextdata(String textid) => 'Texts/$textid';

  static String authorfollows() => 'Authorfollows';
  static String authorfollowsD(String id) => 'Authorfollows/$id';

  static String likes() => 'Likes';
  static String likesgetdata(String id) => 'Likes/$id';

  static String audiolikes() => 'AudioLikes';
  static String audiolikesgetdata(String id) => 'AudioLikes/$id';

  static String chatGroupDatas(String id) => '${user(id)}/ChatGroups';

  static String chatGroupData(String id, String groupId) =>
      '${user(id)}/ChatGroups/$groupId';
  static String chatGroup(String id) => 'ChatGroups/$id';
  static String chats() => 'Chats';
  static String chatGroups() => 'ChatGroups';

  static String textReports() => 'TextReports';

  static String audioReports() => 'AudioReports';

  static String userReports() => 'UserReports';

  static String userblocks() => 'UserBlocks';
  static String userblocksid(String id) => 'UserBlocks/$id';
  static String rejectedTexts() => 'RejectedTexts';
  static String rejectedAudios() => 'RejectedAudios';
}
