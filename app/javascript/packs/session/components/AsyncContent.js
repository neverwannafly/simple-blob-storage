import React from 'react';

function AsyncContent({
  isLoading,
  error,
  children,
  onRetry,
}) {
  if (isLoading) {
    return (
      <div className="async-content">
        <div
          className="spinner-border text-primary"
          style={{width: '5rem', height: '5rem'}}
          role="status"
        >
          <span className="sr-only">Loading...</span>
        </div>
      </div>
    );
  }
  if (error) {
    return (
      <div className="async-content">
        <h4>Failed to load data</h4>
        <button
          onClick={onRetry}
          className="btn btn-info"
        >
          Try Again
        </button>
      </div>
    );
  }

  return children;
}

export default AsyncContent;
