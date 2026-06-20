import {
  Body,
  Controller,
  Get,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RequestUser } from '../auth/types/request-user.type';
import { CreatePostDto } from './dto/create-post.dto';
import { FindPostsQueryDto } from './dto/find-posts-query.dto';
import { PostsService } from './posts.service';

type AuthenticatedRequest = Request & { user: RequestUser };

@Controller('posts')
export class PostsController {
  constructor(private readonly postsService: PostsService) {}

  @Get()
  findAll(@Query() query: FindPostsQueryDto) {
    const page = query.page ?? 1;
    const limit = query.limit ?? 10;

    return this.postsService.findAll(page, limit);
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  create(
    @Body() createPostDto: CreatePostDto,
    @Req() req: AuthenticatedRequest,
  ) {
    return this.postsService.create(req.user.userId, createPostDto);
  }
}
