'use strict';

const logger = require('../utils/logger');

// eslint-disable-next-line no-unused-vars
function errorHandler(err, req, res, next) {
  const status = err.status || err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  logger.error(`${status} - ${message} - ${req.originalUrl} - ${req.method} - ${req.ip}`);

  if (process.env.NODE_ENV === 'production') {
    res.status(status).json({
      error: status >= 500 ? 'Internal Server Error' : message,
    });
  } else {
    res.status(status).json({
      error: message,
      stack: err.stack,
    });
  }
}

module.exports = errorHandler;