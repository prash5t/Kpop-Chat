import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/data/repository/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  ChatCubit(this.chatRepo) : super(ChatLoadingState());
}
