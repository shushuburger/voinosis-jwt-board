import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test, TestingModule } from '@nestjs/testing';
import * as jwt from 'jsonwebtoken';
import request from 'supertest';
import { App } from 'supertest/types';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/prisma/prisma.service';

describe('JWT Auth on POST /posts (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;
  let jwtSecret: string;

  const validUser = {
    email: 'user@example.com',
    password: 'password123',
  };

  const validPost = {
    title: 'Test title',
    content: 'Test content',
  };

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

    prisma = app.get(PrismaService);
    jwtSecret = app.get(ConfigService).getOrThrow<string>('JWT_SECRET');
  });

  beforeEach(async () => {
    await prisma.post.deleteMany();
    await prisma.user.deleteMany();
  });

  afterAll(async () => {
    await app.close();
  });

  async function getAccessToken(): Promise<string> {
    await request(app.getHttpServer()).post('/auth/signup').send(validUser);

    const loginResponse = await request(app.getHttpServer())
      .post('/auth/login')
      .send(validUser)
      .expect(201);

    return loginResponse.body.accessToken as string;
  }

  describe('POST /posts', () => {
    it('returns 401 when JWT is missing', async () => {
      await request(app.getHttpServer())
        .post('/posts')
        .send(validPost)
        .expect(401);
    });

    it('returns 401 when Authorization header is not Bearer format', async () => {
      const accessToken = await getAccessToken();

      await request(app.getHttpServer())
        .post('/posts')
        .set('Authorization', accessToken)
        .send(validPost)
        .expect(401);
    });

    it('returns 401 when JWT is invalid', async () => {
      await request(app.getHttpServer())
        .post('/posts')
        .set('Authorization', 'Bearer invalid.jwt.token')
        .send(validPost)
        .expect(401);
    });

    it('returns 401 when JWT is expired', async () => {
      await request(app.getHttpServer()).post('/auth/signup').send(validUser);

      const expiredToken = jwt.sign(
        { sub: 1, email: validUser.email },
        jwtSecret,
        { expiresIn: '-1s' },
      );

      await request(app.getHttpServer())
        .post('/posts')
        .set('Authorization', `Bearer ${expiredToken}`)
        .send(validPost)
        .expect(401);
    });

    it('returns 401 when JWT is forged with wrong secret', async () => {
      await request(app.getHttpServer()).post('/auth/signup').send(validUser);

      const forgedToken = jwt.sign(
        { sub: 1, email: validUser.email },
        'wrong-secret-key',
        { expiresIn: '1d' },
      );

      await request(app.getHttpServer())
        .post('/posts')
        .set('Authorization', `Bearer ${forgedToken}`)
        .send(validPost)
        .expect(401);
    });

    it('returns 201 when JWT is valid', async () => {
      const accessToken = await getAccessToken();

      const response = await request(app.getHttpServer())
        .post('/posts')
        .set('Authorization', `Bearer ${accessToken}`)
        .send(validPost)
        .expect(201);

      expect(response.body).toMatchObject({
        title: validPost.title,
        content: validPost.content,
      });
      expect(response.body).toHaveProperty('authorId');
      expect(response.body).toHaveProperty('id');
    });
  });
});
