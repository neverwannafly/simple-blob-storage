import { apiRequest } from '../utils';

function createActionCommands(commandList) {
  const commands = {};
  commandList.forEach((command) => {
    commands[command] = async (options = '') => {
      const { output } = await apiRequest('POST', `/session/rpc`, { options, command });
      return output;
    };
  });
  return commands;
}

const commandList = [
  'ping', 'ls', 'pwd', 'touch', 'cp', 'cat',
]

export default createActionCommands(commandList);