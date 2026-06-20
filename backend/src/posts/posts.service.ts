import { Injectable } from '@nestjs/common';
import { Post } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CreatePostDto } from './dto/create-post.dto';

type PaginatedPosts = {
  data: Post[];
  meta: {
    total: number;
    page: number;
    lastPage: number;
  };
};

@Injectable()
export class PostsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(page: number, limit: number): Promise<PaginatedPosts> {
    const skip = (page - 1) * limit;

    const [data, total] = await Promise.all([
      this.prisma.post.findMany({
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.post.count(),
    ]);

    return {
      data,
      meta: {
        total,
        page,
        lastPage: Math.ceil(total / limit),
      },
    };
  }

  create(authorId: number, createPostDto: CreatePostDto): Promise<Post> {
    return this.prisma.post.create({
      data: {
        title: createPostDto.title,
        content: createPostDto.content,
        authorId,
      },
    });
  }
}
