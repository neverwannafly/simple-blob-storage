import { apiRequest } from '../utils';

function createActionCommands(commandList) {
  const commands = {};
  commandList.forEach((command) => {
    commands[command] = async () => {
      const { output } = await apiRequest('POST', `/session/${command}`);
      return output;
    };
  });
  return commands;
}

const commandList = [
  'ping', 'ls',
]

export default createActionCommands(commandList);