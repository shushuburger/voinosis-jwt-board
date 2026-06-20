import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import request from 'supertest';
import { App } from 'supertest/types';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/prisma/prisma.service';

describe('Create Post body validation (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;
  let accessToken: string;

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

    await request(app.getHttpServer()).post('/auth/signup').send(validUser);

    const loginResponse = await request(app.getHttpServer())
      .post('/auth/login')
      .send(validUser)
      .expect(201);

    accessToken = loginResponse.body.accessToken as string;
  });

  afterAll(async () => {
    await app.close();
  });

  function createPost(body: Record<string, unknown>) {
    return request(app.getHttpServer())
      .post('/posts')
      .set('Authorization', `Bearer ${accessToken}`)
      .send(body);
  }

  describe('POST /posts', () => {
    it('returns 400 when title is missing', async () => {
      await createPost({ content: 'Test content' }).expect(400);
    });

    it('returns 400 when content is missing', async () => {
      await createPost({ title: 'Test title' }).expect(400);
    });

    it('returns 400 when title is an empty string', async () => {
      await createPost({ title: '', content: 'Test content' }).expect(400);
    });

    it('returns 400 when content is an empty string', async () => {
      await createPost({ title: 'Test title', content: '' }).expect(400);
    });

    it('returns 201 when title and content are valid', async () => {
      const response = await createPost({
        title: 'Test title',
        content: 'Test content',
      }).expect(201);

      expect(response.body).toMatchObject({
        title: 'Test title',
        content: 'Test content',
      });
    });
  });
});
