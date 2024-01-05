import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/shared_artifact_reactions/shared_artifact_reaction_selection.dart';
import 'package:spiral_notebook/models/auth/current_user.dart';
import 'package:spiral_notebook/models/shared_artifacts_reactions/shared_artifacts_reaction.dart';
import 'package:spiral_notebook/models/shared_artifacts_reactions/shared_artifacts_reactions.dart';
import 'package:spiral_notebook/providers/current_user_provider.dart';
import 'package:spiral_notebook/providers/shared_artifact_reactions_available_provider.dart';
import 'package:spiral_notebook/providers/shared_artifacts_reactions_provider.dart';
import 'package:spiral_notebook/services/shared_artifacts_reactions_service.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';

final sharedArtifactSingleReactionsProvider = Provider.family<List<SharedArtifactsReaction>, String>((ref, sharedArtifactId) {

  final SharedArtifactsReactions reactions = ref.watch(sharedArtifactsReactionsProvider);
  final List<SharedArtifactsReaction> matchingReactions = reactions.reactions.where((comment) => comment.sharedArtifactId == sharedArtifactId).toList();

  return matchingReactions;
});

class SharedArtifactReactionsSelector extends ConsumerStatefulWidget {
  const SharedArtifactReactionsSelector({
    Key? key,
    required this.sharedArtifactId,
  }) : super(key: key);

  final String sharedArtifactId;

  @override
  _SharedArtifactReactionsSelectorState createState() => _SharedArtifactReactionsSelectorState();
}

class _SharedArtifactReactionsSelectorState extends ConsumerState<SharedArtifactReactionsSelector> {

  late List<String> availableReactions;

  late List<SharedArtifactsReaction> currentReactions;
  late CurrentAuthUser currentUser;
  late Map<String, int> reactionTotals;
  late Map<String, bool> myReactionsEnabled;
  late Map<String, String> myReactionIds;


  void updateReactionTotals({required bool isInit}) {
    if (isInit) {
      availableReactions = ref.read(sharedArtifactsReactionsAvailableProvider);
      currentUser = ref.read(currentUserProvider);
      currentReactions = ref.read(sharedArtifactSingleReactionsProvider(widget.sharedArtifactId));
      reactionTotals = {};
      myReactionsEnabled = {};
      myReactionIds = {};

    } else {
      // currentUser not modified, does not need to be watched.
      availableReactions = ref.watch(sharedArtifactsReactionsAvailableProvider);
      currentReactions = ref.watch(sharedArtifactSingleReactionsProvider(widget.sharedArtifactId));
    }

    availableReactions.forEach((availableReaction) {

      List<SharedArtifactsReaction> matchingAvailableReactions = currentReactions.where(
              (reaction) => reaction.value == availableReaction
      ).toList();

      int reactionCount = matchingAvailableReactions.length;

      reactionTotals[availableReaction] = reactionCount;

      // determine if there is a current user reaction within the matching reactions.
      int matchingOwnerReactionIndex = matchingAvailableReactions.indexWhere(
              (reaction) => reaction.ownedByCurrentUserId(currentUser.myUser!.id));

      if (matchingOwnerReactionIndex == -1) {
        myReactionsEnabled[availableReaction] = false;
      } else {
        myReactionsEnabled[availableReaction] = true;
        myReactionIds[availableReaction] = matchingAvailableReactions.elementAt(matchingOwnerReactionIndex).id;
      }
    });
  }


  Future<void> toggleReaction({
    required String currentReactionValue,
    required bool isEnabled,
    String? newReactionId,
  }) async {

    bool cancelAction = false;

    if (isEnabled) {
      // delete reaction
      setState(() {
        // prioritize updating the UI first, to increase responsiveness
        // update UI for the reaction
        myReactionsEnabled[currentReactionValue] = false;
        reactionTotals[currentReactionValue] = (reactionTotals[currentReactionValue] ?? 1) - 1;
      });

      // Abort a delete attempt if the newReactionId is null.
      // This is the case where an "add reaction" is still processing.
      cancelAction = (newReactionId == null);
      if (cancelAction) return;

      // make server request to delete reaction
      try {
        // no loading indicators, to increase responsiveness
        final SharedArtifactsReactionsService _reactions = SharedArtifactsReactionsService();


        Map<String, dynamic> reactionJson = await _reactions.deleteSharedArtifactReaction(
          reactionId: newReactionId,
        );
        // TODO: to remove IDE warning - will likely get used later
        print('$reactionJson');

        // merge onSubmitSuccess json back into Reactions!
        ref.read(sharedArtifactsReactionsProvider.notifier).withRemovedReactionById(newReactionId);

        setState(() {
          // only update myReactionIds after the network request.
          // This way we can suspend other actions until the request completes.
          myReactionIds.remove(currentReactionValue);
        });
      } catch (e) {
        String message = (e is HttpException)
            ? e.message
            : "Error Removing Reaction, please try again.";
        showSnackAlert(context, message);
      }

    } else {
      // add reaction
      setState(() {
        // prioritize updating the UI first, to increase responsiveness
        // update UI for the reaction
        myReactionsEnabled[currentReactionValue] = true;
        reactionTotals[currentReactionValue] = (reactionTotals[currentReactionValue] ?? 0) + 1;
      });
      // make server request to update reaction

      // Abort an "add reaction" attempt if the newReactionId already exists -
      // This is the case where a "delete reaction" is still processing.
      cancelAction = (newReactionId != null);
      if (cancelAction) return;

      // add a new reaction to the local collection, based on the server response.
      try {
        // no loading indicators, to increase responsiveness
        final SharedArtifactsReactionsService _reactions = SharedArtifactsReactionsService();

        Map<String, dynamic> reactionJson = await _reactions.addSharedArtifactReaction(
          sharedArtifactId: widget.sharedArtifactId,
          reactionValue: currentReactionValue,
        );
        // merge onSubmitSuccess json back into Reactions!
        ref.read(sharedArtifactsReactionsProvider.notifier).withAddedReactionJson(reactionJson);

        setState(() {
          // only update myReactionIds after the network request.
          // This way we can suspend other actions until the request completes.
          myReactionIds[currentReactionValue] = '${reactionJson['id']}';
        });
      } catch (e) {
        String message = (e is HttpException)
            ? e.message
            : "Error Adding Reaction, please try again.";
        showSnackAlert(context, message);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateReactionTotals(isInit: true);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Restore once server sync is enabled
    // updateReactionTotals(isInit: false);

    return Wrap(
      alignment: WrapAlignment.end,
      children: availableReactions.map((availableReaction) =>
        SharedArtifactReactionSelection(
          label: availableReaction,
          isEnabled: myReactionsEnabled[availableReaction]!,
          totalCount: reactionTotals[availableReaction]!,
          onTap: () {
            toggleReaction(
                currentReactionValue: availableReaction,
                isEnabled: myReactionsEnabled[availableReaction]!,
                newReactionId: myReactionIds[availableReaction],
            );
          },
    )).toList(),
    );
  }
}
