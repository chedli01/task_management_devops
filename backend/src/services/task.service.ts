import Task from '../models/Task';
import redisClient from '../config/redis';
import { ITask } from '../types';

interface TaskFilters {
  status?: string;
  priority?: string;
}

class TaskService {
  async getUserTasks(userId: string, filters: TaskFilters = {}): Promise<Task[]> {
    const cacheKey = `tasks:${userId}:${JSON.stringify(filters)}`;

    try {
      const cached = await redisClient.get(cacheKey);
      if (cached) {
        console.log('✅ Cache hit for tasks');
        return JSON.parse(cached);
      }
    } catch (error) {
      console.error('Redis error:', error);
    }

    const where: any = { userId };
    if (filters.status) where.status = filters.status;
    if (filters.priority) where.priority = filters.priority;

    const tasks = await Task.findAll({
      where,
      order: [['createdAt', 'DESC']],
    });

    try {
      await redisClient.setEx(cacheKey, 300, JSON.stringify(tasks));
    } catch (error) {
      console.error('Redis error:', error);
    }

    return tasks;
  }

  async getTaskById(taskId: string, userId: string): Promise<Task | null> {
    return Task.findOne({ where: { id: taskId, userId } });
  }

  async createTask(taskData: Partial<ITask>): Promise<Task> {
    const task = await Task.create(taskData as any);

    await this.invalidateCache(taskData.userId!);

    return task;
  }

  async updateTask(taskId: string, userId: string, updates: Partial<ITask>): Promise<Task | null> {
    const task = await Task.findOne({ where: { id: taskId, userId } });

    if (!task) {
      return null;
    }

    await task.update(updates);
    await this.invalidateCache(userId);

    return task;
  }

  async deleteTask(taskId: string, userId: string): Promise<boolean> {
    const task = await Task.findOne({ where: { id: taskId, userId } });

    if (!task) {
      return false;
    }

    await task.destroy();
    await this.invalidateCache(userId);

    return true;
  }

  private async invalidateCache(userId: string): Promise<void> {
    try {
      const keys = await redisClient.keys(`tasks:${userId}:*`);
      if (keys.length > 0) {
        await redisClient.del(keys);
      }
    } catch (error) {
      console.error('Redis error:', error);
    }
  }
}

export default new TaskService();