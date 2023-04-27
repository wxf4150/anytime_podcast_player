import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/l10n/L.dart';
import 'package:anytime/state/sleep_policy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SleepSelector extends StatelessWidget {
  final Widget iconOn;
  final Widget iconOff;
  final BoxConstraints constraints;
  final EdgeInsetsGeometry padding;

  const SleepSelector({
    Key key,
    this.iconOn,
    this.iconOff,
    this.constraints,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final theme = Theme.of(context);
    final texts = L.of(context);

    return StreamBuilder<SleepPolicy>(
      stream: audioBloc.sleepPolicy,
      builder: (context, snapshot) {
        final sleepPolicy = snapshot.data ?? sleepPolicyOff(true);
        return Tooltip(
          message: texts.sleep_episode_function_header,
          child: ElevatedButton(
            onPressed: () {
              presentSleepPolicyOptions(
                context,
                theme,
                texts,
                audioBloc,
                sleepPolicy,
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: padding,
              foregroundColor: theme.primaryColor,
              backgroundColor: theme.canvasColor,
              fixedSize: const Size(48.0, 48.0),
              shape: const CircleBorder(),
            ),
            child: _icon(theme, sleepPolicy),
          ),
        );
      },
    );
  }

  void presentSleepPolicyOptions(
    BuildContext context,
    ThemeData theme,
    L texts,
    AudioBloc audioBloc,
    SleepPolicy sleepPolicy,
  ) {
    final options = sleepOptions(texts, sleepPolicy);
    final groupValue = _groupValue(sleepPolicy, options);
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            texts.sleep_episode_function_header,
          ),
          scrollable: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                texts.cancel_button_label,
              ),
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(
              options.length,
              (int index) => dialogItemTile(
                context,
                theme,
                texts,
                audioBloc,
                groupValue,
                options[index],
              ),
            ),
          ),
        );
      },
    );
  }

  void changeSleepPolicy(
    BuildContext context,
    L texts,
    AudioBloc audioBloc,
    SleepPolicy newPolicy,
  ) {
    audioBloc.changeSleepPolicy(newPolicy);
    Navigator.pop(context);
  }

  List<SleepOption> sleepOptions(L texts, SleepPolicy sleepPolicy) {
    var options = <SleepOption>[];
    if (sleepPolicy is! SleepPolicyOff) {
      options.add(SleepOption(
        texts.sleep_episode_function_turn_off,
        sleepPolicyOff(),
      ));
    }
    options.addAll(
      [
        SleepOption(
          texts.sleep_episode_function_5_minutes,
          sleepPolicyMinutes(5),
        ),
        SleepOption(
          texts.sleep_episode_function_15_minutes,
          sleepPolicyMinutes(15),
        ),
        SleepOption(
          texts.sleep_episode_function_30_minutes,
          sleepPolicyMinutes(30),
        ),
        SleepOption(
          texts.sleep_episode_function_45_minutes,
          sleepPolicyMinutes(45),
        ),
        SleepOption(
          texts.sleep_episode_function_60_minutes,
          sleepPolicyMinutes(60),
        ),
        SleepOption(
          texts.sleep_episode_function_end_of_episode,
          sleepPolicyEndOfEpisode(),
        ),
      ],
    );
    return options;
  }

  Widget dialogItemTile(
    BuildContext context,
    ThemeData theme,
    L texts,
    AudioBloc audioBloc,
    SleepPolicy groupValue,
    SleepOption option,
  ) {
    return InkWell(
      highlightColor: theme.buttonTheme.colorScheme.onPrimary.withAlpha(50),
      onTap: () {
        changeSleepPolicy(context, texts, audioBloc, option.policy);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Row(
          children: <Widget>[
            Radio<SleepPolicy>(
              groupValue: groupValue,
              value: option.policy,
              onChanged: (newValue) {
                if (newValue != null) {
                  changeSleepPolicy(context, texts, audioBloc, newValue);
                }
              },
              fillColor: theme.radioTheme.fillColor,
            ),
            Expanded(
              child: Text(
                option.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _icon(ThemeData theme, SleepPolicy sleepPolicy) {
    if (sleepPolicy is SleepPolicyOff) {
      return iconOff ??
          Icon(
            Icons.nightlight_outlined,
            size: 24.0,
          );
    } else {
      return iconOn ??
          Icon(
            Icons.nightlight_round,
            size: 24.0,
          );
    }
  }

  SleepPolicy _groupValue(SleepPolicy sleepPolicy, List<SleepOption> options) {
    if (sleepPolicy is SleepPolicyTimer) {
      for (var option in options) {
        final policy = option.policy;
        if (policy is SleepPolicyTimer) {
          if (policy.duration == sleepPolicy.duration) {
            return policy;
          }
        }
      }
    }
    return sleepPolicy;
  }
}

class SleepOption {
  final String label;
  final SleepPolicy policy;

  const SleepOption(
    this.label,
    this.policy,
  );
}
