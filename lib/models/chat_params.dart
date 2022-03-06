
class ChatParams{
  final String userUid;
  final String peerId;
  ChatParams(this.userUid, this.peerId);

  String getChatGroupId() {
    if (userUid.hashCode <= peerId.hashCode) {
      return '$userUid-$peerId';
    } else {
      return '$peerId-$userUid';
    }
  }

}
