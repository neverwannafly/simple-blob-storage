import React, { useEffect } from 'react';
import { ReactTerminal } from "react-terminal";
import { useSelector, shallowEqual, useDispatch } from 'react-redux';

import { loadSession } from './store/session';
import commands from './commands';

import AsyncContent from './components/AsyncContent';

function Session() {
  const {
    data,
    isLoading,
    error,
  } = useSelector((state) => state.session, shallowEqual);
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(loadSession());
  }, []);

  function contentUi() {
    return (
      <AsyncContent
        isLoading={isLoading}
        onRetry={() => dispatch(loadSession(loadSession(true)))}
        error={error}
      >
        <ReactTerminal
          commands={commands}
          showControlButtons={false}
        />
      </AsyncContent>
    );
  }

  return (
    <div className="rpc-session container">
      <div className="rpc-session__terminal">
        {contentUi()}
      </div>
      <div className="rpc-session__actions">
        <button className="btn btn-block btn-outline-success">
          End Session
        </button>
      </div>
    </div>
  );
};

export default Session;
