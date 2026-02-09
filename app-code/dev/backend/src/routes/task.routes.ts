import { Router } from 'express';
import TaskController from '../controllers/task.controller';
import { authMiddleware } from '../middleware/auth.middleware';
import { taskValidation, taskUpdateValidation } from '../middleware/validation';

const router = Router();

router.use(authMiddleware);

router.get('/', TaskController.getAllTasks);
router.get('/:id', TaskController.getTaskById);
router.post('/', taskValidation, TaskController.createTask);
router.put('/:id', taskUpdateValidation, TaskController.updateTask);
router.delete('/:id', TaskController.deleteTask);

export default router;