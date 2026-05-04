'use strict';

const express = require('express');

const router = express.Router();

/**
 * GET /health
 * Returns basic health status of the application.
 */
router.get('/', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

module.exports = router;