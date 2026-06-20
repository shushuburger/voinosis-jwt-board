import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import request from 'supertest';
import { App } from 'supertest/types';
import { AppModule } from '../src/app.module';

describe('Route not found (e2e)', () => {
  let app: INestApplication<App>;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({
        transform: true,
      }),
    );
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('returns 404 for non-existent GET route', async () => {
    const response = await request(app.getHttpServer())
      .get('/unknown-route')
      .expect(404);

    expect(response.body).toMatchObject({
      statusCode: 404,
      error: 'Not Found',
    });
    expect(response.body.message).toContain('Cannot GET /unknown-route');
  });

  it('returns 404 for non-existent POST route', async () => {
    const response = await request(app.getHttpServer())
      .post('/auth/unknown')
      .send({})
      .expect(404);

    expect(response.body).toMatchObject({
      statusCode: 404,
      error: 'Not Found',
    });
    expect(response.body.message).toContain('Cannot POST /auth/unknown');
  });
});
