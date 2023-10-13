import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section, AnimatedNumber } from '../components';
import { Window } from '../layouts';
import { toFixed } from 'common/math';

export const SiliconNode = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    online,
    canUpgrade,
  } = data;
  return (
    <Window
      width={280}
      height={132}>
      <Window.Content>
        <Button
          icon="power-off"
          content="Toggle Power"
          textAlign="center"
          selected={online}
          onClick={() => act('Toggle power')} />
        asd
        <Button
          icon="power-on"
          content="Upgrade to CPU"
          textAlign="center"
          onClick={() => act('Node selection', 'NODE_CPU')} />
      </Window.Content>
    </Window>
  );
};
