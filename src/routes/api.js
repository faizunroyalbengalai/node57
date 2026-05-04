'use strict';

const express = require('express');
const { checkDbConnection } = require('../config/database');

const router = express.Router();

/**
 * GET /api/info
 * Returns application name, version, and database connection status.
 */
router.get('/info', async (req, res, next) => {
  try {
    const dbConnected = await checkDbConnection();

    res.status(200).json({
      app: process.env.APP_NAME || 'node57',
      version: process.env.APP_VERSION || '1.0.0',
      environment: process.env.NODE_ENV || 'development',
      db: {
        status: dbConnected ? 'connected' : 'disconnected',
        dialect: 'mysql',
      },
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;