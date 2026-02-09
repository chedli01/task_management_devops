import { Router } from 'express';
import AuthController from '../controllers/auth.controller';
import { authMiddleware } from '../middleware/auth.middleware';
import { registerValidation, loginValidation } from '../middleware/validation';

const router = Router();

router.post('/register', registerValidation, AuthController.register);
router.post('/login', loginValidation, AuthController.login);
router.get('/profile', authMiddleware, AuthController.getProfile);

export default router;