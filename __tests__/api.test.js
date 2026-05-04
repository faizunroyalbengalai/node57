'use strict';

const request = require('supertest');
const app = require('../src/app');

jest.mock('../src/config/database', () => ({
  sequelize: {
    authenticate: jest.fn().mockResolvedValue(true),
    close: jest.fn().mockResolvedValue(true),
  },
  checkDbConnection: jest.fn().mockResolvedValue(true),
}));

describe('GET /api/info', () => {
  it('should return 200 with app info', async () => {
    const response = await request(app).get('/api/info');
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('app');
    expect(response.body).toHaveProperty('version');
    expect(response.body).toHaveProperty('db');
    expect(response.body.db).toHaveProperty('status');
  });

  it('should return db status as connected when db is up', async () => {
    const response = await request(app).get('/api/info');
    expect(response.body.db.status).toBe('connected');
  });

  it('should return db status as disconnected when db is down', async () => {
    const { checkDbConnection } = require('../src/config/database');
    checkDbConnection.mockResolvedValueOnce(false);

    const response = await request(app).get('/api/info');
    expect(response.body.db.status).toBe('disconnected');
  });

  it('should return JSON content type', async () => {
    const response = await request(app).get('/api/info');
    expect(response.headers['content-type']).toMatch(/json/);
  });

  it('should include a timestamp', async () => {
    const response = await request(app).get('/api/info');
    expect(response.body).toHaveProperty('timestamp');
    expect(new Date(response.body.timestamp).toString()).not.toBe('Invalid Date');
  });
});

describe('GET /unknown-route', () => {
  it('should return 404 for unknown routes', async () => {
    const response = await request(app).get('/unknown-route');
    expect(response.status).toBe(404);
    expect(response.body).toHaveProperty('error');
  });
});