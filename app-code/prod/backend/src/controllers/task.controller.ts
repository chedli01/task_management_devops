import { Request, Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import TaskService from '../services/task.service';

class TaskController {
  async getAllTasks(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { status, priority } = req.query;
      const tasks = await TaskService.getUserTasks(req.user!.id, {
        status: status as string,
        priority: priority as string,
      });
      res.json(tasks);
    } catch (error) {
      next(error);
    }
  }

  async getTaskById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const task = await TaskService.getTaskById(req.params.id, req.user!.id);

      if (!task) {
        res.status(404).json({ error: 'Task not found' });
        return;
      }

      res.json(task);
    } catch (error) {
      next(error);
    }
  }

  async createTask(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        res.status(400).json({ errors: errors.array() });
        return;
      }

      const taskData = { ...req.body, userId: req.user!.id };
      const task = await TaskService.createTask(taskData);

      res.status(201).json(task);
    } catch (error) {
      next(error);
    }
  }

  async updateTask(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        res.status(400).json({ errors: errors.array() });
        return;
      }

      const task = await TaskService.updateTask(req.params.id, req.user!.id, req.body);

      if (!task) {
        res.status(404).json({ error: 'Task not found' });
        return;
      }

      res.json(task);
    } catch (error) {
      next(error);
    }
  }

  async deleteTask(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const deleted = await TaskService.deleteTask(req.params.id, req.user!.id);

      if (!deleted) {
        res.status(404).json({ error: 'Task not found' });
        return;
      }

      res.status(204).send();
    } catch (error) {
      next(error);
    }
  }
}

export default new TaskController();