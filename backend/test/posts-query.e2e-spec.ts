import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import request from 'supertest';
import { App } from 'supertest/types';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/prisma/prisma.service';

describe('Posts query validation (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;

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

  describe('GET /posts', () => {
    it('returns 400 when page query is invalid', async () => {
      await request(app.getHttpServer()).get('/posts?page=abc').expect(400);
      await request(app.getHttpServer()).get('/posts?page=0').expect(400);
    });

    it('returns 400 when limit query is invalid', async () => {
      await request(app.getHttpServer()).get('/posts?limit=abc').expect(400);
      await request(app.getHttpServer()).get('/posts?limit=-1').expect(400);
    });

    it('uses default page=1 and limit=10 when query is omitted', async () => {
      const user = await prisma.user.create({
        data: {
          email: 'user@example.com',
          password: 'hashed-password',
        },
      });

      await prisma.post.create({
        data: {
          title: 'Test post',
          content: 'Test content',
          authorId: user.id,
        },
      });

      const response = await request(app.getHttpServer())
        .get('/posts')
        .expect(200);

      expect(response.body.meta).toMatchObject({
        page: 1,
        total: 1,
        lastPage: 1,
      });
      expect(response.body.data).toHaveLength(1);
    });

    it('returns paginated results for valid page and limit', async () => {
      const user = await prisma.user.create({
        data: {
          email: 'user@example.com',
          password: 'hashed-password',
        },
      });

      for (let i = 1; i <= 3; i++) {
        await prisma.post.create({
          data: {
            title: `Post ${i}`,
            content: `Content ${i}`,
            authorId: user.id,
          },
        });
      }

      const response = await request(app.getHttpServer())
        .get('/posts?page=2&limit=2')
        .expect(200);

      expect(response.body.meta).toMatchObject({
        page: 2,
        total: 3,
        lastPage: 2,
      });
      expect(response.body.data).toHaveLength(1);
    });
  });
});
