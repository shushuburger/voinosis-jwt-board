import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import request from 'supertest';
import { App } from 'supertest/types';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/prisma/prisma.service';

describe('Auth (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;

  const validUser = {
    email: 'user@example.com',
    password: 'password123',
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
  });

  beforeEach(async () => {
    await prisma.post.deleteMany();
    await prisma.user.deleteMany();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('POST /auth/signup', () => {
    it('returns 201 and excludes password from response', async () => {
      const response = await request(app.getHttpServer())
        .post('/auth/signup')
        .send(validUser)
        .expect(201);

      expect(response.body).toMatchObject({
        email: validUser.email,
      });
      expect(response.body).toHaveProperty('id');
      expect(response.body).toHaveProperty('createdAt');
      expect(response.body).not.toHaveProperty('password');
    });

    it('returns 409 when email already exists', async () => {
      await request(app.getHttpServer()).post('/auth/signup').send(validUser);

      const response = await request(app.getHttpServer())
        .post('/auth/signup')
        .send(validUser)
        .expect(409);

      expect(response.body.message).toBe('Email already exists');
    });

    it('returns 400 when validation fails', async () => {
      await request(app.getHttpServer())
        .post('/auth/signup')
        .send({ email: 'not-an-email', password: 'short' })
        .expect(400);

      await request(app.getHttpServer())
        .post('/auth/signup')
        .send({ email: validUser.email })
        .expect(400);
    });
  });

  describe('POST /auth/login', () => {
    beforeEach(async () => {
      await request(app.getHttpServer()).post('/auth/signup').send(validUser);
    });

    it('returns 401 when email does not exist', async () => {
      const response = await request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: 'missing@example.com',
          password: validUser.password,
        })
        .expect(401);

      expect(response.body.message).toBe('Invalid credentials');
    });

    it('returns 401 when password is incorrect', async () => {
      const response = await request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: validUser.email,
          password: 'wrongpassword123',
        })
        .expect(401);

      expect(response.body.message).toBe('Invalid credentials');
    });

    it('returns 400 when validation fails', async () => {
      await request(app.getHttpServer())
        .post('/auth/login')
        .send({ email: 'not-an-email', password: 'short' })
        .expect(400);
    });
  });
});
