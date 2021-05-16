import { apiRequest, copyToClipboard } from '../utils';

function createActionCommands(commandList) {
  const commands = {};
  commandList.forEach((command) => {
    commands[command] = async (options = '') => {
      const { output } = await apiRequest('POST', `/session/rpc`, { options, command });
      return output;
    };
  });

  // Advance commands
  commands['cd'] = async (dir) => {
    try {
      await apiRequest('POST', '/session/cd', { dir });
    } catch (err) {
      return "Invalid Directory";
    }
  }

  commands['link'] = async (name) => {
    try {
      const { link } = await apiRequest('POST', '/session/link', {name});
      const fullLink = `${window.location.host}/${link}`;
      copyToClipboard(fullLink)
      return fullLink;
    } catch (err) {
      return "Invalid File Name";
    }
  }

  commands['upload'] = async (newFileName) => {
    var el = window._protected_reference = document.createElement("INPUT");
    el.type = "file";
    el.accept = "image/*";
    let output = null;
    
    el.addEventListener('change', async () => {
      const file = el.files[0];
      const base64File = await new Promise((resolve) => {
        const reader = new FileReader()
        reader.onloadend = () => resolve(reader.result)
        reader.readAsDataURL(file)
      });

      const formData = new FormData();
      formData.append('file', base64File);
      formData.append('file_size', file.size);
      formData.append('file_type', file.type);
      formData.append('file_name', file.name);
      formData.append('newFileName', newFileName);

      const headers = {};
      const csrfMeta = document.querySelector('meta[name="csrf-token"]');
      if (csrfMeta) {
        headers['X-CSRF-Token'] = csrfMeta.content;
      }

      try {
        await fetch('session/upload-file', { method: 'POST', body: formData, headers });
        output = 'File Uploaded Successfully';
      } catch(err) {
        output = 'File Upload Failed';
      }
      el = window._protected_reference = undefined;
    });

    el.click();
    await new Promise((resolve) => {
      const interval = setInterval(() => {
        if (output) {
          resolve();
          clearInterval(interval);
        }
      }, 1000)
    });

    return output;
  }

  return commands;
}

const commandList = [
  'ping', 'ls', 'pwd', 'touch', 'cp', 'cat', 'mkdir',
]

export default createActionCommands(commandList);