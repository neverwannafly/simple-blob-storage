import { whenDocReady, apiRequest } from '../utils';

whenDocReady(() => {
  const authActionClass = 'home__auth-action';
  const authActionButtons = document.getElementsByClassName(authActionClass);

  Array.from(authActionButtons).forEach((button) => {
    button.addEventListener('click', async () => {
      const buttonId = button.dataset.target;
      const tokenScope = document.getElementsByClassName(
        `home__token-scope-${buttonId}`
      )[0].innerText;
      const tokenName = document.getElementsByClassName(
        `home__token-name-${buttonId}`
      )[0].innerText;

      const { token } = await apiRequest('POST', '/reveal-token', {
        token_name: tokenName,
        token_scope: tokenScope,
      });

      const tokenContainer = document.getElementsByClassName(
        `home__auth-token-${buttonId}`
      )[0];

      tokenContainer.innerText = token;
      button.innerText = '';
      button.classList.remove(authActionClass);
    })
  })
});