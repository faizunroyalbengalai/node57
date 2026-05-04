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

describe('GET /health', () => {
  it('should return 200 with status ok', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body).toEqual({ status: 'ok' });
  });

  it('should return JSON content type', async () => {
    const response = await request(app).get('/health');
    expect(response.headers['content-type']).toMatch(/json/);
  });
});